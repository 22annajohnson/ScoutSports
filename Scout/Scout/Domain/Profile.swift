//
//  Profile.swift
//  Scout
//
//  Created by Anna on 2/26/26.
//

import Foundation

/// Lightweight identity/profile record used by the current app shell.
/// Keep user-owned profile data separate from ranking signals and derived reputation metrics.
struct Profile: Identifiable, Equatable {
    let id: String
    var displayName: String
}

/// User-facing profile data that the player owns and edits directly.
/// This is the boundary for profile builder and public profile presentation.
struct PlayerPublicProfile: Identifiable, Equatable, Sendable {
    let id: String
    var displayName: String?
    var birthdate: Date?
    var primarySport: String?
    var bio: String?
    var homeCourtName: String?
    var clubNames: [String]
    var skillLevel: Int?
    var playStyle: String?
}

/// Owner-facing v1 profile state for repository-backed Profile ViewModels.
/// System-owned lifecycle fields are read-only here and intentionally absent from owner update commands.
struct OwnerEditableProfile: Identifiable, Equatable, Sendable {
    let id: String
    var displayName: String
    var username: String?
    var profilePhotoPath: String?
    var actionPhotoPath: String?
    var bio: String?
    var sports: [String]
    var primarySport: String?
    var skillLevelBySport: [String: Int]
    var preferredDays: [ProfileWeekday]
    var preferredTimeWindows: [ProfileTimeWindow]
    var playIntent: ProfilePlayIntent?
    var homeArea: String?
    var travelRadiusMiles: Int?
    var preferredPlayStyle: PreferredProfilePlayStyle?
    var profileVisibility: ProfileVisibility
    var isDiscoverable: Bool
    var locationPrecision: ProfileLocationPrecision
    let completionState: ProfileCompletionState
    let accountStatus: ProfileAccountStatus
    let createdAt: Date
    let lastActiveAt: Date?
}

enum ProfileWeekday: String, CaseIterable, Codable, Equatable, Sendable {
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday
}

enum ProfileTimeWindow: String, CaseIterable, Codable, Equatable, Sendable {
    case morning
    case afternoon
    case evening
}

enum ProfilePlayIntent: String, CaseIterable, Codable, Equatable, Sendable {
    case casual
    case competitive
    case flexible
}

enum PreferredProfilePlayStyle: String, CaseIterable, Codable, Equatable, Sendable {
    case singles
    case doubles
    case mixed
    case open
}

enum ProfileVisibility: String, CaseIterable, Codable, Equatable, Sendable {
    case publicProfile
    case matchedOnly
    case privateProfile
}

enum ProfileLocationPrecision: String, CaseIterable, Codable, Equatable, Sendable {
    case hidden
    case coarse
}

enum ProfileCompletionState: String, CaseIterable, Codable, Equatable, Sendable {
    case accountCreated
    case basicIdentity
    case discoveryReady
    case eventReady
    case fullyComplete
}

enum ProfileAccountStatus: String, CaseIterable, Codable, Equatable, Sendable {
    case active
    case restricted
    case disabled
    case deleted
}

enum ProfileUpdateValidationError: Equatable, Sendable {
    case displayNameLength
    case usernameFormat
    case primarySportNotSelected
    case primarySportSkillMissing
    case negativeTravelRadius
}

struct ProfileIdentityUpdateCommand: Equatable, Sendable {
    var displayName: String?
    var username: String?
    var bio: String?

    func validationErrors() -> [ProfileUpdateValidationError] {
        var errors: [ProfileUpdateValidationError] = []

        if let displayName {
            let trimmedName = displayName.trimmingCharacters(in: .whitespacesAndNewlines)
            if !(2...40).contains(trimmedName.count) {
                errors.append(.displayNameLength)
            }
        }

        if let username, !username.isEmpty {
            let allowed = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyz0123456789_")
            let usesAllowedCharacters = username.unicodeScalars.allSatisfy { allowed.contains($0) }
            if !(3...24).contains(username.count) || !usesAllowedCharacters || username != username.lowercased() {
                errors.append(.usernameFormat)
            }
        }

        return errors
    }
}

struct ProfileSportsUpdateCommand: Equatable, Sendable {
    var sports: [String]
    var primarySport: String?
    var skillLevelBySport: [String: Int]

    func validationErrors() -> [ProfileUpdateValidationError] {
        var errors: [ProfileUpdateValidationError] = []

        if let primarySport {
            if !sports.contains(primarySport) {
                errors.append(.primarySportNotSelected)
            }

            if skillLevelBySport[primarySport] == nil {
                errors.append(.primarySportSkillMissing)
            }
        }

        return errors
    }
}

struct ProfileAvailabilityUpdateCommand: Equatable, Sendable {
    var preferredDays: [ProfileWeekday]
    var preferredTimeWindows: [ProfileTimeWindow]
    var playIntent: ProfilePlayIntent?
    var homeArea: String?
    var travelRadiusMiles: Int?
    var preferredPlayStyle: PreferredProfilePlayStyle?

    func validationErrors() -> [ProfileUpdateValidationError] {
        if let travelRadiusMiles, travelRadiusMiles < 0 {
            return [.negativeTravelRadius]
        }

        return []
    }
}

struct ProfilePrivacyUpdateCommand: Equatable, Sendable {
    var profileVisibility: ProfileVisibility
    var isDiscoverable: Bool
    var locationPrecision: ProfileLocationPrecision
}

/// Editable payload for the user-owned profile layer.
/// This should mirror fields the player can set directly, not system-computed metrics.
struct PlayerPublicProfileUpdateInput: Equatable, Sendable {
    var displayName: String? = nil
    var birthdate: Date? = nil
    var primarySport: String? = nil
    var bio: String? = nil
    var homeCourtID: UUID? = nil
    var homeCourtName: String? = nil
    var backgroundLevel: ProfileBackgroundLevel? = nil
    var yearsPlaying: Int16? = nil
    var skillLevel: Int16? = nil
    var playStyle: ProfilePlayStyle? = nil
    var shouldClearHomeCourtID: Bool = false
    var shouldClearHomeCourtName: Bool = false
}

/// Structured inputs that help matching and ranking, but are still self-reported by the player.
/// These should not be mixed with system-derived metrics in the editable profile payload.
struct PlayerMatchSignals: Identifiable, Equatable, Sendable {
    let id: String
    var competitivenessRating: Int?
    var friendlinessRating: Int?
    var socialVibeRating: Int?
    var preferredMatchIntensity: String?
    var preferredFormats: [String]
    var travelRadiusMiles: Int?
    var availabilitySummary: String?
}

/// Editable payload for self-reported matching inputs.
/// These values are user-entered, but they are not the same as system-derived metrics.
struct PlayerMatchSignalsUpdateInput: Equatable, Sendable {
    var competitivenessRating: Int? = nil
    var friendlinessRating: Int? = nil
    var socialVibeRating: Int? = nil
    var preferredMatchIntensity: String? = nil
}

/// System-owned outputs computed from feedback, interactions, and match history.
/// Users should never edit these values directly from the profile builder.
struct PlayerDerivedMetrics: Identifiable, Equatable, Sendable {
    let id: String
    var friendlinessScore: Double?
    var competitivenessScore: Double?
    var vibesScore: Double?
    var reliabilityScore: Double?
    var skillConfidence: Double?
    var repeatPlayRate: Double?
}

/// Public-safe aggregate metrics for display surfaces like swipe cards.
/// This intentionally excludes raw feedback rows and any private notes.
struct PlayerPublicMetricSummary: Identifiable, Sendable {
    let id: String
    var totalReviews: Int
    var stats: [StatsViewModel]
}

extension PlayerDerivedMetrics {
    func toStatsViewModels(totalReviews: Int) -> [StatsViewModel] {
        [
            makeStatViewModel(for: .vibe, score: vibesScore, totalReviews: totalReviews),
            makeStatViewModel(for: .intensity, score: competitivenessScore, totalReviews: totalReviews),
            makeStatViewModel(for: .consistency, score: reliabilityScore, totalReviews: totalReviews),
            makeStatViewModel(for: .skill, score: skillConfidence, totalReviews: totalReviews),
        ]
    }

    private func makeStatViewModel(for statType: StatType, score: Double?, totalReviews: Int) -> StatsViewModel {
        StatsViewModel(
            statType: statType,
            rating: roundedStarRating(from: score),
            totalReviews: totalReviews,
            reviews: []
        )
    }

    private func roundedStarRating(from score: Double?) -> Int {
        guard let score else { return 0 }
        return min(max(Int(score.rounded()), 0), 5)
    }

    func toPublicSummary(totalReviews: Int) -> PlayerPublicMetricSummary {
        PlayerPublicMetricSummary(
            id: id,
            totalReviews: totalReviews,
            stats: toStatsViewModels(totalReviews: totalReviews)
        )
    }
}

/// Raw post-match feedback submitted by one player about another player.
/// This is append-only interaction data and should remain separate from editable profile state.
struct MatchPlayerFeedback: Identifiable, Equatable, Sendable {
    let id: UUID
    let matchID: UUID
    let reviewerUserID: UUID
    let reviewedUserID: UUID
    var skillRating: Int?
    var competitivenessRating: Int?
    var friendlinessRating: Int?
    var vibesRating: Int?
    var communicationRating: Int?
    var reliabilityRating: Int?
    var wouldPlayAgain: Bool?
    var privateNote: String?
    let createdAt: Date
}

/// Write payload for raw post-match feedback rows.
struct MatchPlayerFeedbackInput: Equatable, Sendable {
    var matchID: UUID
    var reviewedUserID: UUID
    var skillRating: Int? = nil
    var competitivenessRating: Int? = nil
    var friendlinessRating: Int? = nil
    var vibesRating: Int? = nil
    var communicationRating: Int? = nil
    var reliabilityRating: Int? = nil
    var wouldPlayAgain: Bool? = nil
    var privateNote: String? = nil
}
