//
//  SwipeDeckViewModelQueueStateTests.swift
//  ScoutTests
//
//  Created by Codex on 7/14/26.
//

import XCTest
@testable import Scout

@MainActor
final class SwipeDeckViewModelQueueStateTests: XCTestCase {
    private let queueID = UUID(uuidString: "00000000-0000-0000-0000-000000000060")!
    private let generatedAt = Date(timeIntervalSince1970: 1_784_000_000)

    func test_loadCardsIfNeeded_withReadyQueueStoresCandidateCards() async {
        let viewModel = makeViewModel(repository: MockDiscoveryRepository())

        await viewModel.loadCardsIfNeeded()

        XCTAssertEqual(viewModel.queuePresentationState, .ready)
        XCTAssertEqual(viewModel.candidateCards, MockDiscoveryRepository.defaultCandidates)
        XCTAssertFalse(viewModel.isLoading)
    }

    func test_loadCardsIfNeeded_withEmptyQueueStoresEmptyReason() async {
        let viewModel = makeViewModel(repository: MockDiscoveryRepository(
            loadScenario: .empty(reason: .noEligibleCandidates)
        ))

        await viewModel.loadCardsIfNeeded()

        XCTAssertEqual(viewModel.queuePresentationState, .empty(.noEligibleCandidates))
        XCTAssertTrue(viewModel.candidateCards.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
    }

    func test_loadCardsIfNeeded_withExhaustedQueueStoresExhaustedReason() async {
        let viewModel = makeViewModel(repository: MockDiscoveryRepository(
            loadScenario: .exhausted(
                candidates: MockDiscoveryRepository.defaultCandidates,
                reason: .allCandidatesPresented
            )
        ))

        await viewModel.loadCardsIfNeeded()

        XCTAssertEqual(viewModel.queuePresentationState, .exhausted(.allCandidatesPresented))
        XCTAssertTrue(viewModel.candidateCards.isEmpty)
    }

    func test_loadCardsIfNeeded_withFailureStoresRetryableFailure() async {
        let failure = DiscoveryQueueFailure(
            kind: .serviceUnavailable,
            message: "Discovery is temporarily unavailable."
        )
        let viewModel = makeViewModel(repository: MockDiscoveryRepository(
            loadScenario: .failed(failure: failure, retryGuidance: .tryLater)
        ))

        await viewModel.loadCardsIfNeeded()

        XCTAssertEqual(viewModel.queuePresentationState, .failed(failure, .tryLater))
        XCTAssertEqual(viewModel.discoveryQueue.failure, failure)
        XCTAssertTrue(viewModel.candidateCards.isEmpty)
    }

    func test_refreshDiscoveryQueue_preservesExistingQueueOnRefreshFailure() async {
        let failure = DiscoveryQueueFailure(
            kind: .networkUnavailable,
            message: "Check your connection."
        )
        let repository = MockDiscoveryRepository(
            loadScenario: .ready(candidates: MockDiscoveryRepository.defaultCandidates),
            refreshScenario: .failed(failure: failure, retryGuidance: .manualRetry)
        )
        let viewModel = makeViewModel(repository: repository)

        await viewModel.loadCardsIfNeeded()
        await viewModel.refreshDiscoveryQueue()
        await viewModel.retryDiscoveryQueue()

        XCTAssertEqual(viewModel.queuePresentationState, .ready)
        XCTAssertEqual(viewModel.candidateCards, MockDiscoveryRepository.defaultCandidates)
        XCTAssertEqual(repository.refreshCallCount, 1)
        XCTAssertEqual(repository.lastRetriedFailure, failure)
    }

    func test_retryDiscoveryQueue_replacesFailureWithReadyQueue() async {
        let failure = DiscoveryQueueFailure(
            kind: .serviceUnavailable,
            message: "Discovery is temporarily unavailable."
        )
        let repository = MockDiscoveryRepository(
            loadScenario: .failed(failure: failure, retryGuidance: .manualRetry),
            retryScenario: .ready(candidates: MockDiscoveryRepository.defaultCandidates)
        )
        let viewModel = makeViewModel(repository: repository)

        await viewModel.loadCardsIfNeeded()
        await viewModel.retryDiscoveryQueue()

        XCTAssertEqual(viewModel.queuePresentationState, .ready)
        XCTAssertEqual(viewModel.candidateCards, MockDiscoveryRepository.defaultCandidates)
        XCTAssertEqual(repository.retryCallCount, 1)
        XCTAssertEqual(repository.lastRetriedFailure, failure)
    }

    func test_markDiscoveryQueueExhaustedClearsVisibleCandidateCardsWithoutDuplicatingCandidates() async {
        let viewModel = makeViewModel(repository: MockDiscoveryRepository(
            loadScenario: .ready(candidates: MockDiscoveryRepository.defaultCandidates)
        ))

        await viewModel.loadCardsIfNeeded()
        viewModel.markDiscoveryQueueExhausted()

        XCTAssertEqual(viewModel.queuePresentationState, .exhausted(.allCandidatesPresented))
        XCTAssertEqual(
            viewModel.discoveryQueue.metadata.presentedCandidateIDs,
            Set(MockDiscoveryRepository.defaultCandidates.map(\.id))
        )
        XCTAssertTrue(viewModel.candidateCards.isEmpty)
    }

    private func makeViewModel(repository: MockDiscoveryRepository) -> SwipeDeckViewModel {
        SwipeDeckViewModel(
            discoveryRepository: repository,
            session: SessionStore(
                authService: MockAuthService(),
                profileRepository: MockProfileRepository()
            )
        )
    }
}
