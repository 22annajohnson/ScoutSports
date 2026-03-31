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
    func setCurrentUserSinglePhoto(type: ProfilePhotoType, path: String, blurhash: String?) async throws
    func updateCurrentUserProfile(_ input: ProfileUpdateInput) async throws
    func markProfileCompletedIfReady() async throws
}
