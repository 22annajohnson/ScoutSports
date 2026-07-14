//
//  SwipeDeckViewModel.swift
//  Scout
//
//  Created by Codex on 4/1/26.
//

import Foundation
import Observation

@MainActor
@Observable
final class SwipeDeckViewModel {
    struct AlertItem: Identifiable, Equatable {
        let id = UUID()
        let title: String
        let message: String
    }

    enum QueuePresentationState: Equatable {
        case idle
        case loading
        case ready
        case empty(DiscoveryEmptyReason?)
        case exhausted(DiscoveryExhaustedReason?)
        case refreshing
        case failed(DiscoveryQueueFailure, DiscoveryRetryGuidance?)
    }

    private let cardProvider: SwipeCardProviding?
    private let discoveryRepository: DiscoveryRepository?
    private let session: SessionStore

    private(set) var rankingContext: SwipeRankingContext?
    private(set) var candidates: [SwipeCandidate] = []
    private(set) var cards: [CardViewModel] = []
    private(set) var candidateCards: [CandidateCard] = []
    private(set) var discoveryQueue = DiscoveryQueue()
    private(set) var queuePresentationState: QueuePresentationState = .idle
    private(set) var isLoading = true
    var alert: AlertItem?

    private var hasLoadedCards = false
    private var lastDiscoveryFailure: DiscoveryQueueFailure?

    init(cardProvider: SwipeCardProviding, session: SessionStore) {
        self.cardProvider = cardProvider
        self.discoveryRepository = nil
        self.session = session
    }

    init(discoveryRepository: DiscoveryRepository, session: SessionStore) {
        self.cardProvider = nil
        self.discoveryRepository = discoveryRepository
        self.session = session
    }

    func loadCardsIfNeeded() async {
        guard !hasLoadedCards else { return }
        hasLoadedCards = true
        if discoveryRepository != nil {
            await loadDiscoveryQueue()
        } else {
            await loadCards()
        }
    }

    func refreshDiscoveryQueue() async {
        guard let discoveryRepository else { return }
        guard queuePresentationState != .loading, queuePresentationState != .refreshing else { return }

        let existingQueue = discoveryQueue
        queuePresentationState = .refreshing
        discoveryQueue = DiscoveryQueue.refreshing(existing: existingQueue)

        let refreshedQueue = await discoveryRepository.refreshQueue(existing: existingQueue)
        applyDiscoveryQueue(refreshedQueue, preserveExistingQueueOnFailure: !candidateCards.isEmpty)
    }

    func retryDiscoveryQueue() async {
        guard let discoveryRepository else { return }

        let failure = discoveryQueue.failure ?? lastDiscoveryFailure
        queuePresentationState = .loading
        isLoading = candidateCards.isEmpty

        let retriedQueue = await discoveryRepository.retryQueue(after: failure)
        applyDiscoveryQueue(retriedQueue, preserveExistingQueueOnFailure: !candidateCards.isEmpty)
        isLoading = false
    }

    func markDiscoveryQueueExhausted(reason: DiscoveryExhaustedReason = .allCandidatesPresented) {
        let exhaustedQueue = DiscoveryQueue.exhausted(
            id: discoveryQueue.id,
            candidates: candidateCards,
            reason: reason,
            generatedAt: discoveryQueue.metadata.generatedAt ?? Date()
        )

        discoveryQueue = exhaustedQueue
        queuePresentationState = .exhausted(reason)
        candidateCards = []
        cards = []
    }

    func signOut() async {
        do {
            try await session.signOut()
        } catch {
            alert = AlertItem(
                title: "Sign out failed",
                message: error.localizedDescription
            )
        }
    }

    private func loadCards() async {
        isLoading = true
        defer { isLoading = false }

        do {
            guard let cardProvider else { return }
            let batch = try await cardProvider.fetchSwipeCandidates()
            rankingContext = batch.rankingContext
            candidates = batch.candidates
            cards = candidates.map { $0.toCardViewModel() }
        } catch {
            rankingContext = nil
            candidates = []
            cards = []
            alert = AlertItem(
                title: "Couldn’t load players",
                message: error.localizedDescription
            )
        }
    }

    private func loadDiscoveryQueue() async {
        guard let discoveryRepository else { return }

        isLoading = true
        queuePresentationState = .loading

        let queue = await discoveryRepository.loadQueue()
        applyDiscoveryQueue(queue, preserveExistingQueueOnFailure: false)
        isLoading = false
    }

    private func applyDiscoveryQueue(
        _ queue: DiscoveryQueue,
        preserveExistingQueueOnFailure: Bool
    ) {
        switch queue.state {
        case .ready:
            discoveryQueue = queue
            candidateCards = queue.candidates
            cards = queue.candidates.map { $0.toCardViewModel() }
            lastDiscoveryFailure = nil
            queuePresentationState = .ready
        case .empty:
            discoveryQueue = queue
            candidateCards = []
            cards = []
            lastDiscoveryFailure = nil
            queuePresentationState = .empty(queue.emptyReason)
        case .exhausted:
            discoveryQueue = queue
            candidateCards = []
            cards = []
            lastDiscoveryFailure = nil
            queuePresentationState = .exhausted(queue.exhaustedReason)
        case .failed:
            if !preserveExistingQueueOnFailure {
                discoveryQueue = queue
                candidateCards = []
                cards = []
            }

            if let failure = queue.failure {
                lastDiscoveryFailure = failure
                queuePresentationState = .failed(failure, queue.retryGuidance)
            }
        case .loading:
            discoveryQueue = queue
            queuePresentationState = .loading
        case .refreshing:
            discoveryQueue = queue
            queuePresentationState = .refreshing
        case .idle:
            discoveryQueue = queue
            queuePresentationState = .idle
        }
    }
}
