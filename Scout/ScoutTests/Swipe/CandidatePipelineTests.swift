//
//  CandidatePipelineTests.swift
//  ScoutTests
//
//  Created by Codex on 7/14/26.
//

import XCTest
@testable import Scout

@MainActor
final class CandidatePipelineTests: XCTestCase {
    private let queueID = UUID(uuidString: "00000000-0000-0000-0000-000000000059")!
    private let currentUserID = UUID(uuidString: "11111111-1111-1111-1111-111111111059")!
    private let currentProfileID = UUID(uuidString: "22222222-2222-2222-2222-222222222059")!
    private let candidateID = UUID(uuidString: "33333333-3333-3333-3333-333333333059")!
    private let candidateUserID = UUID(uuidString: "44444444-4444-4444-4444-444444444059")!
    private let generatedAt = Date(timeIntervalSince1970: 1_784_000_000)

    func test_makeQueue_assemblesStableCandidateCardsFromEligibleProfiles() {
        let pipeline = makePipeline()

        let queue = pipeline.makeQueue(
            currentPlayer: currentPlayer(),
            candidates: [candidate()]
        )

        XCTAssertEqual(queue.id, queueID)
        XCTAssertEqual(queue.state, .ready)
        XCTAssertEqual(queue.metadata.activeSportSlug, "pickleball")
        XCTAssertEqual(queue.metadata.generatedAt, generatedAt)
        XCTAssertEqual(queue.candidates.count, 1)
        XCTAssertEqual(queue.candidates.first?.id, candidateID)
        XCTAssertEqual(queue.candidates.first?.displayName, "Anna")
        XCTAssertEqual(queue.candidates.first?.primarySport.sportSlug, "pickleball")
        XCTAssertEqual(queue.candidates.first?.primarySport.skillSummary, "intermediate")
        XCTAssertEqual(queue.candidates.first?.availabilitySummary, "monday - evening - casual")
        XCTAssertEqual(queue.candidates.first?.locationSummary, "Raleigh")
        XCTAssertEqual(queue.candidates.first?.allowedActions, CandidateAction.defaultQueueActions)
    }

    func test_makeQueue_excludesCurrentUserByUserID() {
        let queue = makePipeline().makeQueue(
            currentPlayer: currentPlayer(),
            candidates: [
                candidate(userID: currentUserID)
            ]
        )

        XCTAssertEqual(queue.state, .empty)
        XCTAssertEqual(queue.emptyReason, .noEligibleCandidates)
    }

    func test_makeQueue_excludesCurrentProfileByProfileID() {
        let queue = makePipeline().makeQueue(
            currentPlayer: currentPlayer(),
            candidates: [
                candidate(id: currentProfileID)
            ]
        )

        XCTAssertEqual(queue.state, .empty)
        XCTAssertEqual(queue.emptyReason, .noEligibleCandidates)
    }

    func test_makeQueue_excludesProfilesThatAreNotDiscoveryReady() {
        let queue = makePipeline().makeQueue(
            currentPlayer: currentPlayer(),
            candidates: [
                candidate(readinessState: .basicIdentity)
            ]
        )

        XCTAssertEqual(queue.state, .empty)
        XCTAssertEqual(queue.emptyReason, .noEligibleCandidates)
    }

    func test_makeQueue_excludesInactiveAccounts() {
        let queue = makePipeline().makeQueue(
            currentPlayer: currentPlayer(),
            candidates: [
                candidate(accountStatus: .restricted)
            ]
        )

        XCTAssertEqual(queue.state, .empty)
        XCTAssertEqual(queue.emptyReason, .noEligibleCandidates)
    }

    func test_makeQueue_excludesProfilesBlockedByVisibility() {
        let queue = makePipeline().makeQueue(
            currentPlayer: currentPlayer(),
            candidates: [
                candidate(privacy: ProfilePrivacySettings(
                    profileVisibility: "private",
                    discoverable: true,
                    locationPrecision: "coarse"
                ))
            ]
        )

        XCTAssertEqual(queue.state, .empty)
        XCTAssertEqual(queue.emptyReason, .noEligibleCandidates)
    }

    func test_makeQueue_excludesSportMismatches() {
        let queue = makePipeline().makeQueue(
            currentPlayer: currentPlayer(activeSportSlug: "tennis"),
            candidates: [
                candidate()
            ]
        )

        XCTAssertEqual(queue.state, .empty)
        XCTAssertEqual(queue.emptyReason, .noEligibleCandidates)
    }

    func test_makeQueue_excludesDuplicateCandidatesAndPreviouslyPresentedCandidates() {
        let previousQueue = DiscoveryQueue.exhausted(
            id: queueID,
            candidates: [
                candidateCard(id: candidateID)
            ],
            reason: .allCandidatesPresented,
            generatedAt: generatedAt
        )
        let freshCandidateID = UUID(uuidString: "55555555-5555-5555-5555-555555555059")!

        let queue = makePipeline().makeQueue(
            currentPlayer: currentPlayer(),
            candidates: [
                candidate(),
                candidate(id: freshCandidateID, displayName: "Jordan"),
                candidate(id: freshCandidateID, displayName: "Duplicate Jordan")
            ],
            previousQueue: previousQueue
        )

        XCTAssertEqual(queue.state, .ready)
        XCTAssertEqual(queue.candidates.map(\.id), [freshCandidateID])
        XCTAssertEqual(queue.candidates.first?.displayName, "Jordan")
    }

    func test_makeQueue_missingSoftSignalsDoNotExcludeCandidate() {
        var candidateWithoutSoftSignals = candidate(sports: [
            ProfileSportContext(
                sportSlug: "pickleball",
                skillLevel: nil,
                isPrimary: true
            )
        ])
        candidateWithoutSoftSignals.availability = nil

        let queue = makePipeline().makeQueue(
            currentPlayer: currentPlayer(),
            candidates: [
                candidateWithoutSoftSignals
            ]
        )

        XCTAssertEqual(queue.state, .ready)
        XCTAssertEqual(queue.candidates.count, 1)
        XCTAssertNil(queue.candidates.first?.availabilitySummary)
        XCTAssertNil(queue.candidates.first?.locationSummary)
    }

    func test_makeQueue_currentPlayerMustBeDiscoveryReadyAndHaveActiveSport() {
        let notReadyQueue = makePipeline().makeQueue(
            currentPlayer: currentPlayer(readinessState: .basicIdentity),
            candidates: [candidate()]
        )

        XCTAssertEqual(notReadyQueue.state, .empty)
        XCTAssertEqual(notReadyQueue.emptyReason, .profileNotDiscoveryReady)

        let noSportQueue = makePipeline().makeQueue(
            currentPlayer: currentPlayer(activeSportSlug: nil),
            candidates: [candidate()]
        )

        XCTAssertEqual(noSportQueue.state, .empty)
        XCTAssertEqual(noSportQueue.emptyReason, .activeSportUnavailable)
    }

    private func makePipeline() -> CandidatePipeline {
        CandidatePipeline(
            queueIDProvider: { self.queueID },
            generatedAtProvider: { self.generatedAt }
        )
    }

    private func currentPlayer(
        activeSportSlug: String? = "pickleball",
        readinessState: ProfileReadinessState = .discoveryReady
    ) -> DiscoveryCurrentPlayerContext {
        DiscoveryCurrentPlayerContext(
            userID: currentUserID,
            profileID: currentProfileID,
            activeSportSlug: activeSportSlug,
            readinessState: readinessState
        )
    }

    private func candidate(
        id: UUID? = nil,
        userID: UUID? = nil,
        displayName: String? = "Anna",
        readinessState: ProfileReadinessState = .discoveryReady,
        accountStatus: ProfileAccountStatus = .active,
        sports: [ProfileSportContext]? = nil,
        availability: ProfileAvailabilityContext? = nil,
        privacy: ProfilePrivacySettings? = nil
    ) -> DiscoveryCandidateProfile {
        DiscoveryCandidateProfile(
            id: id ?? candidateID,
            userID: userID ?? candidateUserID,
            displayName: displayName,
            username: "anna_pb",
            profilePhotoPath: "profiles/anna/headshot.jpg",
            bio: "Always up for a good doubles game.",
            readinessState: readinessState,
            accountStatus: accountStatus,
            sports: sports ?? [
                ProfileSportContext(
                    sportSlug: "pickleball",
                    skillLevel: "intermediate",
                    isPrimary: true
                )
            ],
            availability: availability ?? ProfileAvailabilityContext(
                preferredDays: ["monday"],
                preferredTimes: ["evening"],
                playIntent: "casual",
                homeArea: "Raleigh",
                travelRadiusMiles: 25,
                preferredPlayStyle: "doubles"
            ),
            privacy: privacy ?? ProfilePrivacySettings(
                profileVisibility: "authenticated",
                discoverable: true,
                locationPrecision: "coarse"
            )
        )
    }

    private func candidateCard(id: UUID) -> CandidateCard {
        CandidateCard(
            id: id,
            displayName: "Previously Presented",
            primarySport: CandidateSportSummary(
                sportSlug: "pickleball",
                displayName: "Pickleball",
                skillSummary: nil
            )
        )
    }
}
