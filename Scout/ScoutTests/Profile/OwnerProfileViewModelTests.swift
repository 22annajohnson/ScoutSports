//
//  OwnerProfileViewModelTests.swift
//  ScoutTests
//

import XCTest
@testable import Scout

@MainActor
final class OwnerProfileViewModelTests: XCTestCase {
    func test_load_usesRepositoryAndPublishesLoadedProfile() async {
        let repository = MockProfileRepository()
        repository.currentEditableProfileResult = makeOwnerProfile(completionState: .discoveryReady)
        let viewModel = OwnerProfileViewModel(repository: repository)

        await viewModel.load(forceRefresh: true)

        XCTAssertEqual(repository.currentEditableProfileCalls, [true])
        XCTAssertEqual(viewModel.profile, repository.currentEditableProfileResult)
        XCTAssertEqual(viewModel.state, .loaded(repository.currentEditableProfileResult))
        XCTAssertFalse(viewModel.isLoading)
    }

    func test_load_whenProfileMissingPublishesIncompleteState() async {
        let repository = MockProfileRepository()
        repository.currentEditableProfileError = ProfileRepositoryError.profileMissing
        let viewModel = OwnerProfileViewModel(repository: repository)

        await viewModel.load()

        XCTAssertEqual(repository.currentEditableProfileCalls, [false])
        XCTAssertEqual(
            viewModel.state,
            .incomplete(message: "Create your profile to start matching with players.")
        )
        XCTAssertTrue(viewModel.isIncomplete)
    }

    func test_load_whenAccountCreatedPublishesIncompleteState() async {
        let repository = MockProfileRepository()
        repository.currentEditableProfileResult = makeOwnerProfile(completionState: .accountCreated)
        let viewModel = OwnerProfileViewModel(repository: repository)

        await viewModel.load()

        XCTAssertEqual(
            viewModel.state,
            .incomplete(message: "Finish setting up your profile so other players know how you like to play.")
        )
    }

    func test_load_whenRepositoryFailsPublishesSafeError() async {
        let repository = MockProfileRepository()
        repository.currentEditableProfileError = ProfileRepositoryError.permissionDenied
        let viewModel = OwnerProfileViewModel(repository: repository)

        await viewModel.load()

        XCTAssertEqual(
            viewModel.state,
            .error(message: "You do not have permission to view this profile.")
        )
        XCTAssertNil(viewModel.profile)
    }
}

private extension OwnerProfileViewModelTests {
    func makeOwnerProfile(completionState: ProfileCompletionState) -> OwnerEditableProfile {
        OwnerEditableProfile(
            id: "profile-1",
            displayName: "Test Player",
            username: "test_player",
            profilePhotoPath: "profiles/profile-1/avatar.jpg",
            actionPhotoPath: "profiles/profile-1/action.jpg",
            bio: "Ready to rally.",
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
            completionState: completionState,
            accountStatus: .active,
            createdAt: Date(timeIntervalSince1970: 0),
            lastActiveAt: nil
        )
    }
}
