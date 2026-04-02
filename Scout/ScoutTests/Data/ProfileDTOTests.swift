//
//  ProfileDTOTests.swift
//  ScoutTests
//
//  Created by Anna on 3/2/26.
//

import XCTest
@testable import Scout

final class ProfileDTOTests: XCTestCase {

    func test_decode_displayNameSnakeCaseKey_mapsToDisplayNameProperty() async throws {
        // Arrange
        let json = """
        {
          "id": "user-123",
          "display_name": "Anna"
        }
        """

        // Act
        let data = try XCTUnwrap(json.data(using: .utf8))
        let decoded = try await MainActor.run {
            try JSONDecoder().decode(ProfileDTO.self, from: data)
        }

        // Assert
        let (id, displayName) = await MainActor.run { (decoded.id, decoded.displayName) }
        XCTAssertEqual(id, "user-123")
        XCTAssertEqual(displayName, "Anna")
    }

    func test_toDomain_whenValidDTO_returnsMatchingDomainModel() async {
        // Act
        let domain = await MainActor.run { () -> Profile in
            let dto = ProfileDTO(id: "user-abc", displayName: "Noah")
            return dto.toDomain()
        }

        // Assert
        let (id, displayName) = await MainActor.run { (domain.id, domain.displayName) }
        XCTAssertEqual(id, "user-abc")
        XCTAssertEqual(displayName, "Noah")
    }

    func test_publicProfileDTO_toDomain_mapsEditableProfileFields() async {
        let birthdate = ISO8601DateFormatter().date(from: "2000-01-02T00:00:00Z")

        let domain = await MainActor.run { () -> PlayerPublicProfile in
            let dto = PlayerPublicProfileDTO(
                id: "user-public",
                displayName: "Anna",
                birthdate: birthdate,
                primarySport: "pickleball",
                bio: "Loves pickup games",
                homeCourtName: "Central Park Courts",
                backgroundLevel: "club",
                yearsPlaying: 4,
                skillLevel: 3,
                playStyle: "doubles"
            )
            return dto.toDomain(clubNames: ["Docks PB Club", "Sanford Rec"])
        }

        let values = await MainActor.run {
            (
                domain.id,
                domain.displayName,
                domain.birthdate,
                domain.primarySport,
                domain.bio,
                domain.homeCourtName,
                domain.clubNames,
                domain.skillLevel,
                domain.playStyle
            )
        }

        XCTAssertEqual(values.0, "user-public")
        XCTAssertEqual(values.1, "Anna")
        XCTAssertEqual(values.2, birthdate)
        XCTAssertEqual(values.3, "pickleball")
        XCTAssertEqual(values.4, "Loves pickup games")
        XCTAssertEqual(values.5, "Central Park Courts")
        XCTAssertEqual(values.6, ["Docks PB Club", "Sanford Rec"])
        XCTAssertEqual(values.7, 3)
        XCTAssertEqual(values.8, "doubles")
    }

    func test_matchPlayerFeedbackRow_toDomain_mapsFeedbackFields() async {
        let createdAt = Date(timeIntervalSince1970: 123456)
        let matchID = UUID()
        let reviewerID = UUID()
        let reviewedID = UUID()

        let domain = await MainActor.run { () -> MatchPlayerFeedback in
            let row = MatchPlayerFeedbackRow(
                id: UUID(),
                matchID: matchID,
                reviewerUserID: reviewerID,
                reviewedUserID: reviewedID,
                skillRating: 4,
                competitivenessRating: 5,
                friendlinessRating: 3,
                vibesRating: 4,
                communicationRating: 5,
                reliabilityRating: 4,
                wouldPlayAgain: true,
                privateNote: "Great games",
                createdAt: createdAt
            )
            return row.toDomain()
        }

        let values = await MainActor.run {
            (
                domain.matchID,
                domain.reviewerUserID,
                domain.reviewedUserID,
                domain.skillRating,
                domain.competitivenessRating,
                domain.friendlinessRating,
                domain.vibesRating,
                domain.communicationRating,
                domain.reliabilityRating,
                domain.wouldPlayAgain,
                domain.privateNote,
                domain.createdAt
            )
        }

        XCTAssertEqual(values.0, matchID)
        XCTAssertEqual(values.1, reviewerID)
        XCTAssertEqual(values.2, reviewedID)
        XCTAssertEqual(values.3, 4)
        XCTAssertEqual(values.4, 5)
        XCTAssertEqual(values.5, 3)
        XCTAssertEqual(values.6, 4)
        XCTAssertEqual(values.7, 5)
        XCTAssertEqual(values.8, 4)
        XCTAssertEqual(values.9, true)
        XCTAssertEqual(values.10, "Great games")
        XCTAssertEqual(values.11, createdAt)
    }

    func test_playerDerivedMetrics_toStatsViewModels_mapsRatingsForSwipeSurface() async {
        let metrics = await MainActor.run {
            PlayerDerivedMetrics(
                id: "derived-user",
                friendlinessScore: 4.2,
                competitivenessScore: 3.4,
                vibesScore: 4.6,
                reliabilityScore: 2.7,
                skillConfidence: 3.8,
                repeatPlayRate: 5.0
            )
        }

        let stats = await MainActor.run {
            metrics.toStatsViewModels(totalReviews: 12)
        }

        let values = await MainActor.run {
            (
                stats.count,
                stats[0].statType,
                stats[0].rating,
                stats[1].statType,
                stats[1].rating,
                stats[2].statType,
                stats[2].rating,
                stats[3].statType,
                stats[3].rating,
                stats.allSatisfy { $0.totalReviews == 12 }
            )
        }

        XCTAssertEqual(values.0, 4)
        XCTAssertEqual(values.1, .vibe)
        XCTAssertEqual(values.2, 5)
        XCTAssertEqual(values.3, .intensity)
        XCTAssertEqual(values.4, 3)
        XCTAssertEqual(values.5, .consistency)
        XCTAssertEqual(values.6, 3)
        XCTAssertEqual(values.7, .skill)
        XCTAssertEqual(values.8, 4)
        XCTAssertTrue(values.9)
    }

    func test_playerDerivedMetrics_toPublicSummary_excludesRawFeedbackAndCarriesDisplayStats() async {
        let metrics = await MainActor.run {
            PlayerDerivedMetrics(
                id: "derived-user",
                friendlinessScore: 4.0,
                competitivenessScore: 3.0,
                vibesScore: 5.0,
                reliabilityScore: 2.0,
                skillConfidence: 4.0,
                repeatPlayRate: 5.0
            )
        }

        let summary = await MainActor.run {
            metrics.toPublicSummary(totalReviews: 8)
        }

        let values = await MainActor.run {
            (
                summary.id,
                summary.totalReviews,
                summary.stats.count,
                summary.stats.allSatisfy { $0.reviews.isEmpty }
            )
        }

        XCTAssertEqual(values.0, "derived-user")
        XCTAssertEqual(values.1, 8)
        XCTAssertEqual(values.2, 4)
        XCTAssertTrue(values.3)
    }

    func test_swipeCandidate_toCardViewModel_projectsCandidateIntoExistingCardShape() async {
        let heroURL = URL(string: "https://example.com/player.png")!
        let candidate = await MainActor.run {
            SwipeCandidate(
                id: UUID(),
                displayName: "Anna",
                sports: ["Pickleball"],
                heroImageURL: heroURL,
                stats: [
                    StatsViewModel(statType: .vibe, rating: 4, totalReviews: 12, reviews: [])
                ],
                didLike: true
            )
        }

        let card = await MainActor.run {
            candidate.toCardViewModel()
        }

        let values = await MainActor.run {
            (
                card.name,
                card.sports,
                card.heroImageURL,
                card.stats.count,
                card.stats[0].statType,
                card.stats[0].rating,
                card.didLike
            )
        }

        XCTAssertEqual(values.0, "Anna")
        XCTAssertEqual(values.1, ["Pickleball"])
        XCTAssertEqual(values.2, heroURL)
        XCTAssertEqual(values.3, 1)
        XCTAssertEqual(values.4, .vibe)
        XCTAssertEqual(values.5, 4)
        XCTAssertTrue(values.6)
    }

    func test_mockProfileRepository_tracks_newBoundaryCalls() async throws {
        let repository = await MainActor.run { MockProfileRepository() }
        let reviewedUserID = UUID()
        let matchID = UUID()

        try await repository.updateCurrentUserMatchSignals(
            PlayerMatchSignalsUpdateInput(
                competitivenessRating: 4,
                friendlinessRating: 5,
                socialVibeRating: 3,
                preferredMatchIntensity: "balanced"
            )
        )

        try await repository.replaceCurrentUserClubMemberships(with: ["Docks PB Club", "Sanford Rec"])

        try await repository.submitCurrentUserMatchFeedback(
            MatchPlayerFeedbackInput(
                matchID: matchID,
                reviewedUserID: reviewedUserID,
                skillRating: 4,
                competitivenessRating: 3,
                friendlinessRating: 5,
                vibesRating: 4,
                communicationRating: 5,
                reliabilityRating: 4,
                wouldPlayAgain: true,
                privateNote: "Great match"
            )
        )

        let values = await MainActor.run {
            (
                repository.updateMatchSignalsCalls.count,
                repository.updateMatchSignalsCalls.first?.competitivenessRating,
                repository.replaceClubMembershipCalls,
                repository.submittedMatchFeedbackCalls.count,
                repository.submittedMatchFeedbackCalls.first?.matchID,
                repository.submittedMatchFeedbackCalls.first?.reviewedUserID
            )
        }

        XCTAssertEqual(values.0, 1)
        XCTAssertEqual(values.1, 4)
        XCTAssertEqual(values.2, [["Docks PB Club", "Sanford Rec"]])
        XCTAssertEqual(values.3, 1)
        XCTAssertEqual(values.4, matchID)
        XCTAssertEqual(values.5, reviewedUserID)
    }
}
