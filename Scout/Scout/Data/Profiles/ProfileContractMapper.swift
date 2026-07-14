//
//  ProfileContractMapper.swift
//  Scout
//

import Foundation

struct ProfileOwnerRow: Equatable, Sendable {
    let accountStatus: String
    let actionPhotoPath: String?
    let bio: String?
    let displayName: String?
    let id: UUID
    let lastActiveAt: String?
    let profileCompletionState: String
    let profilePhotoPath: String?
    let userId: UUID
    let username: String?
}

struct ProfileSportRow: Equatable, Sendable {
    let profileId: UUID
    let sportSlug: String
    let skillLevel: String?
    let isPrimary: Bool
}

struct ProfileAvailabilityRow: Equatable, Sendable {
    let preferredDays: [String]
    let preferredTimes: [String]
    let playIntent: String?
    let homeArea: String?
    let travelRadiusMiles: Int32?
    let preferredPlayStyle: String?
}

struct ProfilePrivacyRow: Equatable, Sendable {
    let profileVisibility: String
    let discoverable: Bool
    let locationPrecision: String
}

struct ProfilePublicSummaryRow: Equatable, Sendable {
    let bio: String?
    let displayName: String?
    let profileId: UUID?
    let profilePhotoPath: String?
    let username: String?
}

struct ProfileSportSummaryRow: Equatable, Sendable {
    let isPrimary: Bool?
    let profileId: UUID?
    let skillLevel: String?
    let sportSlug: String?
}

enum ProfileContractMapper {
    static func ownerProfile(
        profile: ProfileOwnerRow,
        sports: [ProfileSportRow],
        availability: ProfileAvailabilityRow?,
        privacy: ProfilePrivacyRow?
    ) -> OwnerProfile {
        OwnerProfile(
            id: profile.id,
            userID: profile.userId,
            displayName: profile.displayName,
            username: profile.username,
            profilePhotoPath: profile.profilePhotoPath,
            actionPhotoPath: profile.actionPhotoPath,
            bio: profile.bio,
            readinessState: ProfileReadinessState(databaseValue: profile.profileCompletionState),
            accountStatus: ProfileAccountStatus(databaseValue: profile.accountStatus),
            sports: sports.map(toSportContext),
            availability: availability.map(toAvailabilityContext),
            privacy: privacy.map(toPrivacySettings)
        )
    }

    static func publicProfile(
        summary: ProfilePublicSummaryRow,
        sports: [ProfileSportSummaryRow]
    ) -> PublicProfile? {
        guard let profileID = summary.profileId else { return nil }

        return PublicProfile(
            id: profileID,
            displayName: summary.displayName,
            username: summary.username,
            profilePhotoPath: summary.profilePhotoPath,
            bio: summary.bio,
            sports: sports.compactMap(toSportContext)
        )
    }

    static func discoverySummary(
        summary: ProfilePublicSummaryRow,
        sports: [ProfileSportSummaryRow]
    ) -> DiscoveryProfileSummary? {
        guard let profileID = summary.profileId else { return nil }

        return DiscoveryProfileSummary(
            id: profileID,
            displayName: summary.displayName,
            profilePhotoPath: summary.profilePhotoPath,
            primarySport: sports.compactMap(toSportContext).first { $0.isPrimary }
        )
    }

    static func eventSummary(
        summary: ProfilePublicSummaryRow,
        sports: [ProfileSportSummaryRow],
        sportSlug: String? = nil
    ) -> EventProfileSummary? {
        guard let profileID = summary.profileId else { return nil }

        let sportContexts = sports.compactMap(toSportContext)
        let eventSport = sportSlug
            .flatMap { targetSport in sportContexts.first { $0.sportSlug == targetSport } }
            ?? sportContexts.first { $0.isPrimary }
            ?? sportContexts.first

        return EventProfileSummary(
            id: profileID,
            displayName: summary.displayName,
            profilePhotoPath: summary.profilePhotoPath,
            sport: eventSport
        )
    }

    static func chatSummary(summary: ProfilePublicSummaryRow) -> ChatProfileSummary? {
        guard let profileID = summary.profileId else { return nil }

        return ChatProfileSummary(
            id: profileID,
            displayName: summary.displayName,
            profilePhotoPath: summary.profilePhotoPath
        )
    }

    private static func toSportContext(_ row: ProfileSportRow) -> ProfileSportContext {
        ProfileSportContext(
            sportSlug: row.sportSlug,
            skillLevel: row.skillLevel,
            isPrimary: row.isPrimary
        )
    }

    private static func toSportContext(_ row: ProfileSportSummaryRow) -> ProfileSportContext? {
        guard let sportSlug = row.sportSlug else { return nil }

        return ProfileSportContext(
            sportSlug: sportSlug,
            skillLevel: row.skillLevel,
            isPrimary: row.isPrimary ?? false
        )
    }

    private static func toAvailabilityContext(_ row: ProfileAvailabilityRow) -> ProfileAvailabilityContext {
        ProfileAvailabilityContext(
            preferredDays: row.preferredDays,
            preferredTimes: row.preferredTimes,
            playIntent: row.playIntent,
            homeArea: row.homeArea,
            travelRadiusMiles: row.travelRadiusMiles.map { Int($0) },
            preferredPlayStyle: row.preferredPlayStyle
        )
    }

    private static func toPrivacySettings(_ row: ProfilePrivacyRow) -> ProfilePrivacySettings {
        ProfilePrivacySettings(
            profileVisibility: row.profileVisibility,
            discoverable: row.discoverable,
            locationPrecision: row.locationPrecision
        )
    }
}
