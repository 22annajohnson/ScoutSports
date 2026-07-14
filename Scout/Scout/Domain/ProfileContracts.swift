//
//  ProfileContracts.swift
//  Scout
//

import Foundation

enum ProfileReadinessState: Equatable, Sendable {
    case accountCreated
    case basicIdentity
    case discoveryReady
    case eventReady
    case fullyComplete
    case unknown(String)

    init(databaseValue: String) {
        switch databaseValue {
        case "account_created":
            self = .accountCreated
        case "basic_identity":
            self = .basicIdentity
        case "discovery_ready":
            self = .discoveryReady
        case "event_ready":
            self = .eventReady
        case "fully_complete":
            self = .fullyComplete
        default:
            self = .unknown(databaseValue)
        }
    }
}

struct ProfileSportContext: Equatable, Sendable {
    let sportSlug: String
    let skillLevel: String?
    let isPrimary: Bool
}

struct ProfileAvailabilityContext: Equatable, Sendable {
    let preferredDays: [String]
    let preferredTimes: [String]
    let playIntent: String?
    let homeArea: String?
    let travelRadiusMiles: Int?
    let preferredPlayStyle: String?
}

struct ProfilePrivacySettings: Equatable, Sendable {
    let profileVisibility: String
    let discoverable: Bool
    let locationPrecision: String
}

struct OwnerProfile: Identifiable, Equatable, Sendable {
    let id: UUID
    let userID: UUID
    let displayName: String?
    let username: String?
    let profilePhotoPath: String?
    let actionPhotoPath: String?
    let bio: String?
    let readinessState: ProfileReadinessState
    let accountStatus: ProfileAccountStatus
    let sports: [ProfileSportContext]
    let availability: ProfileAvailabilityContext?
    let privacy: ProfilePrivacySettings?
}

struct PublicProfile: Identifiable, Equatable, Sendable {
    let id: UUID
    let displayName: String?
    let username: String?
    let profilePhotoPath: String?
    let bio: String?
    let sports: [ProfileSportContext]
}

struct DiscoveryProfileSummary: Identifiable, Equatable, Sendable {
    let id: UUID
    let displayName: String?
    let profilePhotoPath: String?
    let primarySport: ProfileSportContext?
}

struct EventProfileSummary: Identifiable, Equatable, Sendable {
    let id: UUID
    let displayName: String?
    let profilePhotoPath: String?
    let sport: ProfileSportContext?
}

struct ChatProfileSummary: Identifiable, Equatable, Sendable {
    let id: UUID
    let displayName: String?
    let profilePhotoPath: String?
}
