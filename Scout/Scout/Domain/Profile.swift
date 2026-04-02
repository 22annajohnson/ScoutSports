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
