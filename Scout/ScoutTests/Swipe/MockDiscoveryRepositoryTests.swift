//
//  MockDiscoveryRepositoryTests.swift
//  ScoutTests
//
//  Created by Codex on 7/14/26.
//

import XCTest
@testable import Scout

@MainActor
final class MockDiscoveryRepositoryTests: XCTestCase {
    private let queueID = UUID(uuidString: "00000000-0000-0000-0000-000000000058")!

    func test_loadQueue_withReadyScenarioReturnsDeterministicCandidates() async {
        let repository = MockDiscoveryRepository()

        let queue = await repository.loadQueue()

        XCTAssertEqual(queue.state, .ready)
        XCTAssertEqual(queue.candidates, MockDiscoveryRepository.defaultCandidates)
        XCTAssertEqual(queue.metadata.generatedAt, MockDiscoveryRepository.defaultGeneratedAt)
        XCTAssertEqual(queue.metadata.activeSportSlug, "pickleball")
        XCTAssertEqual(repository.loadCallCount, 1)
    }

    func test_loadQueue_withEmptyScenarioReturnsEmptyQueueReason() async {
        let repository = MockDiscoveryRepository(
            loadScenario: .empty(reason: .filtersTooRestrictive)
        )

        let queue = await repository.loadQueue()

        XCTAssertEqual(queue.state, .empty)
        XCTAssertEqual(queue.emptyReason, .filtersTooRestrictive)
        XCTAssertTrue(queue.candidates.isEmpty)
    }

    func test_loadQueue_withExhaustedScenarioReturnsExhaustedQueue() async {
        let repository = MockDiscoveryRepository(
            loadScenario: .exhausted(
                candidates: MockDiscoveryRepository.defaultCandidates,
                reason: .allCandidatesPresented
            )
        )

        let queue = await repository.loadQueue()

        XCTAssertEqual(queue.state, .exhausted)
        XCTAssertEqual(queue.exhaustedReason, .allCandidatesPresented)
        XCTAssertEqual(
            queue.metadata.presentedCandidateIDs,
            Set(MockDiscoveryRepository.defaultCandidates.map(\.id))
        )
    }

    func test_loadQueue_withFailedScenarioReturnsTypedFailure() async {
        let failure = DiscoveryQueueFailure(
            kind: .serviceUnavailable,
            message: "Discovery is temporarily unavailable."
        )
        let repository = MockDiscoveryRepository(
            loadScenario: .failed(failure: failure, retryGuidance: .tryLater)
        )

        let queue = await repository.loadQueue()

        XCTAssertEqual(queue.state, .failed)
        XCTAssertEqual(queue.failure, failure)
        XCTAssertEqual(queue.retryGuidance, .tryLater)
    }

    func test_refreshQueueUsesRefreshScenarioAndPreservesQueueIdentity() async {
        let existingQueue = DiscoveryQueue.ready(
            id: queueID,
            candidates: MockDiscoveryRepository.defaultCandidates,
            generatedAt: MockDiscoveryRepository.defaultGeneratedAt,
            activeSportSlug: "pickleball"
        )
        let repository = MockDiscoveryRepository(
            refreshScenario: .empty(reason: .noEligibleCandidates)
        )

        let refreshedQueue = await repository.refreshQueue(existing: existingQueue)

        XCTAssertEqual(refreshedQueue.id, queueID)
        XCTAssertEqual(refreshedQueue.state, .empty)
        XCTAssertEqual(refreshedQueue.emptyReason, .noEligibleCandidates)
        XCTAssertEqual(repository.refreshCallCount, 1)
        XCTAssertEqual(repository.lastRefreshedQueueID, queueID)
    }

    func test_retryQueueUsesRetryScenarioAndRecordsFailure() async {
        let failure = DiscoveryQueueFailure(
            kind: .networkUnavailable,
            message: "Check your connection."
        )
        let repository = MockDiscoveryRepository(
            loadScenario: .failed(failure: failure, retryGuidance: .manualRetry),
            retryScenario: .ready(candidates: MockDiscoveryRepository.defaultCandidates)
        )

        let retriedQueue = await repository.retryQueue(after: failure)

        XCTAssertEqual(retriedQueue.state, .ready)
        XCTAssertEqual(retriedQueue.candidates, MockDiscoveryRepository.defaultCandidates)
        XCTAssertEqual(repository.retryCallCount, 1)
        XCTAssertEqual(repository.lastRetriedFailure, failure)
    }
}
