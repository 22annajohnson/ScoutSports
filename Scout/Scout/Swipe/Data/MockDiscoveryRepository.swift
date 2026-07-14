//
//  MockDiscoveryRepository.swift
//  Scout
//
//  Created by Codex on 7/14/26.
//

import Foundation

final class MockDiscoveryRepository: DiscoveryRepository {
    enum Scenario: Equatable {
        case ready(candidates: [CandidateCard])
        case empty(reason: DiscoveryEmptyReason)
        case exhausted(candidates: [CandidateCard], reason: DiscoveryExhaustedReason)
        case failed(failure: DiscoveryQueueFailure, retryGuidance: DiscoveryRetryGuidance?)
    }

    private let loadScenario: Scenario
    private let refreshScenario: Scenario?
    private let retryScenario: Scenario?
    private let generatedAt: Date

    private(set) var loadCallCount = 0
    private(set) var refreshCallCount = 0
    private(set) var retryCallCount = 0
    private(set) var lastRefreshedQueueID: UUID?
    private(set) var lastRetriedFailure: DiscoveryQueueFailure?

    init(
        loadScenario: Scenario = .ready(candidates: MockDiscoveryRepository.defaultCandidates),
        refreshScenario: Scenario? = nil,
        retryScenario: Scenario? = nil,
        generatedAt: Date = MockDiscoveryRepository.defaultGeneratedAt
    ) {
        self.loadScenario = loadScenario
        self.refreshScenario = refreshScenario
        self.retryScenario = retryScenario
        self.generatedAt = generatedAt
    }

    func loadQueue() async -> DiscoveryQueue {
        loadCallCount += 1
        return queue(for: loadScenario)
    }

    func refreshQueue(existing queue: DiscoveryQueue) async -> DiscoveryQueue {
        refreshCallCount += 1
        lastRefreshedQueueID = queue.id
        return self.queue(for: refreshScenario ?? loadScenario, id: queue.id)
    }

    func retryQueue(after failure: DiscoveryQueueFailure?) async -> DiscoveryQueue {
        retryCallCount += 1
        lastRetriedFailure = failure
        return queue(for: retryScenario ?? loadScenario)
    }

    private func queue(for scenario: Scenario, id: UUID = UUID()) -> DiscoveryQueue {
        switch scenario {
        case let .ready(candidates):
            DiscoveryQueue.ready(
                id: id,
                candidates: candidates,
                generatedAt: generatedAt,
                activeSportSlug: candidates.first?.primarySport.sportSlug
            )
        case let .empty(reason):
            DiscoveryQueue.empty(
                id: id,
                reason: reason,
                generatedAt: generatedAt
            )
        case let .exhausted(candidates, reason):
            DiscoveryQueue.exhausted(
                id: id,
                candidates: candidates,
                reason: reason,
                generatedAt: generatedAt
            )
        case let .failed(failure, retryGuidance):
            DiscoveryQueue.failed(
                id: id,
                failure: failure,
                retryGuidance: retryGuidance,
                requestedAt: generatedAt
            )
        }
    }
}

extension MockDiscoveryRepository {
    static let defaultGeneratedAt = Date(timeIntervalSince1970: 1_784_000_000)

    static let defaultCandidates: [CandidateCard] = [
        CandidateCard(
            id: UUID(uuidString: "11111111-1111-1111-1111-111111111058")!,
            displayName: "Anna",
            profilePhotoPath: "profiles/anna/headshot.jpg",
            primarySport: CandidateSportSummary(
                sportSlug: "pickleball",
                displayName: "Pickleball",
                skillSummary: "Intermediate"
            ),
            bioSummary: "Always up for a good doubles game.",
            availabilitySummary: "Weekday evenings",
            locationSummary: "Raleigh area",
            contextLabels: [
                CandidateContextLabel(
                    kind: .sportCompatibility,
                    text: "Also plays pickleball"
                )
            ]
        ),
        CandidateCard(
            id: UUID(uuidString: "22222222-2222-2222-2222-222222222058")!,
            displayName: "Jordan",
            profilePhotoPath: nil,
            primarySport: CandidateSportSummary(
                sportSlug: "pickleball",
                displayName: "Pickleball",
                skillSummary: "Advanced beginner"
            ),
            bioSummary: "Looking for casual ladder nights.",
            availabilitySummary: "Weekend mornings",
            locationSummary: "Durham area",
            contextLabels: [
                CandidateContextLabel(
                    kind: .availability,
                    text: "Usually free weekends"
                )
            ]
        )
    ]
}
