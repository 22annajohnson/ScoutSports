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
}
