//
//  ProfileDTO.swift
//  Scout
//
//  Created by Anna on 2/26/26.
//

import Foundation

struct ProfileDTO: Decodable {
    let id: String
    let displayName: String

    private enum CodingKeys: String, CodingKey {
        case id
        case displayName = "display_name"
    }

    func toDomain() -> Profile {
        Profile(id: id, displayName: displayName)
    }
}

struct PlayerPublicProfileDTO: Decodable {
    let id: String
    let displayName: String?
    let birthdate: Date?
    let primarySport: String?
    let bio: String?
    let homeCourtName: String?
    let backgroundLevel: String?
    let yearsPlaying: Int?
    let skillLevel: Int?
    let playStyle: String?

    private enum CodingKeys: String, CodingKey {
        case id
        case displayName = "display_name"
        case birthdate
        case primarySport = "primary_sport"
        case bio
        case homeCourtName = "home_court_name"
        case backgroundLevel = "background_level"
        case yearsPlaying = "years_playing"
        case skillLevel = "skill_level"
        case playStyle = "play_style"
    }

    func toDomain(clubNames: [String]) -> PlayerPublicProfile {
        PlayerPublicProfile(
            id: id,
            displayName: displayName,
            birthdate: birthdate,
            primarySport: primarySport,
            bio: bio,
            homeCourtName: homeCourtName,
            clubNames: clubNames,
            skillLevel: skillLevel,
            playStyle: playStyle
        )
    }
}
