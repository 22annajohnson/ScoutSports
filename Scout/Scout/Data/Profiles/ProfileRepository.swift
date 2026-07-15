//
//  ProfileRepository.swift
//  Scout
//
//  Created by Anna on 2/26/26.
//

import Foundation
import Supabase


enum DataError: Error {
    case notAuthenticated
    case unauthorizedFeedbackAccess
}

// MARK: - Profile Photos (DB rows)

enum ProfilePhotoType: String, Codable, CaseIterable {
    case action
    case headshot
    case gallery
}

struct ProfilePhotoRow: Decodable, Equatable {
    let id: UUID
    let userID: UUID
    let type: ProfilePhotoType
    let path: String
    let position: Int16
    let isPrimary: Bool
    let blurhash: String?
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case type
        case path
        case position
        case isPrimary = "is_primary"
        case blurhash
        case createdAt = "created_at"
    }
}

struct ProfileClubRow: Decodable, Equatable {
    let clubName: String

    enum CodingKeys: String, CodingKey {
        case clubName = "club_name"
    }
}

struct MatchPlayerFeedbackRow: Decodable, Equatable {
    let id: UUID
    let matchID: UUID
    let reviewerUserID: UUID
    let reviewedUserID: UUID
    let skillRating: Int?
    let competitivenessRating: Int?
    let friendlinessRating: Int?
    let vibesRating: Int?
    let communicationRating: Int?
    let reliabilityRating: Int?
    let wouldPlayAgain: Bool?
    let privateNote: String?
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case matchID = "match_id"
        case reviewerUserID = "reviewer_user_id"
        case reviewedUserID = "reviewed_user_id"
        case skillRating = "skill_rating"
        case competitivenessRating = "competitiveness_rating"
        case friendlinessRating = "friendliness_rating"
        case vibesRating = "vibes_rating"
        case communicationRating = "communication_rating"
        case reliabilityRating = "reliability_rating"
        case wouldPlayAgain = "would_play_again"
        case privateNote = "private_note"
        case createdAt = "created_at"
    }

    func toDomain() -> MatchPlayerFeedback {
        MatchPlayerFeedback(
            id: id,
            matchID: matchID,
            reviewerUserID: reviewerUserID,
            reviewedUserID: reviewedUserID,
            skillRating: skillRating,
            competitivenessRating: competitivenessRating,
            friendlinessRating: friendlinessRating,
            vibesRating: vibesRating,
            communicationRating: communicationRating,
            reliabilityRating: reliabilityRating,
            wouldPlayAgain: wouldPlayAgain,
            privateNote: privateNote,
            createdAt: createdAt
        )
    }
}

// MARK: - Profile Builder fields

enum ProfileBackgroundLevel: String, Codable, CaseIterable, Sendable {
    case beginner
    case club
    case high_school
    case college
    case professional
}

enum ProfilePlayStyle: String, Codable, CaseIterable, Sendable {
    case casual
    case competitive
    case drills
    case doubles
    case singles
}

final class ProfileRepository: ProfileProviding, OwnerEditableProfileProviding, PublicProfileProviding, PlayerMatchSignalsProviding, PlayerProfileRelationshipsProviding, MatchFeedbackProviding, InternalMatchFeedbackProviding, PlayerMetricsProviding {
    private let supabase: SupabaseClient
    private var cachedOwnerEditableProfile: OwnerEditableProfile?

    init(supabase: SupabaseClient) {
        self.supabase = supabase
    }

    func fetchMyProfile() async throws -> Profile {
        guard let user = supabase.auth.currentUser else { throw DataError.notAuthenticated }

        let dto: ProfileDTO = try await supabase
            .from("profiles")
            .select("id, display_name")
            .eq("id", value: user.id)
            .single()
            .execute()
            .value

        return dto.toDomain()
    }

    func fetchCurrentUserPublicProfile() async throws -> PlayerPublicProfile {
        guard let user = supabase.auth.currentUser else { throw DataError.notAuthenticated }

        let dto: PlayerPublicProfileDTO = try await supabase
            .from("profiles")
            .select("id, display_name, birthdate, primary_sport, bio, home_court_name, background_level, years_playing, skill_level, play_style")
            .eq("id", value: user.id)
            .single()
            .execute()
            .value

        let clubRows: [ProfileClubRow] = try await supabase
            .from("profile_clubs")
            .select("club_name")
            .eq("user_id", value: user.id)
            .order("club_name", ascending: true)
            .execute()
            .value

        let clubNames = clubRows.map(\.clubName)

        return dto.toDomain(clubNames: clubNames)
    }

    func updateDisplayName(_ newName: String) async throws {
        guard let user = supabase.auth.currentUser else { throw DataError.notAuthenticated }

        struct Patch: Encodable {
            let displayName: String
            enum CodingKeys: String, CodingKey {
                case displayName = "display_name"
            }
        }

        _ = try await supabase
            .from("profiles")
            .update(Patch(displayName: newName))
            .eq("id", value: user.id)
            .execute()
    }

    // MARK: - Profile Photos

    /// Fetches all photos for the current user.
    func fetchCurrentUserPhotos() async throws -> [ProfilePhotoRow] {
        guard let user = supabase.auth.currentUser else { throw DataError.notAuthenticated }

        let rows: [ProfilePhotoRow] = try await supabase
            .from("profile_photos")
            .select("id, user_id, type, path, position, is_primary, blurhash, created_at")
            .eq("user_id", value: user.id)
            .order("type", ascending: true)
            .order("position", ascending: true)
            .execute()
            .value

        return rows
    }

    /// For action/headshot we keep only one row per user.
    /// Implementation: delete existing row(s) for that type, then insert a new row.
    func setCurrentUserSinglePhoto(type: ProfilePhotoType, path: String, blurhash: String? = nil) async throws {
        guard let user = supabase.auth.currentUser else { throw DataError.notAuthenticated }

        // Delete any existing rows for this type
        _ = try await supabase
            .from("profile_photos")
            .delete()
            .eq("user_id", value: user.id)
            .eq("type", value: type.rawValue)
            .execute()

        struct PhotoInsert: Encodable {
            let userID: UUID
            let type: String
            let path: String
            let position: Int16
            let isPrimary: Bool
            let blurhash: String?

            enum CodingKeys: String, CodingKey {
                case userID = "user_id"
                case type
                case path
                case position
                case isPrimary = "is_primary"
                case blurhash
            }
        }

        let insert = PhotoInsert(
            userID: user.id,
            type: type.rawValue,
            path: path,
            position: 0,
            isPrimary: true,
            blurhash: blurhash
        )

        _ = try await supabase
            .from("profile_photos")
            .insert(insert)
            .execute()
    }

    /// Inserts a gallery photo row. (Storage upload happens separately.)
    func addCurrentUserGalleryPhoto(id: UUID, path: String, position: Int16, isPrimary: Bool = false, blurhash: String? = nil) async throws {
        guard let user = supabase.auth.currentUser else { throw DataError.notAuthenticated }

        struct GalleryPhotoInsert: Encodable {
            let id: UUID
            let userID: UUID
            let type: String
            let path: String
            let position: Int16
            let isPrimary: Bool
            let blurhash: String?

            enum CodingKeys: String, CodingKey {
                case id
                case userID = "user_id"
                case type
                case path
                case position
                case isPrimary = "is_primary"
                case blurhash
            }
        }

        let insert = GalleryPhotoInsert(
            id: id,
            userID: user.id,
            type: ProfilePhotoType.gallery.rawValue,
            path: path,
            position: position,
            isPrimary: isPrimary,
            blurhash: blurhash
        )

        _ = try await supabase
            .from("profile_photos")
            .insert(insert)
            .execute()
    }

    /// Deletes a photo row by id (does not delete from Storage).
    func deleteCurrentUserPhotoRow(id: UUID) async throws {
        guard let user = supabase.auth.currentUser else { throw DataError.notAuthenticated }

        _ = try await supabase
            .from("profile_photos")
            .delete()
            .eq("user_id", value: user.id)
            .eq("id", value: id)
            .execute()
    }

    // MARK: - Profile Builder updates

    /// Updates the current user's profile fields. Only non-nil fields are written.
    func updateCurrentUserProfile(_ input: PlayerPublicProfileUpdateInput) async throws {
        guard let user = supabase.auth.currentUser else { throw DataError.notAuthenticated }

        struct ProfileUpdatePatch: Encodable {
            var displayName: String?
            var birthdate: String?
            var primarySport: String?
            var bio: String?
            var homeCourtID: UUID??
            var homeCourtName: String??
            var backgroundLevel: String?
            var yearsPlaying: Int16?
            var skillLevel: Int16?
            var playStyle: String?

            enum CodingKeys: String, CodingKey {
                case displayName = "display_name"
                case birthdate
                case primarySport = "primary_sport"
                case bio
                case homeCourtID = "home_court_id"
                case homeCourtName = "home_court_name"
                case backgroundLevel = "background_level"
                case yearsPlaying = "years_playing"
                case skillLevel = "skill_level"
                case playStyle = "play_style"
            }
        }

        var patch = ProfileUpdatePatch()

        let birthdateFormatter: DateFormatter = {
            let df = DateFormatter()
            df.calendar = Calendar(identifier: .gregorian)
            df.locale = Locale(identifier: "en_US_POSIX")
            df.timeZone = TimeZone(secondsFromGMT: 0)
            df.dateFormat = "yyyy-MM-dd"
            return df
        }()

        if let displayName = input.displayName {
            patch.displayName = displayName
        }
        if let birthdate = input.birthdate {
            patch.birthdate = birthdateFormatter.string(from: birthdate)
        }
        if let primarySport = input.primarySport {
            patch.primarySport = primarySport
        }
        if let bio = input.bio {
            patch.bio = bio
        }
        if input.shouldClearHomeCourtID {
            patch.homeCourtID = .some(nil)
        } else if let homeCourtID = input.homeCourtID {
            patch.homeCourtID = .some(homeCourtID)
        }
        if input.shouldClearHomeCourtName {
            patch.homeCourtName = .some(nil)
        } else if let homeCourtName = input.homeCourtName {
            patch.homeCourtName = .some(homeCourtName)
        }
        if let backgroundLevel = input.backgroundLevel {
            patch.backgroundLevel = backgroundLevel.rawValue
        }
        if let yearsPlaying = input.yearsPlaying {
            patch.yearsPlaying = yearsPlaying
        }
        if let skillLevel = input.skillLevel {
            patch.skillLevel = skillLevel
        }
        if let playStyle = input.playStyle {
            patch.playStyle = playStyle.rawValue
        }

        // If nothing was set, do nothing.
        let isEmpty = patch.displayName == nil
            && patch.birthdate == nil
            && patch.primarySport == nil
            && patch.bio == nil
            && patch.homeCourtID == nil
            && patch.homeCourtName == nil
            && patch.backgroundLevel == nil
            && patch.yearsPlaying == nil
            && patch.skillLevel == nil
            && patch.playStyle == nil

        guard !isEmpty else { return }

        _ = try await supabase
            .from("profiles")
            .update(patch)
            .eq("id", value: user.id)
            .execute()
    }

    // MARK: - Owner editable profile

    func currentEditableProfile(forceRefresh: Bool) async throws -> OwnerEditableProfile {
        guard let user = supabase.auth.currentUser else { throw ProfileRepositoryError.notAuthenticated }

        if !forceRefresh, let cachedOwnerEditableProfile {
            return cachedOwnerEditableProfile
        }

        return try await performOwnerProfileOperation {
            try await loadOwnerEditableProfile(for: user.id)
        }
    }

    func updateIdentity(_ command: ProfileIdentityUpdateCommand) async throws -> OwnerEditableProfile {
        try validate(command.validationErrors())
        guard let user = supabase.auth.currentUser else { throw ProfileRepositoryError.notAuthenticated }

        return try await performOwnerProfileOperation {
            struct IdentityPatch: Encodable {
                var displayName: String?
                var username: String??
                var bio: String??

                enum CodingKeys: String, CodingKey {
                    case displayName = "display_name"
                    case username
                    case bio
                }
            }

            var patch = IdentityPatch()
            if let displayName = command.displayName {
                patch.displayName = displayName.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            if let username = command.username {
                let normalizedUsername = username.trimmingCharacters(in: .whitespacesAndNewlines)
                patch.username = normalizedUsername.isEmpty ? .some(nil) : .some(normalizedUsername)
            }
            if let bio = command.bio {
                let normalizedBio = bio.trimmingCharacters(in: .whitespacesAndNewlines)
                patch.bio = normalizedBio.isEmpty ? .some(nil) : .some(normalizedBio)
            }

            let isEmpty = patch.displayName == nil
                && patch.username == nil
                && patch.bio == nil

            guard !isEmpty else {
                return try await loadOwnerEditableProfile(for: user.id)
            }

            _ = try await supabase
                .from("profiles")
                .update(patch)
                .eq("user_id", value: user.id)
                .execute()

            cachedOwnerEditableProfile = nil
            return try await loadOwnerEditableProfile(for: user.id)
        }
    }

    func updateSports(_ command: ProfileSportsUpdateCommand) async throws -> OwnerEditableProfile {
        try validate(command.validationErrors())
        guard let user = supabase.auth.currentUser else { throw ProfileRepositoryError.notAuthenticated }

        return try await performOwnerProfileOperation {
            let profileID = try await ownerProfileID(for: user.id)

            _ = try await supabase
                .from("profile_sports")
                .delete()
                .eq("profile_id", value: profileID)
                .execute()

            let normalizedSports = Self.uniqueNonEmptyValues(command.sports)
            if !normalizedSports.isEmpty {
                struct SportInsert: Encodable {
                    let profileId: UUID
                    let sportSlug: String
                    let skillLevel: String?
                    let isPrimary: Bool

                    enum CodingKeys: String, CodingKey {
                        case profileId = "profile_id"
                        case sportSlug = "sport_slug"
                        case skillLevel = "skill_level"
                        case isPrimary = "is_primary"
                    }
                }

                let inserts = normalizedSports.map { sportSlug in
                    SportInsert(
                        profileId: profileID,
                        sportSlug: sportSlug,
                        skillLevel: command.skillLevelBySport[sportSlug].map { "level_\($0)" },
                        isPrimary: sportSlug == command.primarySport
                    )
                }

                _ = try await supabase
                    .from("profile_sports")
                    .insert(inserts)
                    .execute()
            }

            cachedOwnerEditableProfile = nil
            return try await loadOwnerEditableProfile(for: user.id)
        }
    }

    func updateAvailability(_ command: ProfileAvailabilityUpdateCommand) async throws -> OwnerEditableProfile {
        try validate(command.validationErrors())
        guard let user = supabase.auth.currentUser else { throw ProfileRepositoryError.notAuthenticated }

        return try await performOwnerProfileOperation {
            let profileID = try await ownerProfileID(for: user.id)

            struct AvailabilityUpsert: Encodable {
                let profileId: UUID
                let preferredDays: [String]
                let preferredTimes: [String]
                let playIntent: String?
                let homeArea: String?
                let travelRadiusMiles: Int32?
                let preferredPlayStyle: String?

                enum CodingKeys: String, CodingKey {
                    case profileId = "profile_id"
                    case preferredDays = "preferred_days"
                    case preferredTimes = "preferred_times"
                    case playIntent = "play_intent"
                    case homeArea = "home_area"
                    case travelRadiusMiles = "travel_radius_miles"
                    case preferredPlayStyle = "preferred_play_style"
                }
            }

            let homeArea = command.homeArea?.trimmingCharacters(in: .whitespacesAndNewlines)
            let upsert = AvailabilityUpsert(
                profileId: profileID,
                preferredDays: command.preferredDays.map(\.rawValue),
                preferredTimes: command.preferredTimeWindows.map(\.rawValue),
                playIntent: command.playIntent?.rawValue,
                homeArea: homeArea?.isEmpty == true ? nil : homeArea,
                travelRadiusMiles: command.travelRadiusMiles.map(Int32.init),
                preferredPlayStyle: command.preferredPlayStyle?.rawValue
            )

            _ = try await supabase
                .from("profile_availability")
                .upsert(upsert, onConflict: "profile_id")
                .execute()

            cachedOwnerEditableProfile = nil
            return try await loadOwnerEditableProfile(for: user.id)
        }
    }

    func updatePrivacy(_ command: ProfilePrivacyUpdateCommand) async throws -> OwnerEditableProfile {
        guard let user = supabase.auth.currentUser else { throw ProfileRepositoryError.notAuthenticated }

        return try await performOwnerProfileOperation {
            let profileID = try await ownerProfileID(for: user.id)

            struct PrivacyUpsert: Encodable {
                let profileId: UUID
                let profileVisibility: String
                let discoverable: Bool
                let locationPrecision: String

                enum CodingKeys: String, CodingKey {
                    case profileId = "profile_id"
                    case profileVisibility = "profile_visibility"
                    case discoverable
                    case locationPrecision = "location_precision"
                }
            }

            let upsert = PrivacyUpsert(
                profileId: profileID,
                profileVisibility: command.profileVisibility.rawValue,
                discoverable: command.isDiscoverable,
                locationPrecision: command.locationPrecision.rawValue
            )

            _ = try await supabase
                .from("profile_privacy")
                .upsert(upsert, onConflict: "profile_id")
                .execute()

            cachedOwnerEditableProfile = nil
            return try await loadOwnerEditableProfile(for: user.id)
        }
    }

    // MARK: - Public profile

    func publicProfile(profileID: UUID) async throws -> PublicProfile {
        let summaries: [ProfilePublicSummaryRow] = try await supabase
            .from("profile_public_summaries")
            .select("profile_id, display_name, username, profile_photo_path, bio")
            .eq("profile_id", value: profileID)
            .limit(1)
            .execute()
            .value

        guard let summary = summaries.first else {
            throw ProfileRepositoryError.profileMissing
        }

        let sports: [ProfileSportSummaryRow] = try await supabase
            .from("profile_sport_summaries")
            .select("profile_id, sport_slug, skill_level, is_primary")
            .eq("profile_id", value: profileID)
            .execute()
            .value

        guard let profile = ProfileContractMapper.publicProfile(summary: summary, sports: sports) else {
            throw ProfileRepositoryError.mappingFailed
        }

        return profile
    }

    func updateCurrentUserMatchSignals(_ input: PlayerMatchSignalsUpdateInput) async throws {
        guard let user = supabase.auth.currentUser else { throw DataError.notAuthenticated }

        struct MatchSignalsPatch: Encodable {
            var competitivenessRating: Int16?
            var friendlinessRating: Int16?
            var socialVibeRating: Int16?
            var preferredMatchIntensity: String?

            enum CodingKeys: String, CodingKey {
                case competitivenessRating = "competitiveness_self_rating"
                case friendlinessRating = "friendliness_self_rating"
                case socialVibeRating = "social_vibe_self_rating"
                case preferredMatchIntensity = "preferred_match_intensity"
            }
        }

        var patch = MatchSignalsPatch()

        if let competitivenessRating = input.competitivenessRating {
            patch.competitivenessRating = Int16(competitivenessRating)
        }
        if let friendlinessRating = input.friendlinessRating {
            patch.friendlinessRating = Int16(friendlinessRating)
        }
        if let socialVibeRating = input.socialVibeRating {
            patch.socialVibeRating = Int16(socialVibeRating)
        }
        if let preferredMatchIntensity = input.preferredMatchIntensity {
            patch.preferredMatchIntensity = preferredMatchIntensity
        }

        let isEmpty = patch.competitivenessRating == nil
            && patch.friendlinessRating == nil
            && patch.socialVibeRating == nil
            && patch.preferredMatchIntensity == nil

        guard !isEmpty else { return }

        _ = try await supabase
            .from("profiles")
            .update(patch)
            .eq("id", value: user.id)
            .execute()
    }

    func replaceCurrentUserClubMemberships(with clubNames: [String]) async throws {
        guard let user = supabase.auth.currentUser else { throw DataError.notAuthenticated }

        let normalizedClubNames = Array(
            NSOrderedSet(
                array: clubNames
                    .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                    .filter { !$0.isEmpty }
            )
        ).compactMap { $0 as? String }

        _ = try await supabase
            .from("profile_clubs")
            .delete()
            .eq("user_id", value: user.id)
            .execute()

        guard !normalizedClubNames.isEmpty else { return }

        struct ProfileClubInsert: Encodable {
            let userID: UUID
            let clubName: String

            enum CodingKeys: String, CodingKey {
                case userID = "user_id"
                case clubName = "club_name"
            }
        }

        let inserts = normalizedClubNames.map {
            ProfileClubInsert(userID: user.id, clubName: $0)
        }

        _ = try await supabase
            .from("profile_clubs")
            .insert(inserts)
            .execute()
    }

    func submitCurrentUserMatchFeedback(_ input: MatchPlayerFeedbackInput) async throws {
        guard let user = supabase.auth.currentUser else { throw DataError.notAuthenticated }

        struct MatchPlayerFeedbackInsert: Encodable {
            let matchID: UUID
            let reviewerUserID: UUID
            let reviewedUserID: UUID
            let skillRating: Int16?
            let competitivenessRating: Int16?
            let friendlinessRating: Int16?
            let vibesRating: Int16?
            let communicationRating: Int16?
            let reliabilityRating: Int16?
            let wouldPlayAgain: Bool?
            let privateNote: String?

            enum CodingKeys: String, CodingKey {
                case matchID = "match_id"
                case reviewerUserID = "reviewer_user_id"
                case reviewedUserID = "reviewed_user_id"
                case skillRating = "skill_rating"
                case competitivenessRating = "competitiveness_rating"
                case friendlinessRating = "friendliness_rating"
                case vibesRating = "vibes_rating"
                case communicationRating = "communication_rating"
                case reliabilityRating = "reliability_rating"
                case wouldPlayAgain = "would_play_again"
                case privateNote = "private_note"
            }
        }

        let insert = MatchPlayerFeedbackInsert(
            matchID: input.matchID,
            reviewerUserID: user.id,
            reviewedUserID: input.reviewedUserID,
            skillRating: input.skillRating.map(Int16.init),
            competitivenessRating: input.competitivenessRating.map(Int16.init),
            friendlinessRating: input.friendlinessRating.map(Int16.init),
            vibesRating: input.vibesRating.map(Int16.init),
            communicationRating: input.communicationRating.map(Int16.init),
            reliabilityRating: input.reliabilityRating.map(Int16.init),
            wouldPlayAgain: input.wouldPlayAgain,
            privateNote: input.privateNote,
        )

        _ = try await supabase
            .from("match_player_feedback")
            .insert(insert)
            .execute()
    }

    func fetchPrivateFeedbackReceived(for reviewedUserID: UUID) async throws -> [MatchPlayerFeedback] {
        guard let user = supabase.auth.currentUser else { throw DataError.notAuthenticated }
        guard reviewedUserID == user.id else { throw DataError.unauthorizedFeedbackAccess }

        let rows = try await fetchFeedbackRows(for: reviewedUserID, includePrivateNote: true)
        return rows.map { $0.toDomain() }
    }

    func fetchDerivedMetrics(for userID: UUID) async throws -> PlayerDerivedMetrics {
        let feedbackRows = try await fetchFeedbackRows(for: userID, includePrivateNote: false)
        return deriveMetrics(for: userID, from: feedbackRows)
    }

    func fetchPublicMetricSummary(for userID: UUID) async throws -> PlayerPublicMetricSummary {
        let feedbackRows = try await fetchFeedbackRows(for: userID, includePrivateNote: false)
        let metrics = deriveMetrics(for: userID, from: feedbackRows)
        return metrics.toPublicSummary(totalReviews: feedbackRows.count)
    }

    private func fetchFeedbackRows(for reviewedUserID: UUID, includePrivateNote: Bool) async throws -> [MatchPlayerFeedbackRow] {
        guard supabase.auth.currentUser != nil else { throw DataError.notAuthenticated }

        let selectColumns = includePrivateNote
            ? "id, match_id, reviewer_user_id, reviewed_user_id, skill_rating, competitiveness_rating, friendliness_rating, vibes_rating, communication_rating, reliability_rating, would_play_again, private_note, created_at"
            : "id, match_id, reviewer_user_id, reviewed_user_id, skill_rating, competitiveness_rating, friendliness_rating, vibes_rating, communication_rating, reliability_rating, would_play_again, created_at"

        return try await supabase
            .from("match_player_feedback")
            .select(selectColumns)
            .eq("reviewed_user_id", value: reviewedUserID)
            .order("created_at", ascending: false)
            .execute()
            .value
    }

    private func deriveMetrics(for userID: UUID, from feedbackRows: [MatchPlayerFeedbackRow]) -> PlayerDerivedMetrics {
        func average(_ values: [Int?]) -> Double? {
            let resolved = values.compactMap { $0 }
            guard !resolved.isEmpty else { return nil }
            return Double(resolved.reduce(0, +)) / Double(resolved.count)
        }

        func ratio(_ values: [Bool?]) -> Double? {
            let resolved = values.compactMap { $0 }
            guard !resolved.isEmpty else { return nil }
            let positiveCount = resolved.filter { $0 }.count
            return (Double(positiveCount) / Double(resolved.count)) * 5.0
        }

        let friendlinessScore = average(feedbackRows.map(\.friendlinessRating))
        let competitivenessScore = average(feedbackRows.map(\.competitivenessRating))
        let vibesScore = average(feedbackRows.map(\.vibesRating))
        let reliabilityScore = average(feedbackRows.map(\.reliabilityRating))
        let skillConfidence = average(feedbackRows.map(\.skillRating))
        let repeatPlayRate = ratio(feedbackRows.map(\.wouldPlayAgain))

        return PlayerDerivedMetrics(
            id: userID.uuidString,
            friendlinessScore: friendlinessScore,
            competitivenessScore: competitivenessScore,
            vibesScore: vibesScore,
            reliabilityScore: reliabilityScore,
            skillConfidence: skillConfidence,
            repeatPlayRate: repeatPlayRate
        )
    }

    /// Marks profile as completed if required fields exist.
    /// V1 rule: must have an action photo + skill_level + background_level.
    func markProfileCompletedIfReady() async throws {
        guard let user = supabase.auth.currentUser else { throw DataError.notAuthenticated }

        // Check for action photo existence
        struct UUIDRow: Decodable { let id: UUID }
        let actionRows: [UUIDRow] = try await supabase
            .from("profile_photos")
            .select("id")
            .eq("user_id", value: user.id)
            .eq("type", value: ProfilePhotoType.action.rawValue)
            .execute()
            .value

        guard !actionRows.isEmpty else { return }

        // Fetch required profile fields
        struct RequiredFields: Decodable {
            let backgroundLevel: String?
            let skillLevel: Int?

            enum CodingKeys: String, CodingKey {
                case backgroundLevel = "background_level"
                case skillLevel = "skill_level"
            }
        }

        let required: RequiredFields = try await supabase
            .from("profiles")
            .select("background_level, skill_level")
            .eq("id", value: user.id)
            .single()
            .execute()
            .value

        guard required.backgroundLevel != nil, required.skillLevel != nil else { return }

        struct CompletionPatch: Encodable {
            let profileCompletedAt: String
            enum CodingKeys: String, CodingKey {
                case profileCompletedAt = "profile_completed_at"
            }
        }

        let patch = CompletionPatch(profileCompletedAt: ISO8601DateFormatter().string(from: Date()))

        _ = try await supabase
            .from("profiles")
            .update(patch)
            .eq("id", value: user.id)
            .execute()
    }

    private func loadOwnerEditableProfile(for userID: UUID) async throws -> OwnerEditableProfile {
        let profileRows: [OwnerEditableProfileRow] = try await supabase
            .from("profiles")
            .select("id, user_id, display_name, username, profile_photo_path, action_photo_path, bio, profile_completion_state, account_status, last_active_at, created_at, updated_at")
            .eq("user_id", value: userID)
            .limit(1)
            .execute()
            .value

        guard let profileRow = profileRows.first else {
            throw ProfileRepositoryError.profileMissing
        }

        let profileID = profileRow.id

        let sportsRows: [OwnerProfileSportRow] = try await supabase
            .from("profile_sports")
            .select("id, profile_id, sport_slug, skill_level, is_primary, created_at, updated_at")
            .eq("profile_id", value: profileID)
            .order("sport_slug", ascending: true)
            .execute()
            .value

        let availabilityRows: [OwnerProfileAvailabilityRow] = try await supabase
            .from("profile_availability")
            .select("profile_id, preferred_days, preferred_times, play_intent, home_area, travel_radius_miles, preferred_play_style, created_at, updated_at")
            .eq("profile_id", value: profileID)
            .limit(1)
            .execute()
            .value

        let privacyRows: [OwnerProfilePrivacyRow] = try await supabase
            .from("profile_privacy")
            .select("profile_id, profile_visibility, discoverable, location_precision, created_at, updated_at")
            .eq("profile_id", value: profileID)
            .limit(1)
            .execute()
            .value

        let profile = try OwnerEditableProfileMapper.ownerEditableProfile(
            profile: profileRow,
            sports: sportsRows,
            availability: availabilityRows.first,
            privacy: privacyRows.first
        )

        cachedOwnerEditableProfile = profile
        return profile
    }

    private func ownerProfileID(for userID: UUID) async throws -> UUID {
        if let cachedID = cachedOwnerEditableProfile.flatMap({ UUID(uuidString: $0.id) }) {
            return cachedID
        }

        let profileRows: [OwnerEditableProfileRow] = try await supabase
            .from("profiles")
            .select("id, user_id, display_name, username, profile_photo_path, action_photo_path, bio, profile_completion_state, account_status, last_active_at, created_at, updated_at")
            .eq("user_id", value: userID)
            .limit(1)
            .execute()
            .value

        guard let profileRow = profileRows.first else {
            throw ProfileRepositoryError.profileMissing
        }

        return profileRow.id
    }

    private func performOwnerProfileOperation(
        _ operation: () async throws -> OwnerEditableProfile
    ) async throws -> OwnerEditableProfile {
        do {
            return try await operation()
        } catch let error as ProfileRepositoryError {
            throw error
        } catch _ as DecodingError {
            throw ProfileRepositoryError.decodingFailed
        } catch let error as URLError {
            if error.code == .notConnectedToInternet || error.code == .networkConnectionLost {
                throw ProfileRepositoryError.networkUnavailable
            }
            throw ProfileRepositoryError.serverUnavailable
        } catch let error as PostgrestError {
            throw Self.profileRepositoryError(from: error)
        } catch {
            throw ProfileRepositoryError.unknown
        }
    }

    static func profileRepositoryError(from error: PostgrestError) -> ProfileRepositoryError {
        switch error.code {
        case "42501":
            return .permissionDenied
        case "23505", "23514":
            return .validationFailed([])
        case "PGRST116":
            return .profileMissing
        default:
            return .serverUnavailable
        }
    }

    private func validate(_ errors: [ProfileUpdateValidationError]) throws {
        guard errors.isEmpty else {
            throw ProfileRepositoryError.validationFailed(errors)
        }
    }

    static func uniqueNonEmptyValues(_ values: [String]) -> [String] {
        var seen: Set<String> = []
        var result: [String] = []

        for value in values {
            let normalized = value.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !normalized.isEmpty, !seen.contains(normalized) else { continue }

            seen.insert(normalized)
            result.append(normalized)
        }

        return result
    }
}
