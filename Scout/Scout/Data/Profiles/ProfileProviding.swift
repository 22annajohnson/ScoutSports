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
protocol MatchFeedbackProviding { }

/// Future boundary for system-owned aggregates derived from feedback and behavior.
/// Swipe ordering and matching should consume these values without storing them in `profiles`.
protocol PlayerMetricsProviding { }
