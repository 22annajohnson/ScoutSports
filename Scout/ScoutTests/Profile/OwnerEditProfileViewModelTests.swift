//
//  OwnerEditProfileViewModelTests.swift
//  ScoutTests
//

import XCTest
@testable import Scout

@MainActor
final class OwnerEditProfileViewModelTests: XCTestCase {
    func test_save_whenRequiredFieldsAreValid_usesRepositoryUpdateCommands() async throws {
        let repository = MockProfileRepository()
        let viewModel = OwnerEditProfileViewModel(
            profile: makeProfile(),
            repository: repository
        )
        viewModel.form.displayName = "  Updated Player  "
        viewModel.form.username = "updated_player"
        viewModel.form.bio = "  Ready for rallies.  "
        viewModel.form.sportsText = "pickleball, tennis, pickleball"
        viewModel.form.primarySport = "pickleball"
        viewModel.form.primarySkillLevel = 4
        viewModel.form.preferredDays = [.monday, .saturday]
        viewModel.form.preferredTimeWindows = [.morning]
        viewModel.form.playIntent = .competitive
        viewModel.form.homeArea = "  East Austin  "
        viewModel.form.travelRadiusText = "12"
        viewModel.form.preferredPlayStyle = .doubles
        viewModel.form.profileVisibility = .authenticated
        viewModel.form.isDiscoverable = true
        viewModel.form.locationPrecision = .coarse

        await viewModel.save()

        let identity = try XCTUnwrap(repository.updateIdentityCalls.first)
        XCTAssertEqual(identity.displayName, "Updated Player")
        XCTAssertEqual(identity.username, "updated_player")
        XCTAssertEqual(identity.bio, "Ready for rallies.")

        let sports = try XCTUnwrap(repository.updateSportsCalls.first)
        XCTAssertEqual(sports.sports, ["pickleball", "tennis"])
        XCTAssertEqual(sports.primarySport, "pickleball")
        XCTAssertEqual(sports.skillLevelBySport, ["pickleball": 4])

        let availability = try XCTUnwrap(repository.updateAvailabilityCalls.first)
        XCTAssertEqual(availability.preferredDays, [.monday, .saturday])
        XCTAssertEqual(availability.preferredTimeWindows, [.morning])
        XCTAssertEqual(availability.playIntent, .competitive)
        XCTAssertEqual(availability.homeArea, "East Austin")
        XCTAssertEqual(availability.travelRadiusMiles, 12)
        XCTAssertEqual(availability.preferredPlayStyle, .doubles)

        let privacy = try XCTUnwrap(repository.updatePrivacyCalls.first)
        XCTAssertEqual(privacy.profileVisibility, .authenticated)
        XCTAssertTrue(privacy.isDiscoverable)
        XCTAssertEqual(privacy.locationPrecision, .coarse)

        guard case .saved = viewModel.saveState else {
            return XCTFail("Expected saved state, got \(viewModel.saveState)")
        }
    }

    func test_save_whenDisplayNameMissing_setsValidationStateWithoutSaving() async {
        let repository = MockProfileRepository()
        let viewModel = OwnerEditProfileViewModel(
            profile: makeProfile(),
            repository: repository
        )
        viewModel.form.displayName = "  "

        await viewModel.save()

        XCTAssertEqual(viewModel.validationMessage, "Add a display name before saving.")
        XCTAssertTrue(repository.updateIdentityCalls.isEmpty)
        XCTAssertTrue(repository.updateSportsCalls.isEmpty)
    }

    func test_save_whenUsernameInvalid_setsValidationStateWithoutSaving() async {
        let repository = MockProfileRepository()
        let viewModel = OwnerEditProfileViewModel(
            profile: makeProfile(),
            repository: repository
        )
        viewModel.form.username = "Bad Handle"

        await viewModel.save()

        XCTAssertEqual(
            viewModel.validationMessage,
            "Username must be 3-24 lowercase letters, numbers, or underscores."
        )
        XCTAssertTrue(repository.updateIdentityCalls.isEmpty)
    }

    func test_save_whenRepositoryFails_showsSafeErrorAndPreservesForm() async {
        let repository = MockProfileRepository()
        repository.updateAvailabilityError = ProfileRepositoryError.networkUnavailable
        let viewModel = OwnerEditProfileViewModel(
            profile: makeProfile(),
            repository: repository
        )
        viewModel.form.bio = "Keep this draft"

        await viewModel.save()

        XCTAssertEqual(viewModel.form.bio, "Keep this draft")
        XCTAssertEqual(
            viewModel.saveState,
            .error(message: "Check your connection and try saving again.")
        )
    }
}

private func makeProfile() -> OwnerEditableProfile {
    OwnerEditableProfile(
        id: "profile-1",
        displayName: "Test Player",
        username: "test_player",
        profilePhotoPath: nil,
        actionPhotoPath: nil,
        bio: "Ready to play.",
        sports: ["pickleball"],
        primarySport: "pickleball",
        skillLevelBySport: ["pickleball": 3],
        preferredDays: [.saturday],
        preferredTimeWindows: [.morning],
        playIntent: .casual,
        homeArea: "Austin",
        travelRadiusMiles: 10,
        preferredPlayStyle: .doubles,
        profileVisibility: .publicProfile,
        isDiscoverable: true,
        locationPrecision: .coarse,
        completionState: .discoveryReady,
        accountStatus: .active,
        createdAt: Date(timeIntervalSince1970: 0),
        lastActiveAt: nil
    )
}
