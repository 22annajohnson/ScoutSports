//
//  ProfileBuilderViewModelTests.swift
//  ScoutTests
//
//  Created by Codex on 4/2/26.
//

import XCTest
@testable import Scout

#if canImport(UIKit)
import UIKit

@MainActor
final class ProfileBuilderViewModelTests: XCTestCase {

    func test_saveProfile_whenMatchSignalsAndClubsUntouched_doesNotOverwriteExistingValues() async {
        let profileRepository = MockProfileRepository()
        let imageUploadService = MockImageUploadService()
        let userID = UUID()

        let viewModel = ProfileBuilderViewModel(
            profileRepository: profileRepository,
            matchSignalsRepository: profileRepository,
            profileRelationshipsRepository: profileRepository,
            imageUploadService: imageUploadService,
            userIDProvider: { userID }
        )
        viewModel.actionShotImage = UIImage()
        viewModel.form.bio = "Updated bio only"

        await viewModel.saveProfile()

        XCTAssertEqual(profileRepository.updateMyProfileCalls.count, 1)
        XCTAssertEqual(profileRepository.updateMatchSignalsCalls.count, 0)
        XCTAssertEqual(profileRepository.replaceClubMembershipCalls.count, 0)
    }

    func test_saveProfile_whenMatchSignalsAndClubsEdited_updatesThoseBoundaries() async {
        let profileRepository = MockProfileRepository()
        let imageUploadService = MockImageUploadService()
        let userID = UUID()

        let viewModel = ProfileBuilderViewModel(
            profileRepository: profileRepository,
            matchSignalsRepository: profileRepository,
            profileRelationshipsRepository: profileRepository,
            imageUploadService: imageUploadService,
            userIDProvider: { userID }
        )
        viewModel.actionShotImage = UIImage()
        viewModel.form.competitivenessRating = 4
        viewModel.form.friendlinessRating = 5
        viewModel.form.socialVibeRating = 4
        viewModel.form.preferredMatchIntensity = .competitive
        viewModel.form.clubsText = "Club A, Club B"

        await viewModel.saveProfile()

        XCTAssertEqual(profileRepository.updateMatchSignalsCalls.count, 1)
        XCTAssertEqual(profileRepository.replaceClubMembershipCalls.count, 1)
        XCTAssertEqual(profileRepository.replaceClubMembershipCalls.first, ["Club A", "Club B"])
    }

    func test_saveProfile_whenOnlyOneMatchSignalEdited_onlyPatchesThatSignal() async throws {
        let profileRepository = MockProfileRepository()
        let imageUploadService = MockImageUploadService()
        let userID = UUID()

        let viewModel = ProfileBuilderViewModel(
            profileRepository: profileRepository,
            matchSignalsRepository: profileRepository,
            profileRelationshipsRepository: profileRepository,
            imageUploadService: imageUploadService,
            userIDProvider: { userID }
        )
        viewModel.actionShotImage = UIImage()
        viewModel.form.competitivenessRating = 5

        await viewModel.saveProfile()

        XCTAssertEqual(profileRepository.updateMatchSignalsCalls.count, 1)
        let input = try XCTUnwrap(profileRepository.updateMatchSignalsCalls.first)
        XCTAssertEqual(input.competitivenessRating, 5)
        XCTAssertNil(input.friendlinessRating)
        XCTAssertNil(input.socialVibeRating)
        XCTAssertNil(input.preferredMatchIntensity)
    }

    func test_saveProfile_whenHomeCourtNameIsCleared_requestsNullHomeCourtWrites() async throws {
        let profileRepository = MockProfileRepository()
        let imageUploadService = MockImageUploadService()
        let userID = UUID()

        let viewModel = ProfileBuilderViewModel(
            profileRepository: profileRepository,
            matchSignalsRepository: profileRepository,
            profileRelationshipsRepository: profileRepository,
            imageUploadService: imageUploadService,
            userIDProvider: { userID }
        )
        viewModel.actionShotImage = UIImage()
        viewModel.form.homeCourtName = "   "

        await viewModel.saveProfile()

        XCTAssertEqual(profileRepository.updateMyProfileCalls.count, 1)
        let input = try XCTUnwrap(profileRepository.updateMyProfileCalls.first)
        XCTAssertTrue(input.shouldClearHomeCourtID)
        XCTAssertTrue(input.shouldClearHomeCourtName)
    }
}

private struct MockImageUploadService: ImageUploadProviding {
    func uploadActionShot(image: UIImage, compressionQuality: CGFloat) async throws -> String {
        "users/test/action.jpg"
    }

    func uploadHeadshot(image: UIImage, compressionQuality: CGFloat) async throws -> String {
        "users/test/headshot.jpg"
    }

    func uploadGalleryPhoto(photoID: UUID, image: UIImage, compressionQuality: CGFloat) async throws -> UploadedImage {
        UploadedImage(id: photoID, path: "users/test/\(photoID.uuidString).jpg")
    }
}
#endif
