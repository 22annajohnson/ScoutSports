//
//  ProfileProviding.swift
//  Scout
//
//  Created by Anna on 2/26/26.
//

import Foundation

/// Editable profile repository boundary.
/// Keep user-owned profile writes here; future feedback and derived metrics should use separate seams.
protocol ProfileProviding {
    func fetchMyProfile() async throws -> Profile
    func fetchCurrentUserPublicProfile() async throws -> PlayerPublicProfile
    func updateDisplayName(_ newName: String) async throws
    func setCurrentUserSinglePhoto(type: ProfilePhotoType, path: String, blurhash: String?) async throws
    func addCurrentUserGalleryPhoto(id: UUID, path: String, position: Int16, isPrimary: Bool, blurhash: String?) async throws
    func updateCurrentUserProfile(_ input: PlayerPublicProfileUpdateInput) async throws
    func markProfileCompletedIfReady() async throws
}

/// Future boundary for player-to-player feedback submitted after a match or session.
/// Raw feedback should remain separate from editable profile state.
protocol MatchFeedbackProviding {
    func submitCurrentUserMatchFeedback(_ input: MatchPlayerFeedbackInput) async throws
    func fetchFeedbackReceived(for reviewedUserID: UUID) async throws -> [MatchPlayerFeedback]
}

/// Boundary for self-reported inputs used by matching and ranking.
/// These are editable by the player, but should remain separate from public profile fields.
protocol PlayerMatchSignalsProviding {
    func updateCurrentUserMatchSignals(_ input: PlayerMatchSignalsUpdateInput) async throws
}

/// Boundary for profile relationships that should not be flattened into the main editable profile row.
/// Clubs are the first v1 relationship here; courts can move behind a similar seam once lookup exists.
protocol PlayerProfileRelationshipsProviding {
    func replaceCurrentUserClubMemberships(with clubNames: [String]) async throws
}

/// Future boundary for system-owned aggregates derived from feedback and behavior.
/// Swipe ordering and matching should consume these values without storing them in `profiles`.
protocol PlayerMetricsProviding {
    func fetchDerivedMetrics(for userID: UUID) async throws -> PlayerDerivedMetrics
}
