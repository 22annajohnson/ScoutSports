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

    func test_ownerEditableProfile_keepsSystemOwnedFieldsReadOnlyOnProfileState() async {
        let createdAt = Date(timeIntervalSince1970: 100)
        let lastActiveAt = Date(timeIntervalSince1970: 200)

        let values = await MainActor.run {
            let profile = OwnerEditableProfile(
                id: "owner-1",
                displayName: "Anna",
                username: "anna_pb",
                profilePhotoPath: nil,
                actionPhotoPath: nil,
                bio: "Weekend games",
                sports: ["pickleball"],
                primarySport: "pickleball",
                skillLevelBySport: ["pickleball": 3],
                preferredDays: [.saturday],
                preferredTimeWindows: [.morning],
                playIntent: .flexible,
                homeArea: "Raleigh",
                travelRadiusMiles: 10,
                preferredPlayStyle: .doubles,
                profileVisibility: .publicProfile,
                isDiscoverable: true,
                locationPrecision: .coarse,
                completionState: .discoveryReady,
                accountStatus: .active,
                createdAt: createdAt,
                lastActiveAt: lastActiveAt
            )

            return (
                profile.completionState == .discoveryReady,
                profile.accountStatus == .active,
                profile.createdAt == createdAt,
                profile.lastActiveAt == lastActiveAt
            )
        }

        XCTAssertTrue(values.0)
        XCTAssertTrue(values.1)
        XCTAssertTrue(values.2)
        XCTAssertTrue(values.3)
    }

    func test_profileDomainEnums_useSchemaBackedRawValues() async {
        let values = await MainActor.run {
            (
                ProfileVisibility.publicProfile.rawValue,
                ProfileVisibility.authenticated.rawValue,
                ProfileVisibility.privateProfile.rawValue,
                ProfileCompletionState.accountCreated.rawValue,
                ProfileCompletionState.discoveryReady.rawValue,
                ProfileTimeWindow.flexible.rawValue
            )
        }

        XCTAssertEqual(values.0, "public")
        XCTAssertEqual(values.1, "authenticated")
        XCTAssertEqual(values.2, "private")
        XCTAssertEqual(values.3, "account_created")
        XCTAssertEqual(values.4, "discovery_ready")
        XCTAssertEqual(values.5, "flexible")
    }

    func test_profileIdentityUpdateCommand_validatesDisplayNameAndUsernameOnly() async {
        let validations = await MainActor.run {
            let invalid = ProfileIdentityUpdateCommand(
                displayName: " A ",
                username: "Bad Handle",
                bio: "Short bio"
            )
            let valid = ProfileIdentityUpdateCommand(
                displayName: "Anna",
                username: "anna_pb",
                bio: nil
            )

            return (
                invalid.validationErrors() == [.displayNameLength, .usernameFormat],
                valid.validationErrors().isEmpty
            )
        }

        XCTAssertTrue(validations.0)
        XCTAssertTrue(validations.1)
    }

    func test_profileSportsUpdateCommand_validatesPrimarySportSelectionAndSkill() async {
        let validations = await MainActor.run {
            let missingSelection = ProfileSportsUpdateCommand(
                sports: ["tennis"],
                primarySport: "pickleball",
                skillLevelBySport: ["pickleball": 3]
            )
            let missingSkill = ProfileSportsUpdateCommand(
                sports: ["pickleball"],
                primarySport: "pickleball",
                skillLevelBySport: [:]
            )
            let valid = ProfileSportsUpdateCommand(
                sports: ["pickleball"],
                primarySport: "pickleball",
                skillLevelBySport: ["pickleball": 3]
            )

            return (
                missingSelection.validationErrors() == [.primarySportNotSelected],
                missingSkill.validationErrors() == [.primarySportSkillMissing],
                valid.validationErrors().isEmpty
            )
        }

        XCTAssertTrue(validations.0)
        XCTAssertTrue(validations.1)
        XCTAssertTrue(validations.2)
    }

    func test_profileAvailabilityUpdateCommand_rejectsOutOfRangeTravelRadius() async {
        let validations = await MainActor.run {
            let zero = ProfileAvailabilityUpdateCommand(
                preferredDays: [.monday, .wednesday],
                preferredTimeWindows: [.evening],
                playIntent: .casual,
                homeArea: "Durham",
                travelRadiusMiles: 0,
                preferredPlayStyle: .open
            )
            let tooHigh = ProfileAvailabilityUpdateCommand(
                preferredDays: [.monday, .wednesday],
                preferredTimeWindows: [.evening],
                playIntent: .casual,
                homeArea: "Durham",
                travelRadiusMiles: 101,
                preferredPlayStyle: .open
            )
            let valid = ProfileAvailabilityUpdateCommand(
                preferredDays: [.monday, .wednesday],
                preferredTimeWindows: [.flexible],
                playIntent: .casual,
                homeArea: "Durham",
                travelRadiusMiles: 100,
                preferredPlayStyle: .open
            )

            return (
                zero.validationErrors() == [.travelRadiusOutOfRange],
                tooHigh.validationErrors() == [.travelRadiusOutOfRange],
                valid.validationErrors().isEmpty
            )
        }

        XCTAssertTrue(validations.0)
        XCTAssertTrue(validations.1)
        XCTAssertTrue(validations.2)
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

    @MainActor
    func test_ownerEditableProfileRepositoryProtocol_loadsCurrentProfileThroughMock() async throws {
        let mock = MockProfileRepository()
        let repository: OwnerEditableProfileProviding = mock

        let profile = try await repository.currentEditableProfile(forceRefresh: true)

        XCTAssertEqual(profile.id, "test-user")
        XCTAssertEqual(profile.displayName, "Test")
        XCTAssertEqual(mock.currentEditableProfileCalls, [true])
    }

    @MainActor
    func test_mockOwnerEditableProfileRepository_updatesIdentityAndTracksCommand() async throws {
        let mock = MockProfileRepository()
        let repository: OwnerEditableProfileProviding = mock
        let command = ProfileIdentityUpdateCommand(
            displayName: " Anna ",
            username: "anna_pb",
            bio: "Weekend pickleball"
        )

        let profile = try await repository.updateIdentity(command)

        XCTAssertEqual(profile.displayName, "Anna")
        XCTAssertEqual(profile.username, "anna_pb")
        XCTAssertEqual(profile.bio, "Weekend pickleball")
        XCTAssertEqual(mock.updateIdentityCalls, [command])
    }

    @MainActor
    func test_mockOwnerEditableProfileRepository_reportsMissingPermissionAndNetworkFailures() async {
        let missingProfileMock = MockProfileRepository()
        missingProfileMock.currentEditableProfileError = ProfileRepositoryError.profileMissing

        do {
            _ = try await missingProfileMock.currentEditableProfile(forceRefresh: false)
            XCTFail("Expected missing profile error")
        } catch let error as ProfileRepositoryError {
            if case .profileMissing = error {
                XCTAssertTrue(true)
            } else {
                XCTFail("Expected profileMissing, got \(error)")
            }
        } catch {
            XCTFail("Expected ProfileRepositoryError, got \(error)")
        }

        let permissionMock = MockProfileRepository()
        permissionMock.updatePrivacyError = ProfileRepositoryError.permissionDenied

        do {
            _ = try await permissionMock.updatePrivacy(
                ProfilePrivacyUpdateCommand(
                    profileVisibility: .authenticated,
                    isDiscoverable: true,
                    locationPrecision: .coarse
                )
            )
            XCTFail("Expected permission error")
        } catch let error as ProfileRepositoryError {
            if case .permissionDenied = error {
                XCTAssertTrue(true)
            } else {
                XCTFail("Expected permissionDenied, got \(error)")
            }
        } catch {
            XCTFail("Expected ProfileRepositoryError, got \(error)")
        }

        let networkMock = MockProfileRepository()
        networkMock.updateSportsError = ProfileRepositoryError.networkUnavailable

        do {
            _ = try await networkMock.updateSports(
                ProfileSportsUpdateCommand(
                    sports: ["pickleball"],
                    primarySport: "pickleball",
                    skillLevelBySport: ["pickleball": 3]
                )
            )
            XCTFail("Expected network error")
        } catch let error as ProfileRepositoryError {
            if case .networkUnavailable = error {
                XCTAssertTrue(true)
            } else {
                XCTFail("Expected networkUnavailable, got \(error)")
            }
        } catch {
            XCTFail("Expected ProfileRepositoryError, got \(error)")
        }
    }

    @MainActor
    func test_mockOwnerEditableProfileRepository_convertsCommandValidationFailures() async {
        let mock = MockProfileRepository()

        do {
            _ = try await mock.updateAvailability(
                ProfileAvailabilityUpdateCommand(
                    preferredDays: [.monday],
                    preferredTimeWindows: [.morning],
                    playIntent: .casual,
                    homeArea: "Durham",
                    travelRadiusMiles: 0,
                    preferredPlayStyle: .open
                )
            )
            XCTFail("Expected validation error")
        } catch let error as ProfileRepositoryError {
            if case .validationFailed(let errors) = error {
                XCTAssertEqual(errors, [.travelRadiusOutOfRange])
            } else {
                XCTFail("Expected validationFailed, got \(error)")
            }
        } catch {
            XCTFail("Expected ProfileRepositoryError, got \(error)")
        }

        XCTAssertEqual(mock.updateAvailabilityCalls.count, 1)
    }

    @MainActor
    func test_mockOwnerEditableProfileRepository_updatesSportsAvailabilityAndPrivacyState() async throws {
        let mock = MockProfileRepository()

        let sportsProfile = try await mock.updateSports(
            ProfileSportsUpdateCommand(
                sports: ["pickleball", "tennis"],
                primarySport: "tennis",
                skillLevelBySport: ["pickleball": 3, "tennis": 2]
            )
        )
        let availabilityProfile = try await mock.updateAvailability(
            ProfileAvailabilityUpdateCommand(
                preferredDays: [.saturday],
                preferredTimeWindows: [.flexible],
                playIntent: .flexible,
                homeArea: "Raleigh",
                travelRadiusMiles: 25,
                preferredPlayStyle: .mixed
            )
        )
        let privacyProfile = try await mock.updatePrivacy(
            ProfilePrivacyUpdateCommand(
                profileVisibility: .authenticated,
                isDiscoverable: true,
                locationPrecision: .hidden
            )
        )

        XCTAssertEqual(sportsProfile.primarySport, "tennis")
        XCTAssertEqual(availabilityProfile.preferredTimeWindows, [.flexible])
        XCTAssertEqual(availabilityProfile.travelRadiusMiles, 25)
        XCTAssertEqual(privacyProfile.profileVisibility, .authenticated)
        XCTAssertTrue(privacyProfile.isDiscoverable)
        XCTAssertEqual(privacyProfile.locationPrecision, .hidden)
        XCTAssertEqual(mock.updateSportsCalls.count, 1)
        XCTAssertEqual(mock.updateAvailabilityCalls.count, 1)
        XCTAssertEqual(mock.updatePrivacyCalls.count, 1)
    }

    @MainActor
    func test_ownerEditableProfileMapper_mapsFullOwnerProfileRows() throws {
        let profileID = UUID(uuidString: "00000000-0000-0000-0000-000000000042")!

        let profile = try OwnerEditableProfileMapper.ownerEditableProfile(
            profile: ownerEditableProfileRow(profileID: profileID),
            sports: [
                OwnerProfileSportRow(
                    profileId: profileID,
                    sportSlug: "pickleball",
                    skillLevel: "level_3",
                    isPrimary: true
                ),
                OwnerProfileSportRow(
                    profileId: profileID,
                    sportSlug: "tennis",
                    skillLevel: "level_2",
                    isPrimary: false
                )
            ],
            availability: OwnerProfileAvailabilityRow(
                profileId: profileID,
                preferredDays: ["monday", "saturday"],
                preferredTimes: ["morning", "flexible"],
                playIntent: "competitive",
                homeArea: "Raleigh",
                travelRadiusMiles: 25,
                preferredPlayStyle: "doubles"
            ),
            privacy: OwnerProfilePrivacyRow(
                profileId: profileID,
                profileVisibility: "authenticated",
                discoverable: true,
                locationPrecision: "coarse"
            )
        )

        XCTAssertEqual(profile.id, profileID.uuidString)
        XCTAssertEqual(profile.displayName, "Anna")
        XCTAssertEqual(profile.username, "anna_pb")
        XCTAssertEqual(profile.profilePhotoPath, "profiles/anna/headshot.jpg")
        XCTAssertEqual(profile.actionPhotoPath, "profiles/anna/action.jpg")
        XCTAssertEqual(profile.bio, "Always up for a good doubles game.")
        XCTAssertEqual(profile.sports, ["pickleball", "tennis"])
        XCTAssertEqual(profile.primarySport, "pickleball")
        XCTAssertEqual(profile.skillLevelBySport, ["pickleball": 3, "tennis": 2])
        XCTAssertEqual(profile.preferredDays, [.monday, .saturday])
        XCTAssertEqual(profile.preferredTimeWindows, [.morning, .flexible])
        XCTAssertEqual(profile.playIntent, .competitive)
        XCTAssertEqual(profile.homeArea, "Raleigh")
        XCTAssertEqual(profile.travelRadiusMiles, 25)
        XCTAssertEqual(profile.preferredPlayStyle, .doubles)
        XCTAssertEqual(profile.profileVisibility, .authenticated)
        XCTAssertTrue(profile.isDiscoverable)
        XCTAssertEqual(profile.locationPrecision, .coarse)
        XCTAssertEqual(profile.completionState, .discoveryReady)
        XCTAssertEqual(profile.accountStatus, .active)
        XCTAssertNotNil(profile.createdAt)
        XCTAssertNotNil(profile.lastActiveAt)
    }

    @MainActor
    func test_ownerEditableProfileMapper_defaultsMissingOptionalRowsTowardSafeOwnerState() throws {
        let profileID = UUID(uuidString: "00000000-0000-0000-0000-000000000043")!

        let profile = try OwnerEditableProfileMapper.ownerEditableProfile(
            profile: ownerEditableProfileRow(
                profileID: profileID,
                profilePhotoPath: nil,
                actionPhotoPath: nil,
                bio: nil,
                lastActiveAt: nil
            ),
            sports: [],
            availability: nil,
            privacy: nil
        )

        XCTAssertNil(profile.profilePhotoPath)
        XCTAssertNil(profile.actionPhotoPath)
        XCTAssertNil(profile.bio)
        XCTAssertTrue(profile.sports.isEmpty)
        XCTAssertNil(profile.primarySport)
        XCTAssertTrue(profile.skillLevelBySport.isEmpty)
        XCTAssertTrue(profile.preferredDays.isEmpty)
        XCTAssertTrue(profile.preferredTimeWindows.isEmpty)
        XCTAssertNil(profile.playIntent)
        XCTAssertNil(profile.homeArea)
        XCTAssertNil(profile.travelRadiusMiles)
        XCTAssertNil(profile.preferredPlayStyle)
        XCTAssertEqual(profile.profileVisibility, .privateProfile)
        XCTAssertFalse(profile.isDiscoverable)
        XCTAssertEqual(profile.locationPrecision, .coarse)
        XCTAssertNil(profile.lastActiveAt)
    }

    @MainActor
    func test_ownerEditableProfileMapper_reportsMissingProfile() {
        XCTAssertThrowsProfileRepositoryError(.profileMissing) {
            _ = try OwnerEditableProfileMapper.ownerEditableProfile(
                profile: nil,
                sports: [],
                availability: nil,
                privacy: nil
            )
        }
    }

    @MainActor
    func test_ownerEditableProfileMapper_rejectsMalformedRows() {
        let profileID = UUID(uuidString: "00000000-0000-0000-0000-000000000044")!

        XCTAssertThrowsProfileRepositoryError(.mappingFailed) {
            _ = try OwnerEditableProfileMapper.ownerEditableProfile(
                profile: ownerEditableProfileRow(profileID: profileID, createdAt: "not-a-date"),
                sports: [],
                availability: nil,
                privacy: nil
            )
        }

        XCTAssertThrowsProfileRepositoryError(.mappingFailed) {
            _ = try OwnerEditableProfileMapper.ownerEditableProfile(
                profile: ownerEditableProfileRow(profileID: profileID),
                sports: [
                    OwnerProfileSportRow(
                        profileId: profileID,
                        sportSlug: "pickleball",
                        skillLevel: "intermediate",
                        isPrimary: true
                    )
                ],
                availability: nil,
                privacy: nil
            )
        }

        XCTAssertThrowsProfileRepositoryError(.mappingFailed) {
            _ = try OwnerEditableProfileMapper.ownerEditableProfile(
                profile: ownerEditableProfileRow(profileID: profileID),
                sports: [],
                availability: OwnerProfileAvailabilityRow(
                    profileId: profileID,
                    preferredDays: ["monday", "funday"],
                    preferredTimes: ["morning"],
                    playIntent: "casual",
                    homeArea: nil,
                    travelRadiusMiles: nil,
                    preferredPlayStyle: nil
                ),
                privacy: nil
            )
        }

        XCTAssertThrowsProfileRepositoryError(.mappingFailed) {
            _ = try OwnerEditableProfileMapper.ownerEditableProfile(
                profile: ownerEditableProfileRow(profileID: profileID),
                sports: [],
                availability: OwnerProfileAvailabilityRow(
                    profileId: profileID,
                    preferredDays: [],
                    preferredTimes: [],
                    playIntent: nil,
                    homeArea: nil,
                    travelRadiusMiles: 101,
                    preferredPlayStyle: nil
                ),
                privacy: nil
            )
        }

        XCTAssertThrowsProfileRepositoryError(.mappingFailed) {
            _ = try OwnerEditableProfileMapper.ownerEditableProfile(
                profile: ownerEditableProfileRow(profileID: profileID),
                sports: [],
                availability: nil,
                privacy: OwnerProfilePrivacyRow(
                    profileId: profileID,
                    profileVisibility: "friends",
                    discoverable: true,
                    locationPrecision: "coarse"
                )
            )
        }
    }

    private func ownerEditableProfileRow(
        profileID: UUID,
        displayName: String? = " Anna ",
        profilePhotoPath: String? = "profiles/anna/headshot.jpg",
        actionPhotoPath: String? = "profiles/anna/action.jpg",
        bio: String? = "Always up for a good doubles game.",
        profileCompletionState: String = "discovery_ready",
        accountStatus: String = "active",
        createdAt: String = "2026-07-14T12:00:00Z",
        lastActiveAt: String? = "2026-07-14T13:00:00Z"
    ) -> OwnerEditableProfileRow {
        OwnerEditableProfileRow(
            id: profileID,
            displayName: displayName,
            username: "anna_pb",
            profilePhotoPath: profilePhotoPath,
            actionPhotoPath: actionPhotoPath,
            bio: bio,
            profileCompletionState: profileCompletionState,
            accountStatus: accountStatus,
            createdAt: createdAt,
            lastActiveAt: lastActiveAt
        )
    }

    private func XCTAssertThrowsProfileRepositoryError(
        _ expectedError: ProfileRepositoryError,
        file: StaticString = #filePath,
        line: UInt = #line,
        operation: () throws -> Void
    ) {
        do {
            try operation()
            XCTFail("Expected ProfileRepositoryError.\(expectedError)", file: file, line: line)
        } catch let error as ProfileRepositoryError {
            switch (expectedError, error) {
            case (.profileMissing, .profileMissing),
                 (.mappingFailed, .mappingFailed):
                XCTAssertTrue(true)
            default:
                XCTFail("Expected \(expectedError), got \(error)", file: file, line: line)
            }
        } catch {
            XCTFail("Expected ProfileRepositoryError, got \(error)", file: file, line: line)
        }
    }
}
