//
//  DiscoveryContractsTests.swift
//  ScoutTests
//
//  Created by Codex on 7/14/26.
//

import XCTest
@testable import Scout

@MainActor
final class DiscoveryContractsTests: XCTestCase {
    private let queueID = UUID(uuidString: "00000000-0000-0000-0000-000000000057")!
    private let candidateID = UUID(uuidString: "11111111-1111-1111-1111-111111111157")!
    private let generatedAt = Date(timeIntervalSince1970: 1_784_000_000)

    func test_readyQueueConstructionIncludesCandidateCardsAndMetadata() {
        let candidate = candidateCard()

        let queue = DiscoveryQueue.ready(
            id: queueID,
            candidates: [candidate],
            generatedAt: generatedAt,
            activeSportSlug: "pickleball"
        )

        XCTAssertEqual(queue.id, queueID)
        XCTAssertEqual(queue.state, .ready)
        XCTAssertEqual(queue.candidates, [candidate])
        XCTAssertEqual(queue.metadata.generatedAt, generatedAt)
        XCTAssertEqual(queue.metadata.activeSportSlug, "pickleball")
        XCTAssertEqual(queue.metadata.candidateCount, 1)
        XCTAssertTrue(queue.canRefresh)
        XCTAssertNil(queue.emptyReason)
        XCTAssertNil(queue.exhaustedReason)
        XCTAssertNil(queue.failure)
    }

    func test_loadingQueueDisablesRefreshWhileRequestIsActive() {
        let requestedAt = Date(timeIntervalSince1970: 1_784_000_001)

        let queue = DiscoveryQueue.loading(id: queueID, requestedAt: requestedAt)

        XCTAssertEqual(queue.state, .loading)
        XCTAssertEqual(queue.metadata.requestedAt, requestedAt)
        XCTAssertTrue(queue.candidates.isEmpty)
        XCTAssertFalse(queue.canRefresh)
    }

    func test_emptyQueueCarriesUserSafeReason() {
        let queue = DiscoveryQueue.empty(
            id: queueID,
            reason: .profileNotDiscoveryReady,
            generatedAt: generatedAt
        )

        XCTAssertEqual(queue.state, .empty)
        XCTAssertEqual(queue.emptyReason, .profileNotDiscoveryReady)
        XCTAssertEqual(queue.metadata.generatedAt, generatedAt)
        XCTAssertTrue(queue.candidates.isEmpty)
    }

    func test_exhaustedQueueTracksPresentedCandidateIDs() {
        let candidate = candidateCard()

        let queue = DiscoveryQueue.exhausted(
            id: queueID,
            candidates: [candidate],
            reason: .allCandidatesPresented,
            generatedAt: generatedAt
        )

        XCTAssertEqual(queue.state, .exhausted)
        XCTAssertEqual(queue.exhaustedReason, .allCandidatesPresented)
        XCTAssertEqual(queue.metadata.presentedCandidateIDs, [candidateID])
        XCTAssertEqual(queue.metadata.candidateCount, 1)
    }

    func test_refreshingQueuePreservesExistingDeckAndIdentity() {
        let original = DiscoveryQueue.ready(
            id: queueID,
            candidates: [candidateCard()],
            generatedAt: generatedAt,
            activeSportSlug: "pickleball"
        )
        let requestedAt = Date(timeIntervalSince1970: 1_784_000_002)

        let refreshing = DiscoveryQueue.refreshing(
            existing: original,
            requestedAt: requestedAt
        )

        XCTAssertEqual(refreshing.id, original.id)
        XCTAssertEqual(refreshing.state, .refreshing)
        XCTAssertEqual(refreshing.candidates, original.candidates)
        XCTAssertEqual(refreshing.metadata.generatedAt, original.metadata.generatedAt)
        XCTAssertEqual(refreshing.metadata.requestedAt, requestedAt)
        XCTAssertFalse(refreshing.canRefresh)
    }

    func test_failedQueueCarriesTypedFailureAndRetryGuidance() {
        let failure = DiscoveryQueueFailure(
            kind: .serviceUnavailable,
            message: "Discovery is temporarily unavailable."
        )

        let queue = DiscoveryQueue.failed(
            id: queueID,
            failure: failure,
            retryGuidance: .tryLater,
            requestedAt: generatedAt
        )

        XCTAssertEqual(queue.state, .failed)
        XCTAssertEqual(queue.failure, failure)
        XCTAssertEqual(queue.retryGuidance, .tryLater)
        XCTAssertEqual(queue.metadata.requestedAt, generatedAt)
        XCTAssertTrue(queue.canRefresh)
        XCTAssertTrue(queue.candidates.isEmpty)
    }

    private func candidateCard() -> CandidateCard {
        CandidateCard(
            id: candidateID,
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
            ],
            allowedActions: [.pass, .like, .viewProfile, .report]
        )
    }
}
