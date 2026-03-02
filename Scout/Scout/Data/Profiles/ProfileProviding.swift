//
//  ProfileProviding.swift
//  Scout
//
//  Created by Anna on 2/26/26.
//

import Foundation

protocol ProfileProviding {
    func fetchMyProfile() async throws -> Profile
    func updateDisplayName(_ newName: String) async throws
}
