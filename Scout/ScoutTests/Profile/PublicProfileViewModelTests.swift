//
//  PublicProfileViewModelTests.swift
//  ScoutTests
//

import XCTest
@testable import Scout

@MainActor
final class PublicProfileViewModelTests: XCTestCase {
    private let profileID = UUID(uuidString: "00000000-0000-0000-0000-000000000202")!

    func test_load_usesPublicRepositoryAndPublishesLoadedProfile() async {
        let repository = MockProfileRepository()
        let viewModel = PublicProfileViewModel(profileID: profileID, repository: repository)

        await viewModel.load()

        XCTAssertEqual(repository.publicProfileCalls, [profileID])
        XCTAssertEqual(viewModel.profile, repository.publicProfileResult)
        XCTAssertEqual(viewModel.state, .loaded(repository.publicProfileResult))
        XCTAssertFalse(viewModel.isLoading)
    }

    func test_load_whenPublicProfileMissingPublishesIncompleteState() async {
        let repository = MockProfileRepository()
        repository.publicProfileError = ProfileRepositoryError.profileMissing
        let viewModel = PublicProfileViewModel(profileID: profileID, repository: repository)

        await viewModel.load()

        XCTAssertEqual(repository.publicProfileCalls, [profileID])
        XCTAssertEqual(
            viewModel.state,
            .incomplete(message: "This profile is not available yet.")
        )
        XCTAssertTrue(viewModel.isIncomplete)
    }

    func test_load_whenProfileHasNoPublicSportsPublishesIncompleteState() async {
        let repository = MockProfileRepository()
        repository.publicProfileResult = PublicProfile(
            id: profileID,
            displayName: "No Sports Yet",
            username: "no_sports",
            profilePhotoPath: nil,
            bio: nil,
            sports: []
        )
        let viewModel = PublicProfileViewModel(profileID: profileID, repository: repository)

        await viewModel.load()

        XCTAssertEqual(
            viewModel.state,
            .incomplete(message: "This profile is not ready to show yet.")
        )
    }

    func test_load_whenRepositoryFailsPublishesSafeError() async {
        let repository = MockProfileRepository()
        repository.publicProfileError = ProfileRepositoryError.networkUnavailable
        let viewModel = PublicProfileViewModel(profileID: profileID, repository: repository)

        await viewModel.load()

        XCTAssertEqual(
            viewModel.state,
            .error(message: "Check your connection and try again.")
        )
        XCTAssertNil(viewModel.profile)
    }

    func test_publicViewModelExposesOnlyPublicProfileContract() async throws {
        let repository = MockProfileRepository()
        let viewModel = PublicProfileViewModel(profileID: profileID, repository: repository)

        await viewModel.load()

        let profile = try XCTUnwrap(viewModel.profile)
        XCTAssertEqual(profile.displayName, "Public Test")
        XCTAssertEqual(profile.username, "public_test")
        XCTAssertEqual(profile.bio, "Ready to rally.")
        XCTAssertEqual(profile.sports.first?.sportSlug, "pickleball")
    }
}
