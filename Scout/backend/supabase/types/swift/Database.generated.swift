import Foundation
import Supabase

internal enum PublicSchema {
  internal struct ProfileAvailabilitySelect: Codable, Hashable, Sendable {
    internal let createdAt: String
    internal let homeArea: String?
    internal let playIntent: String?
    internal let preferredDays: [String]
    internal let preferredPlayStyle: String?
    internal let preferredTimes: [String]
    internal let profileId: UUID
    internal let travelRadiusMiles: Int32?
    internal let updatedAt: String
    internal enum CodingKeys: String, CodingKey {
      case createdAt = "created_at"
      case homeArea = "home_area"
      case playIntent = "play_intent"
      case preferredDays = "preferred_days"
      case preferredPlayStyle = "preferred_play_style"
      case preferredTimes = "preferred_times"
      case profileId = "profile_id"
      case travelRadiusMiles = "travel_radius_miles"
      case updatedAt = "updated_at"
    }
  }
  internal struct ProfileAvailabilityInsert: Codable, Hashable, Sendable {
    internal let createdAt: String?
    internal let homeArea: String?
    internal let playIntent: String?
    internal let preferredDays: [String]?
    internal let preferredPlayStyle: String?
    internal let preferredTimes: [String]?
    internal let profileId: UUID
    internal let travelRadiusMiles: Int32?
    internal let updatedAt: String?
    internal enum CodingKeys: String, CodingKey {
      case createdAt = "created_at"
      case homeArea = "home_area"
      case playIntent = "play_intent"
      case preferredDays = "preferred_days"
      case preferredPlayStyle = "preferred_play_style"
      case preferredTimes = "preferred_times"
      case profileId = "profile_id"
      case travelRadiusMiles = "travel_radius_miles"
      case updatedAt = "updated_at"
    }
  }
  internal struct ProfileAvailabilityUpdate: Codable, Hashable, Sendable {
    internal let createdAt: String?
    internal let homeArea: String?
    internal let playIntent: String?
    internal let preferredDays: [String]?
    internal let preferredPlayStyle: String?
    internal let preferredTimes: [String]?
    internal let profileId: UUID?
    internal let travelRadiusMiles: Int32?
    internal let updatedAt: String?
    internal enum CodingKeys: String, CodingKey {
      case createdAt = "created_at"
      case homeArea = "home_area"
      case playIntent = "play_intent"
      case preferredDays = "preferred_days"
      case preferredPlayStyle = "preferred_play_style"
      case preferredTimes = "preferred_times"
      case profileId = "profile_id"
      case travelRadiusMiles = "travel_radius_miles"
      case updatedAt = "updated_at"
    }
  }
  internal struct ProfilePrivacySelect: Codable, Hashable, Sendable {
    internal let createdAt: String
    internal let discoverable: Bool
    internal let locationPrecision: String
    internal let profileId: UUID
    internal let profileVisibility: String
    internal let updatedAt: String
    internal enum CodingKeys: String, CodingKey {
      case createdAt = "created_at"
      case discoverable = "discoverable"
      case locationPrecision = "location_precision"
      case profileId = "profile_id"
      case profileVisibility = "profile_visibility"
      case updatedAt = "updated_at"
    }
  }
  internal struct ProfilePrivacyInsert: Codable, Hashable, Sendable {
    internal let createdAt: String?
    internal let discoverable: Bool?
    internal let locationPrecision: String?
    internal let profileId: UUID
    internal let profileVisibility: String?
    internal let updatedAt: String?
    internal enum CodingKeys: String, CodingKey {
      case createdAt = "created_at"
      case discoverable = "discoverable"
      case locationPrecision = "location_precision"
      case profileId = "profile_id"
      case profileVisibility = "profile_visibility"
      case updatedAt = "updated_at"
    }
  }
  internal struct ProfilePrivacyUpdate: Codable, Hashable, Sendable {
    internal let createdAt: String?
    internal let discoverable: Bool?
    internal let locationPrecision: String?
    internal let profileId: UUID?
    internal let profileVisibility: String?
    internal let updatedAt: String?
    internal enum CodingKeys: String, CodingKey {
      case createdAt = "created_at"
      case discoverable = "discoverable"
      case locationPrecision = "location_precision"
      case profileId = "profile_id"
      case profileVisibility = "profile_visibility"
      case updatedAt = "updated_at"
    }
  }
  internal struct ProfileSportsSelect: Codable, Hashable, Sendable {
    internal let createdAt: String
    internal let id: UUID
    internal let isPrimary: Bool
    internal let profileId: UUID
    internal let skillLevel: String?
    internal let sportSlug: String
    internal let updatedAt: String
    internal enum CodingKeys: String, CodingKey {
      case createdAt = "created_at"
      case id = "id"
      case isPrimary = "is_primary"
      case profileId = "profile_id"
      case skillLevel = "skill_level"
      case sportSlug = "sport_slug"
      case updatedAt = "updated_at"
    }
  }
  internal struct ProfileSportsInsert: Codable, Hashable, Sendable {
    internal let createdAt: String?
    internal let id: UUID?
    internal let isPrimary: Bool?
    internal let profileId: UUID
    internal let skillLevel: String?
    internal let sportSlug: String
    internal let updatedAt: String?
    internal enum CodingKeys: String, CodingKey {
      case createdAt = "created_at"
      case id = "id"
      case isPrimary = "is_primary"
      case profileId = "profile_id"
      case skillLevel = "skill_level"
      case sportSlug = "sport_slug"
      case updatedAt = "updated_at"
    }
  }
  internal struct ProfileSportsUpdate: Codable, Hashable, Sendable {
    internal let createdAt: String?
    internal let id: UUID?
    internal let isPrimary: Bool?
    internal let profileId: UUID?
    internal let skillLevel: String?
    internal let sportSlug: String?
    internal let updatedAt: String?
    internal enum CodingKeys: String, CodingKey {
      case createdAt = "created_at"
      case id = "id"
      case isPrimary = "is_primary"
      case profileId = "profile_id"
      case skillLevel = "skill_level"
      case sportSlug = "sport_slug"
      case updatedAt = "updated_at"
    }
  }
  internal struct ProfilesSelect: Codable, Hashable, Sendable {
    internal let accountStatus: String
    internal let actionPhotoPath: String?
    internal let bio: String?
    internal let createdAt: String
    internal let displayName: String?
    internal let id: UUID
    internal let lastActiveAt: String?
    internal let profileCompletionState: String
    internal let profilePhotoPath: String?
    internal let updatedAt: String
    internal let userId: UUID
    internal let username: String?
    internal enum CodingKeys: String, CodingKey {
      case accountStatus = "account_status"
      case actionPhotoPath = "action_photo_path"
      case bio = "bio"
      case createdAt = "created_at"
      case displayName = "display_name"
      case id = "id"
      case lastActiveAt = "last_active_at"
      case profileCompletionState = "profile_completion_state"
      case profilePhotoPath = "profile_photo_path"
      case updatedAt = "updated_at"
      case userId = "user_id"
      case username = "username"
    }
  }
  internal struct ProfilesInsert: Codable, Hashable, Sendable {
    internal let accountStatus: String?
    internal let actionPhotoPath: String?
    internal let bio: String?
    internal let createdAt: String?
    internal let displayName: String?
    internal let id: UUID?
    internal let lastActiveAt: String?
    internal let profileCompletionState: String?
    internal let profilePhotoPath: String?
    internal let updatedAt: String?
    internal let userId: UUID
    internal let username: String?
    internal enum CodingKeys: String, CodingKey {
      case accountStatus = "account_status"
      case actionPhotoPath = "action_photo_path"
      case bio = "bio"
      case createdAt = "created_at"
      case displayName = "display_name"
      case id = "id"
      case lastActiveAt = "last_active_at"
      case profileCompletionState = "profile_completion_state"
      case profilePhotoPath = "profile_photo_path"
      case updatedAt = "updated_at"
      case userId = "user_id"
      case username = "username"
    }
  }
  internal struct ProfilesUpdate: Codable, Hashable, Sendable {
    internal let accountStatus: String?
    internal let actionPhotoPath: String?
    internal let bio: String?
    internal let createdAt: String?
    internal let displayName: String?
    internal let id: UUID?
    internal let lastActiveAt: String?
    internal let profileCompletionState: String?
    internal let profilePhotoPath: String?
    internal let updatedAt: String?
    internal let userId: UUID?
    internal let username: String?
    internal enum CodingKeys: String, CodingKey {
      case accountStatus = "account_status"
      case actionPhotoPath = "action_photo_path"
      case bio = "bio"
      case createdAt = "created_at"
      case displayName = "display_name"
      case id = "id"
      case lastActiveAt = "last_active_at"
      case profileCompletionState = "profile_completion_state"
      case profilePhotoPath = "profile_photo_path"
      case updatedAt = "updated_at"
      case userId = "user_id"
      case username = "username"
    }
  }
  internal struct ProfilePublicSummariesSelect: Codable, Hashable, Sendable {
    internal let bio: String?
    internal let displayName: String?
    internal let profileId: UUID?
    internal let profilePhotoPath: String?
    internal let username: String?
    internal enum CodingKeys: String, CodingKey {
      case bio = "bio"
      case displayName = "display_name"
      case profileId = "profile_id"
      case profilePhotoPath = "profile_photo_path"
      case username = "username"
    }
  }
  internal struct ProfileSportSummariesSelect: Codable, Hashable, Sendable {
    internal let isPrimary: Bool?
    internal let profileId: UUID?
    internal let skillLevel: String?
    internal let sportSlug: String?
    internal enum CodingKeys: String, CodingKey {
      case isPrimary = "is_primary"
      case profileId = "profile_id"
      case skillLevel = "skill_level"
      case sportSlug = "sport_slug"
    }
  }
}
