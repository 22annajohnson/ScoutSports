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

#if canImport(UIKit)
import UIKit
#endif

@MainActor
@Observable
final class ProfileBuilderViewModel {

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
    }

    struct Form: Equatable {
        var clubsText: String = ""
        var homeCourtName: String = ""
        var background: Background = .beginner
        var skill: Int = 3
        var playStyle: PlayStyle = .casual
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
    private let imageUploadService: ImageUploadProviding
    private let userIDProvider: () -> UUID?

    // MARK: - Published state

    var step: Step = .actionShot
    var form: Form = .init()

    var actionShotItem: PhotosPickerItem?
    var headshotItem: PhotosPickerItem?

    var actionShotImage: UIImage?
    var headshotImage: UIImage?

    var isSaving: Bool = false

    // Alerts
    var isShowingAlert: Bool = false
    var alertTitle: String = ""
    var alertMessage: String = ""

    init(
        mode: Mode = .requiredForMatching,
        profileRepository: ProfileProviding,
        imageUploadService: ImageUploadProviding,
        userIDProvider: @escaping () -> UUID?
    ) {
        self.mode = mode
        self.profileRepository = profileRepository
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

            // 3) Update profile fields
            var input = PlayerPublicProfileUpdateInput()

            let homeCourtTrimmed = form.homeCourtName.trimmingCharacters(in: .whitespacesAndNewlines)
            if homeCourtTrimmed.isEmpty {
                input.homeCourtID = nil
                input.homeCourtName = nil
            } else {
                input.homeCourtID = UUID()
                input.homeCourtName = homeCourtTrimmed
            }

            input.backgroundLevel = form.background.toRepoValue()
            input.skillLevel = Int16(form.skill)
            input.playStyle = form.playStyle.toRepoValue()

            let bioTrimmed = form.bio.trimmingCharacters(in: .whitespacesAndNewlines)
            input.bio = bioTrimmed.isEmpty ? nil : bioTrimmed

            try await profileRepository.updateCurrentUserProfile(input)
            
            // 4) Mark completion
            try await profileRepository.markProfileCompletedIfReady()

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
