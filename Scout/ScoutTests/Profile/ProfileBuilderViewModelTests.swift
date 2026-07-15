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
            ownerEditableProfileRepository: profileRepository,
            matchSignalsRepository: profileRepository,
            profileRelationshipsRepository: profileRepository,
            imageUploadService: imageUploadService,
            userIDProvider: { userID }
        )
        viewModel.actionShotImage = UIImage()
        viewModel.form.bio = "Updated bio only"

        await viewModel.saveProfile()

        XCTAssertEqual(profileRepository.updateMyProfileCalls.count, 0)
        XCTAssertEqual(profileRepository.updateIdentityCalls.count, 1)
        XCTAssertEqual(profileRepository.updateSportsCalls.count, 1)
        XCTAssertEqual(profileRepository.updateAvailabilityCalls.count, 1)
        XCTAssertEqual(profileRepository.updateMatchSignalsCalls.count, 0)
        XCTAssertEqual(profileRepository.replaceClubMembershipCalls.count, 0)
    }

    func test_saveProfile_whenMatchSignalsAndClubsEdited_updatesThoseBoundaries() async {
        let profileRepository = MockProfileRepository()
        let imageUploadService = MockImageUploadService()
        let userID = UUID()

        let viewModel = ProfileBuilderViewModel(
            profileRepository: profileRepository,
            ownerEditableProfileRepository: profileRepository,
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
            ownerEditableProfileRepository: profileRepository,
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
            ownerEditableProfileRepository: profileRepository,
            matchSignalsRepository: profileRepository,
            profileRelationshipsRepository: profileRepository,
            imageUploadService: imageUploadService,
            userIDProvider: { userID }
        )
        viewModel.actionShotImage = UIImage()
        viewModel.form.homeCourtName = "   "

        await viewModel.saveProfile()

        XCTAssertEqual(profileRepository.updateAvailabilityCalls.count, 1)
        let input = try XCTUnwrap(profileRepository.updateAvailabilityCalls.first)
        XCTAssertNil(input.homeArea)
    }

    func test_loadProfile_prefillsOwnerEditableFieldsWithoutMarkingSignalsEdited() async {
        let profileRepository = MockProfileRepository()
        let imageUploadService = MockImageUploadService()
        let userID = UUID()
        profileRepository.currentEditableProfileResult.bio = "Ready for doubles"
        profileRepository.currentEditableProfileResult.skillLevelBySport = ["pickleball": 4]
        profileRepository.currentEditableProfileResult.playIntent = .competitive
        profileRepository.currentEditableProfileResult.homeArea = "North Courts"
        profileRepository.currentEditableProfileResult.preferredPlayStyle = .doubles

        let viewModel = ProfileBuilderViewModel(
            profileRepository: profileRepository,
            ownerEditableProfileRepository: profileRepository,
            matchSignalsRepository: profileRepository,
            profileRelationshipsRepository: profileRepository,
            imageUploadService: imageUploadService,
            userIDProvider: { userID }
        )

        await viewModel.loadProfileIfNeeded()
        viewModel.actionShotImage = UIImage()
        await viewModel.saveProfile()

        XCTAssertEqual(viewModel.form.bio, "Ready for doubles")
        XCTAssertEqual(viewModel.form.skill, 4)
        XCTAssertEqual(viewModel.form.preferredMatchIntensity, .competitive)
        XCTAssertEqual(viewModel.form.homeCourtName, "North Courts")
        XCTAssertEqual(viewModel.form.playStyle, .doubles)
        XCTAssertEqual(profileRepository.currentEditableProfileCalls, [false])
        XCTAssertEqual(profileRepository.updateMatchSignalsCalls.count, 0)
        XCTAssertEqual(profileRepository.replaceClubMembershipCalls.count, 0)
    }

    func test_saveProfile_preservesLoadedAvailabilityFieldsThatBuilderDoesNotEdit() async throws {
        let profileRepository = MockProfileRepository()
        let imageUploadService = MockImageUploadService()
        let userID = UUID()
        profileRepository.currentEditableProfileResult.preferredDays = [.monday, .wednesday]
        profileRepository.currentEditableProfileResult.preferredTimeWindows = [.evening]
        profileRepository.currentEditableProfileResult.playIntent = .competitive
        profileRepository.currentEditableProfileResult.travelRadiusMiles = 15
        profileRepository.currentEditableProfileResult.preferredPlayStyle = .open

        let viewModel = ProfileBuilderViewModel(
            profileRepository: profileRepository,
            ownerEditableProfileRepository: profileRepository,
            matchSignalsRepository: profileRepository,
            profileRelationshipsRepository: profileRepository,
            imageUploadService: imageUploadService,
            userIDProvider: { userID }
        )

        await viewModel.loadProfileIfNeeded()
        viewModel.actionShotImage = UIImage()
        await viewModel.saveProfile()

        let input = try XCTUnwrap(profileRepository.updateAvailabilityCalls.first)
        XCTAssertEqual(input.preferredDays, [.monday, .wednesday])
        XCTAssertEqual(input.preferredTimeWindows, [.evening])
        XCTAssertEqual(input.playIntent, .competitive)
        XCTAssertEqual(input.travelRadiusMiles, 15)
        XCTAssertEqual(input.preferredPlayStyle, .open)
    }

    func test_saveProfile_whenOwnerRepositoryFails_preservesUnsavedInput() async {
        let profileRepository = MockProfileRepository()
        let imageUploadService = MockImageUploadService()
        let userID = UUID()
        profileRepository.updateIdentityError = ProfileRepositoryError.networkUnavailable

        let viewModel = ProfileBuilderViewModel(
            profileRepository: profileRepository,
            ownerEditableProfileRepository: profileRepository,
            matchSignalsRepository: profileRepository,
            profileRelationshipsRepository: profileRepository,
            imageUploadService: imageUploadService,
            userIDProvider: { userID }
        )
        viewModel.actionShotImage = UIImage()
        viewModel.form.bio = "Do not lose this"

        await viewModel.saveProfile()

        XCTAssertEqual(viewModel.form.bio, "Do not lose this")
        XCTAssertTrue(viewModel.isShowingAlert)
        XCTAssertEqual(viewModel.alertTitle, "Save Failed")
        XCTAssertFalse(viewModel.didSaveSuccessfully)
    }

    func test_loadProfile_whenProfileMissing_setsSetupNeededMessageAndStopsLoading() async {
        let profileRepository = MockProfileRepository()
        let imageUploadService = MockImageUploadService()
        let userID = UUID()
        profileRepository.currentEditableProfileError = ProfileRepositoryError.profileMissing

        let viewModel = ProfileBuilderViewModel(
            profileRepository: profileRepository,
            ownerEditableProfileRepository: profileRepository,
            matchSignalsRepository: profileRepository,
            profileRelationshipsRepository: profileRepository,
            imageUploadService: imageUploadService,
            userIDProvider: { userID }
        )

        await viewModel.loadProfile(forceRefresh: true)

        XCTAssertEqual(profileRepository.currentEditableProfileCalls, [true])
        XCTAssertFalse(viewModel.isLoadingProfile)
        XCTAssertEqual(viewModel.profileLoadErrorMessage, "Profile setup needed.")
        XCTAssertFalse(viewModel.isShowingAlert)
    }

    func test_loadProfile_whenPermissionDenied_setsUiSafeLoadError() async {
        let profileRepository = MockProfileRepository()
        let imageUploadService = MockImageUploadService()
        let userID = UUID()
        profileRepository.currentEditableProfileError = ProfileRepositoryError.permissionDenied

        let viewModel = ProfileBuilderViewModel(
            profileRepository: profileRepository,
            ownerEditableProfileRepository: profileRepository,
            matchSignalsRepository: profileRepository,
            profileRelationshipsRepository: profileRepository,
            imageUploadService: imageUploadService,
            userIDProvider: { userID }
        )

        await viewModel.loadProfile(forceRefresh: false)

        XCTAssertFalse(viewModel.isLoadingProfile)
        XCTAssertEqual(viewModel.profileLoadErrorMessage, "Couldn’t load your profile. You can keep editing and try saving again.")
        XCTAssertFalse(viewModel.profileLoadErrorMessage?.localizedCaseInsensitiveContains("supabase") ?? true)
        XCTAssertFalse(viewModel.profileLoadErrorMessage?.localizedCaseInsensitiveContains("rls") ?? true)
    }

    func test_saveProfile_whenValidationFailure_preservesFormStateAndUsesSaveFailureState() async {
        let profileRepository = MockProfileRepository()
        let imageUploadService = MockImageUploadService()
        let userID = UUID()
        profileRepository.updateAvailabilityError = ProfileRepositoryError.validationFailed([.travelRadiusOutOfRange])

        let viewModel = ProfileBuilderViewModel(
            profileRepository: profileRepository,
            ownerEditableProfileRepository: profileRepository,
            matchSignalsRepository: profileRepository,
            profileRelationshipsRepository: profileRepository,
            imageUploadService: imageUploadService,
            userIDProvider: { userID }
        )
        viewModel.actionShotImage = UIImage()
        viewModel.form.bio = "Keep me"
        viewModel.form.homeCourtName = "East Courts"

        await viewModel.saveProfile()

        XCTAssertEqual(viewModel.form.bio, "Keep me")
        XCTAssertEqual(viewModel.form.homeCourtName, "East Courts")
        XCTAssertTrue(viewModel.isShowingAlert)
        XCTAssertEqual(viewModel.alertTitle, "Save Failed")
        XCTAssertFalse(viewModel.didSaveSuccessfully)
    }

    func test_saveProfile_whenRepositoryWritesSucceed_setsSavedState() async {
        let profileRepository = MockProfileRepository()
        let imageUploadService = MockImageUploadService()
        let userID = UUID()

        let viewModel = ProfileBuilderViewModel(
            profileRepository: profileRepository,
            ownerEditableProfileRepository: profileRepository,
            matchSignalsRepository: profileRepository,
            profileRelationshipsRepository: profileRepository,
            imageUploadService: imageUploadService,
            userIDProvider: { userID }
        )
        viewModel.actionShotImage = UIImage()

        await viewModel.saveProfile()

        XCTAssertFalse(viewModel.isSaving)
        XCTAssertTrue(viewModel.didSaveSuccessfully)
        XCTAssertFalse(viewModel.isShowingAlert)
        XCTAssertEqual(profileRepository.updateIdentityCalls.count, 1)
        XCTAssertEqual(profileRepository.updateSportsCalls.count, 1)
        XCTAssertEqual(profileRepository.updateAvailabilityCalls.count, 1)
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
