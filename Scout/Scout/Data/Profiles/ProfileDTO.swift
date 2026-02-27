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
