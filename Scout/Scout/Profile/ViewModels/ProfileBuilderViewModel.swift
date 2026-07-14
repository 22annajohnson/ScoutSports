//
//  ProfileBuilderViewModel.swift
//  Scout
//
//  Created by Anna on 3/2/26.
//

import Foundation
import Observation
import PhotosUI
import SwiftUI
import ScoutDesign

#if canImport(UIKit)
import UIKit
#endif

@MainActor
@Observable
final class ProfileBuilderViewModel {
    private enum MatchSignalField: Hashable {
        case competitivenessRating
        case friendlinessRating
        case socialVibeRating
        case preferredMatchIntensity
    }

    // MARK: - Mode

    enum Mode {
        /// Used when you want to block matching until required info exists.
        case requiredForMatching
        /// Used when you let the user explore first and just nudge completion.
        case optional
    }

    // MARK: - Steps

    enum Step: Int, CaseIterable, Hashable {
        case actionShot
        case headshot
        case clubsAndCourts
        case background
        case playStyle
        case bio
        case review

        var title: String {
            switch self {
            case .actionShot: return "Action Shot"
            case .headshot: return "Headshot"
            case .clubsAndCourts: return "Clubs & Courts"
            case .background: return "Background"
            case .playStyle: return "Play Style"
            case .bio: return "Bio"
            case .review: return "Review"
            }
        }
    }

    enum Background: String, CaseIterable, Hashable {
        case beginner
        case club
        case high_school
        case college
        case professional

        var displayName: String {
            switch self {
            case .beginner: return "Beginner"
            case .club: return "Club"
            case .high_school: return "High school"
            case .college: return "College"
            case .professional: return "Professional"
            }
        }

        func toRepoValue() -> ProfileBackgroundLevel {
            switch self {
            case .beginner: return .beginner
            case .club: return .club
            case .high_school: return .high_school
            case .college: return .college
            case .professional: return .professional
            }
        }
    }

    enum PlayStyle: String, CaseIterable, Hashable {
        case casual
        case competitive
        case drills
        case doubles
        case singles

        var displayName: String {
            switch self {
            case .casual: return "Casual"
            case .competitive: return "Competitive"
            case .drills: return "Drills / practice"
            case .doubles: return "Mostly doubles"
            case .singles: return "Mostly singles"
            }
        }

        func toRepoValue() -> ProfilePlayStyle {
            switch self {
            case .casual: return .casual
            case .competitive: return .competitive
            case .drills: return .drills
            case .doubles: return .doubles
            case .singles: return .singles
            }
        }

        init?(preferredProfilePlayStyle: PreferredProfilePlayStyle) {
            switch preferredProfilePlayStyle {
            case .singles:
                self = .singles
            case .doubles, .mixed:
                self = .doubles
            case .open:
                return nil
            }
        }

        var preferredProfilePlayStyle: PreferredProfilePlayStyle? {
            switch self {
            case .doubles:
                return .doubles
            case .singles:
                return .singles
            case .casual, .competitive, .drills:
                return nil
            }
        }
    }

    enum MatchIntensity: String, CaseIterable, Hashable {
        case casual
        case balanced
        case competitive

        var displayName: String {
            switch self {
            case .casual: return "Casual"
            case .balanced: return "Balanced"
            case .competitive: return "Competitive"
            }
        }

        init(playIntent: ProfilePlayIntent) {
            switch playIntent {
            case .casual:
                self = .casual
            case .competitive:
                self = .competitive
            case .flexible:
                self = .balanced
            }
        }

        var playIntent: ProfilePlayIntent {
            switch self {
            case .casual:
                return .casual
            case .balanced:
                return .flexible
            case .competitive:
                return .competitive
            }
        }
    }

    struct Form: Equatable {
        var clubsText: String = ""
        var homeCourtName: String = ""
        var background: Background = .beginner
        var skill: Int = 3
        var playStyle: PlayStyle = .casual
        var competitivenessRating: Int = 3
        var friendlinessRating: Int = 3
        var socialVibeRating: Int = 3
        var preferredMatchIntensity: MatchIntensity = .balanced
        var bio: String = ""

        var clubs: [String] {
            clubsText
                .split(separator: ",")
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                .filter { !$0.isEmpty }
        }
    }

    // MARK: - Dependencies

    private let mode: Mode
    private let profileRepository: ProfileProviding
    private let ownerEditableProfileRepository: OwnerEditableProfileProviding
    private let matchSignalsRepository: PlayerMatchSignalsProviding
    private let profileRelationshipsRepository: PlayerProfileRelationshipsProviding
    private let imageUploadService: ImageUploadProviding
    private let userIDProvider: () -> UUID?

    // MARK: - Published state

    var step: Step = .actionShot
    var form: Form = .init() {
        didSet {
            guard !isApplyingLoadedProfile else { return }

            if oldValue.clubsText != form.clubsText {
                didEditClubs = true
            }

            if oldValue.competitivenessRating != form.competitivenessRating {
                editedMatchSignalFields.insert(.competitivenessRating)
            }
            if oldValue.friendlinessRating != form.friendlinessRating {
                editedMatchSignalFields.insert(.friendlinessRating)
            }
            if oldValue.socialVibeRating != form.socialVibeRating {
                editedMatchSignalFields.insert(.socialVibeRating)
            }
            if oldValue.preferredMatchIntensity != form.preferredMatchIntensity {
                editedMatchSignalFields.insert(.preferredMatchIntensity)
            }
        }
    }

    var actionShotItem: PhotosPickerItem?
    var headshotItem: PhotosPickerItem?

    var actionShotImage: UIImage?
    var headshotImage: UIImage?

    var isSaving: Bool = false
    var isLoadingProfile: Bool = false
    var didSaveSuccessfully: Bool = false
    var profileLoadErrorMessage: String?
    private var didEditClubs: Bool = false
    private var loadedPreferredDays: [ProfileWeekday] = []
    private var loadedPreferredTimeWindows: [ProfileTimeWindow] = []
    private var loadedPlayIntent: ProfilePlayIntent?
    private var loadedTravelRadiusMiles: Int?
    private var loadedPreferredPlayStyle: PreferredProfilePlayStyle?
    private var hasLoadedProfile: Bool = false
    private var isApplyingLoadedProfile: Bool = false
    private var editedMatchSignalFields: Set<MatchSignalField> = []

    // Alerts
    var isShowingAlert: Bool = false
    var alertTitle: String = ""
    var alertMessage: String = ""

    init(
        mode: Mode = .requiredForMatching,
        profileRepository: ProfileProviding,
        ownerEditableProfileRepository: OwnerEditableProfileProviding,
        matchSignalsRepository: PlayerMatchSignalsProviding,
        profileRelationshipsRepository: PlayerProfileRelationshipsProviding,
        imageUploadService: ImageUploadProviding,
        userIDProvider: @escaping () -> UUID?
    ) {
        self.mode = mode
        self.profileRepository = profileRepository
        self.ownerEditableProfileRepository = ownerEditableProfileRepository
        self.matchSignalsRepository = matchSignalsRepository
        self.profileRelationshipsRepository = profileRelationshipsRepository
        self.imageUploadService = imageUploadService
        self.userIDProvider = userIDProvider
    }

    // MARK: - Navigation

    var canGoBack: Bool { step.rawValue > 0 }

    func goBack() {
        guard canGoBack else { return }
        step = Step(rawValue: step.rawValue - 1) ?? step
    }

    func goNextOrShowValidationError() {
        guard validate(step: step) else {
            showAlert(title: "Missing Info", message: validationMessage(for: step))
            return
        }

        step = Step(rawValue: step.rawValue + 1) ?? step
    }

    // MARK: - Validation

    func validateAllSteps() -> Bool {
        Step.allCases.allSatisfy { validate(step: $0) }
    }

    func validate(step: Step) -> Bool {
        switch step {
        case .actionShot:
            return actionShotImage != nil
        case .headshot:
            return true // optional
        case .clubsAndCourts:
            return true
        case .background:
            return true
        case .playStyle:
            return (1...5).contains(form.skill)
        case .bio:
            return true
        case .review:
            return actionShotImage != nil
        }
    }

    func validationMessage(for step: Step) -> String {
        switch step {
        case .actionShot:
            return "Please add an action shot to continue."
        case .review:
            return "Please add an action shot before saving."
        default:
            return "Please complete this step to continue."
        }
    }

    // MARK: - Picker loading

    func loadActionShotIfNeeded() async {
        guard let actionShotItem else {
            actionShotImage = nil
            return
        }
        do {
            if let data = try await actionShotItem.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data) {
                actionShotImage = uiImage
            }
        } catch {
            showAlert(title: "Photo Error", message: "Couldn’t load that photo. Please try another.")
        }
    }

    func loadHeadshotIfNeeded() async {
        guard let headshotItem else {
            headshotImage = nil
            return
        }
        do {
            if let data = try await headshotItem.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data) {
                headshotImage = uiImage
            }
        } catch {
            showAlert(title: "Photo Error", message: "Couldn’t load that photo. Please try another.")
        }
    }

    // MARK: - Repository loading

    func loadProfileIfNeeded() async {
        guard !hasLoadedProfile else { return }
        await loadProfile(forceRefresh: false)
    }

    func loadProfile(forceRefresh: Bool) async {
        isLoadingProfile = true
        profileLoadErrorMessage = nil
        defer { isLoadingProfile = false }

        do {
            let profile = try await ownerEditableProfileRepository.currentEditableProfile(forceRefresh: forceRefresh)
            apply(profile)
            hasLoadedProfile = true
        } catch let error as ProfileRepositoryError {
            if case .profileMissing = error {
                profileLoadErrorMessage = "Profile setup needed."
                hasLoadedProfile = true
            } else {
                profileLoadErrorMessage = "Couldn’t load your profile. You can keep editing and try saving again."
            }
        } catch {
            profileLoadErrorMessage = "Couldn’t load your profile. You can keep editing and try saving again."
        }
    }

    private func apply(_ profile: OwnerEditableProfile) {
        isApplyingLoadedProfile = true
        defer { isApplyingLoadedProfile = false }

        form.bio = profile.bio ?? ""
        if let primarySport = profile.primarySport,
           let skill = profile.skillLevelBySport[primarySport],
           (1...5).contains(skill) {
            form.skill = skill
        }
        if let playIntent = profile.playIntent {
            form.preferredMatchIntensity = MatchIntensity(playIntent: playIntent)
        }
        if let homeArea = profile.homeArea {
            form.homeCourtName = homeArea
        }
        if let preferredPlayStyle = profile.preferredPlayStyle,
           let playStyle = PlayStyle(preferredProfilePlayStyle: preferredPlayStyle) {
            form.playStyle = playStyle
        }

        loadedPreferredDays = profile.preferredDays
        loadedPreferredTimeWindows = profile.preferredTimeWindows
        loadedPlayIntent = profile.playIntent
        loadedTravelRadiusMiles = profile.travelRadiusMiles
        loadedPreferredPlayStyle = profile.preferredPlayStyle
    }

    // MARK: - Saving

    func saveProfile() async {
        guard validateAllSteps() else {
            showAlert(title: "Missing Info", message: validationMessage(for: step))
            return
        }

        guard userIDProvider() != nil else {
            showAlert(title: "Not Signed In", message: "Please sign in again.")
            return
        }

        guard let actionShotImage else {
            showAlert(title: "Action Shot Required", message: "Please add an action shot.")
            return
        }

        isSaving = true
        defer { isSaving = false }

        do {
            // 1) Upload required action shot
            let actionPath = try await imageUploadService.uploadActionShot(image: actionShotImage)
            try await profileRepository.setCurrentUserSinglePhoto(type: .action, path: actionPath, blurhash: nil)

            // 2) Upload optional headshot
            if let headshotImage {
                let headshotPath = try await imageUploadService.uploadHeadshot(image: headshotImage)
                try await profileRepository.setCurrentUserSinglePhoto(type: .headshot, path: headshotPath, blurhash: nil)
            }

            // 3) Update approved owner-editable profile fields
            let homeCourtTrimmed = form.homeCourtName.trimmingCharacters(in: .whitespacesAndNewlines)
            let bioTrimmed = form.bio.trimmingCharacters(in: .whitespacesAndNewlines)
            _ = try await ownerEditableProfileRepository.updateIdentity(
                ProfileIdentityUpdateCommand(
                    displayName: nil,
                    username: nil,
                    bio: bioTrimmed.isEmpty ? "" : bioTrimmed
                )
            )
            _ = try await ownerEditableProfileRepository.updateSports(
                ProfileSportsUpdateCommand(
                    sports: ["pickleball"],
                    primarySport: "pickleball",
                    skillLevelBySport: ["pickleball": form.skill]
                )
            )
            _ = try await ownerEditableProfileRepository.updateAvailability(
                ProfileAvailabilityUpdateCommand(
                    preferredDays: loadedPreferredDays,
                    preferredTimeWindows: loadedPreferredTimeWindows,
                    playIntent: editedMatchSignalFields.contains(.preferredMatchIntensity)
                        ? form.preferredMatchIntensity.playIntent
                        : loadedPlayIntent,
                    homeArea: homeCourtTrimmed.isEmpty ? nil : homeCourtTrimmed,
                    travelRadiusMiles: loadedTravelRadiusMiles,
                    preferredPlayStyle: form.playStyle.preferredProfilePlayStyle ?? loadedPreferredPlayStyle
                )
            )

            if !editedMatchSignalFields.isEmpty {
                var matchSignalsInput = PlayerMatchSignalsUpdateInput()
                if editedMatchSignalFields.contains(.competitivenessRating) {
                    matchSignalsInput.competitivenessRating = form.competitivenessRating
                }
                if editedMatchSignalFields.contains(.friendlinessRating) {
                    matchSignalsInput.friendlinessRating = form.friendlinessRating
                }
                if editedMatchSignalFields.contains(.socialVibeRating) {
                    matchSignalsInput.socialVibeRating = form.socialVibeRating
                }
                if editedMatchSignalFields.contains(.preferredMatchIntensity) {
                    matchSignalsInput.preferredMatchIntensity = form.preferredMatchIntensity.rawValue
                }

                try await matchSignalsRepository.updateCurrentUserMatchSignals(matchSignalsInput)
            }

            if didEditClubs {
                try await profileRelationshipsRepository.replaceCurrentUserClubMemberships(with: form.clubs)
            }
            
            editedMatchSignalFields.removeAll()
            didEditClubs = false
            didSaveSuccessfully = true

        } catch {
            showAlert(title: "Save Failed", message: error.localizedDescription)
        }
    }

    // MARK: - Alerts

    func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        isShowingAlert = true
    }
}
