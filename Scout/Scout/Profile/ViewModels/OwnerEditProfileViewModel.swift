//
//  OwnerEditProfileViewModel.swift
//  Scout
//

import Foundation
import Observation

@MainActor
@Observable
final class OwnerEditProfileViewModel {
    struct Form: Equatable {
        var displayName: String
        var username: String
        var bio: String
        var sportsText: String
        var primarySport: String
        var primarySkillLevel: Int
        var preferredDays: Set<ProfileWeekday>
        var preferredTimeWindows: Set<ProfileTimeWindow>
        var playIntent: ProfilePlayIntent?
        var homeArea: String
        var travelRadiusText: String
        var preferredPlayStyle: PreferredProfilePlayStyle?
        var profileVisibility: ProfileVisibility
        var isDiscoverable: Bool
        var locationPrecision: ProfileLocationPrecision
    }

    enum SaveState: Equatable {
        case idle
        case saving
        case saved(OwnerEditableProfile)
        case validation(message: String)
        case error(message: String)
    }

    private let repository: OwnerEditableProfileProviding
    var form: Form
    private(set) var saveState: SaveState = .idle

    init(profile: OwnerEditableProfile, repository: OwnerEditableProfileProviding) {
        self.repository = repository
        self.form = Form(profile: profile)
    }

    var isSaving: Bool {
        saveState == .saving
    }

    var validationMessage: String? {
        if case .validation(let message) = saveState {
            return message
        }

        return nil
    }

    func updateDisplayName(_ value: String) {
        form.displayName = value
        clearValidationMessage()
    }

    func updateUsername(_ value: String) {
        form.username = value
        clearValidationMessage()
    }

    func updateBio(_ value: String) {
        form.bio = value
        clearValidationMessage()
    }

    func updateSportsText(_ value: String) {
        form.sportsText = value
        clearValidationMessage()
    }

    func updatePrimarySport(_ value: String) {
        form.primarySport = value
        clearValidationMessage()
    }

    func updatePrimarySkillLevel(_ value: Int) {
        form.primarySkillLevel = value
        clearValidationMessage()
    }

    func toggleDay(_ day: ProfileWeekday) {
        if form.preferredDays.contains(day) {
            form.preferredDays.remove(day)
        } else {
            form.preferredDays.insert(day)
        }
    }

    func toggleTimeWindow(_ window: ProfileTimeWindow) {
        if form.preferredTimeWindows.contains(window) {
            form.preferredTimeWindows.remove(window)
        } else {
            form.preferredTimeWindows.insert(window)
        }
    }

    func save() async {
        do {
            let commands = try makeCommands()
            saveState = .saving

            var savedProfile = try await repository.updateIdentity(commands.identity)
            savedProfile = try await repository.updateSports(commands.sports)
            savedProfile = try await repository.updateAvailability(commands.availability)
            savedProfile = try await repository.updatePrivacy(commands.privacy)

            saveState = .saved(savedProfile)
        } catch let error as EditValidationError {
            saveState = .validation(message: error.message)
        } catch let error as ProfileRepositoryError {
            saveState = .error(message: error.ownerEditMessage)
        } catch {
            saveState = .error(message: "Could not save your profile. Please try again.")
        }
    }

    private func makeCommands() throws -> (
        identity: ProfileIdentityUpdateCommand,
        sports: ProfileSportsUpdateCommand,
        availability: ProfileAvailabilityUpdateCommand,
        privacy: ProfilePrivacyUpdateCommand
    ) {
        let displayName = form.displayName.trimmingCharacters(in: .whitespacesAndNewlines)
        let username = form.username.trimmingCharacters(in: .whitespacesAndNewlines)
        let bio = form.bio.trimmingCharacters(in: .whitespacesAndNewlines)
        let sports = normalizedSports(from: form.sportsText)
        let primarySport = form.primarySport.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let homeArea = form.homeArea.trimmingCharacters(in: .whitespacesAndNewlines)
        let travelRadius = try normalizedTravelRadius()

        let identity = ProfileIdentityUpdateCommand(
            displayName: displayName,
            username: username.isEmpty ? "" : username,
            bio: bio
        )
        let sportsCommand = ProfileSportsUpdateCommand(
            sports: sports,
            primarySport: primarySport.isEmpty ? sports.first : primarySport,
            skillLevelBySport: [primarySport.isEmpty ? (sports.first ?? "") : primarySport: form.primarySkillLevel]
        )
        let availability = ProfileAvailabilityUpdateCommand(
            preferredDays: ProfileWeekday.allCases.filter { form.preferredDays.contains($0) },
            preferredTimeWindows: ProfileTimeWindow.allCases.filter { form.preferredTimeWindows.contains($0) },
            playIntent: form.playIntent,
            homeArea: homeArea.isEmpty ? nil : homeArea,
            travelRadiusMiles: travelRadius,
            preferredPlayStyle: form.preferredPlayStyle
        )
        let privacy = ProfilePrivacyUpdateCommand(
            profileVisibility: form.profileVisibility,
            isDiscoverable: form.isDiscoverable,
            locationPrecision: form.locationPrecision
        )

        try validate(identity: identity, sports: sportsCommand, availability: availability)

        return (identity, sportsCommand, availability, privacy)
    }

    private func validate(
        identity: ProfileIdentityUpdateCommand,
        sports: ProfileSportsUpdateCommand,
        availability: ProfileAvailabilityUpdateCommand
    ) throws {
        if identity.displayName?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty != false {
            throw EditValidationError(message: "Add a display name before saving.")
        }

        if sports.sports.isEmpty {
            throw EditValidationError(message: "Add at least one sport before saving.")
        }

        let errors = identity.validationErrors() + sports.validationErrors() + availability.validationErrors()
        if let message = errors.first?.editMessage {
            throw EditValidationError(message: message)
        }
    }

    private func normalizedTravelRadius() throws -> Int? {
        let trimmed = form.travelRadiusText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }

        guard let radius = Int(trimmed) else {
            throw EditValidationError(message: "Travel radius must be a number of miles.")
        }

        return radius
    }

    private func normalizedSports(from text: String) -> [String] {
        var seen = Set<String>()
        return text
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() }
            .filter { !$0.isEmpty }
            .filter { seen.insert($0).inserted }
    }

    private func clearValidationMessage() {
        if case .validation = saveState {
            saveState = .idle
        }
    }
}

private struct EditValidationError: Error {
    let message: String
}

private extension OwnerEditProfileViewModel.Form {
    init(profile: OwnerEditableProfile) {
        let sports = profile.sports.isEmpty ? ["pickleball"] : profile.sports
        let primarySport = profile.primarySport ?? sports.first ?? "pickleball"

        self.init(
            displayName: profile.displayName,
            username: profile.username ?? "",
            bio: profile.bio ?? "",
            sportsText: sports.joined(separator: ", "),
            primarySport: primarySport,
            primarySkillLevel: profile.skillLevelBySport[primarySport] ?? 3,
            preferredDays: Set(profile.preferredDays),
            preferredTimeWindows: Set(profile.preferredTimeWindows),
            playIntent: profile.playIntent,
            homeArea: profile.homeArea ?? "",
            travelRadiusText: profile.travelRadiusMiles.map(String.init) ?? "",
            preferredPlayStyle: profile.preferredPlayStyle,
            profileVisibility: profile.profileVisibility,
            isDiscoverable: profile.isDiscoverable,
            locationPrecision: profile.locationPrecision
        )
    }
}

private extension ProfileUpdateValidationError {
    nonisolated var editMessage: String {
        switch self {
        case .displayNameLength:
            return "Display name must be 2-40 characters."
        case .usernameFormat:
            return "Username must be 3-24 lowercase letters, numbers, or underscores."
        case .primarySportNotSelected:
            return "Primary sport must be included in your sports."
        case .primarySportSkillMissing:
            return "Choose a skill level for your primary sport."
        case .travelRadiusOutOfRange:
            return "Travel radius must be between 1 and 100 miles."
        }
    }
}

private extension ProfileRepositoryError {
    nonisolated var ownerEditMessage: String {
        switch self {
        case .notAuthenticated:
            return "Sign in again before saving your profile."
        case .permissionDenied:
            return "You do not have permission to update this profile."
        case .networkUnavailable:
            return "Check your connection and try saving again."
        case .serverUnavailable:
            return "Scout is having trouble saving your profile. Please try again."
        case .validationFailed(let errors):
            return errors.first?.editMessage ?? "Check your profile details and try again."
        case .conflictOrStaleWrite:
            return "Refresh your profile and try saving again."
        case .profileMissing:
            return "Create your profile before saving changes."
        case .decodingFailed, .mappingFailed, .unknown:
            return "Could not save your profile. Please try again."
        }
    }
}
