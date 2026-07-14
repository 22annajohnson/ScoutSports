//
//  OwnerEditableProfileMapper.swift
//  Scout
//

import Foundation

struct OwnerEditableProfileRow: Equatable, Sendable {
    var id: UUID
    var displayName: String?
    var username: String?
    var profilePhotoPath: String?
    var actionPhotoPath: String?
    var bio: String?
    var profileCompletionState: String
    var accountStatus: String
    var createdAt: String
    var lastActiveAt: String?
}

struct OwnerProfileSportRow: Equatable, Sendable {
    var profileId: UUID
    var sportSlug: String
    var skillLevel: String?
    var isPrimary: Bool
}

struct OwnerProfileAvailabilityRow: Equatable, Sendable {
    var profileId: UUID
    var preferredDays: [String]
    var preferredTimes: [String]
    var playIntent: String?
    var homeArea: String?
    var travelRadiusMiles: Int32?
    var preferredPlayStyle: String?
}

struct OwnerProfilePrivacyRow: Equatable, Sendable {
    var profileId: UUID
    var profileVisibility: String
    var discoverable: Bool
    var locationPrecision: String
}

enum OwnerEditableProfileMapper {
    static func ownerEditableProfile(
        profile: OwnerEditableProfileRow?,
        sports: [OwnerProfileSportRow],
        availability: OwnerProfileAvailabilityRow?,
        privacy: OwnerProfilePrivacyRow?
    ) throws -> OwnerEditableProfile {
        guard let profile else {
            throw ProfileRepositoryError.profileMissing
        }

        guard let displayName = normalizedDisplayName(profile.displayName),
              let completionState = ProfileCompletionState(rawValue: profile.profileCompletionState),
              let accountStatus = ProfileAccountStatus(rawValue: profile.accountStatus),
              let createdAt = parseDate(profile.createdAt)
        else {
            throw ProfileRepositoryError.mappingFailed
        }

        let lastActiveAt = try optionalDate(profile.lastActiveAt)
        let sportValues = try mapSports(sports, profileID: profile.id)
        let availabilityValues = try mapAvailability(availability, profileID: profile.id)
        let privacyValues = try mapPrivacy(privacy, profileID: profile.id)

        return OwnerEditableProfile(
            id: profile.id.uuidString,
            displayName: displayName,
            username: profile.username,
            profilePhotoPath: profile.profilePhotoPath,
            actionPhotoPath: profile.actionPhotoPath,
            bio: profile.bio,
            sports: sportValues.sports,
            primarySport: sportValues.primarySport,
            skillLevelBySport: sportValues.skillLevelBySport,
            preferredDays: availabilityValues.preferredDays,
            preferredTimeWindows: availabilityValues.preferredTimeWindows,
            playIntent: availabilityValues.playIntent,
            homeArea: availabilityValues.homeArea,
            travelRadiusMiles: availabilityValues.travelRadiusMiles,
            preferredPlayStyle: availabilityValues.preferredPlayStyle,
            profileVisibility: privacyValues.profileVisibility,
            isDiscoverable: privacyValues.isDiscoverable,
            locationPrecision: privacyValues.locationPrecision,
            completionState: completionState,
            accountStatus: accountStatus,
            createdAt: createdAt,
            lastActiveAt: lastActiveAt
        )
    }

    private static func normalizedDisplayName(_ displayName: String?) -> String? {
        guard let displayName else { return nil }
        let trimmed = displayName.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }

    private static func mapSports(
        _ sports: [OwnerProfileSportRow],
        profileID: UUID
    ) throws -> (sports: [String], primarySport: String?, skillLevelBySport: [String: Int]) {
        var sportSlugs: [String] = []
        var primarySport: String?
        var skillLevelBySport: [String: Int] = [:]

        for sport in sports {
            guard sport.profileId == profileID else {
                throw ProfileRepositoryError.mappingFailed
            }

            sportSlugs.append(sport.sportSlug)

            if sport.isPrimary {
                guard primarySport == nil else {
                    throw ProfileRepositoryError.mappingFailed
                }
                primarySport = sport.sportSlug
            }

            if let skillLevel = sport.skillLevel {
                guard let intSkill = sportSkillLevel(from: skillLevel) else {
                    throw ProfileRepositoryError.mappingFailed
                }
                skillLevelBySport[sport.sportSlug] = intSkill
            }
        }

        return (sportSlugs, primarySport, skillLevelBySport)
    }

    private static func sportSkillLevel(from rawValue: String) -> Int? {
        let trimmedSkill = rawValue.trimmingCharacters(in: .whitespacesAndNewlines)

        if let intSkill = Int(trimmedSkill) {
            return intSkill
        }

        let prefix = "level_"
        guard trimmedSkill.hasPrefix(prefix) else { return nil }

        return Int(trimmedSkill.dropFirst(prefix.count))
    }

    private static func mapAvailability(
        _ availability: OwnerProfileAvailabilityRow?,
        profileID: UUID
    ) throws -> (
        preferredDays: [ProfileWeekday],
        preferredTimeWindows: [ProfileTimeWindow],
        playIntent: ProfilePlayIntent?,
        homeArea: String?,
        travelRadiusMiles: Int?,
        preferredPlayStyle: PreferredProfilePlayStyle?
    ) {
        guard let availability else {
            return ([], [], nil, nil, nil, nil)
        }

        guard availability.profileId == profileID else {
            throw ProfileRepositoryError.mappingFailed
        }

        let preferredDays = try availability.preferredDays.map { rawValue in
            guard let day = ProfileWeekday(rawValue: rawValue) else {
                throw ProfileRepositoryError.mappingFailed
            }
            return day
        }
        let preferredTimeWindows = try availability.preferredTimes.map { rawValue in
            guard let timeWindow = ProfileTimeWindow(rawValue: rawValue) else {
                throw ProfileRepositoryError.mappingFailed
            }
            return timeWindow
        }
        let playIntent = try availability.playIntent.map { rawValue in
            guard let intent = ProfilePlayIntent(rawValue: rawValue) else {
                throw ProfileRepositoryError.mappingFailed
            }
            return intent
        }
        let preferredPlayStyle = try availability.preferredPlayStyle.map { rawValue in
            guard let playStyle = PreferredProfilePlayStyle(rawValue: rawValue) else {
                throw ProfileRepositoryError.mappingFailed
            }
            return playStyle
        }
        let travelRadiusMiles = availability.travelRadiusMiles.map(Int.init)

        if let travelRadiusMiles, !(1...100).contains(travelRadiusMiles) {
            throw ProfileRepositoryError.mappingFailed
        }

        return (
            preferredDays,
            preferredTimeWindows,
            playIntent,
            availability.homeArea,
            travelRadiusMiles,
            preferredPlayStyle
        )
    }

    private static func mapPrivacy(
        _ privacy: OwnerProfilePrivacyRow?,
        profileID: UUID
    ) throws -> (
        profileVisibility: ProfileVisibility,
        isDiscoverable: Bool,
        locationPrecision: ProfileLocationPrecision
    ) {
        guard let privacy else {
            return (.privateProfile, false, .coarse)
        }

        guard privacy.profileId == profileID,
              let visibility = ProfileVisibility(rawValue: privacy.profileVisibility),
              let locationPrecision = ProfileLocationPrecision(rawValue: privacy.locationPrecision)
        else {
            throw ProfileRepositoryError.mappingFailed
        }

        return (visibility, privacy.discoverable, locationPrecision)
    }

    private static func optionalDate(_ rawValue: String?) throws -> Date? {
        guard let rawValue else { return nil }
        guard let date = parseDate(rawValue) else {
            throw ProfileRepositoryError.mappingFailed
        }
        return date
    }

    private static func parseDate(_ rawValue: String) -> Date? {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: rawValue) {
            return date
        }

        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.date(from: rawValue)
    }
}
