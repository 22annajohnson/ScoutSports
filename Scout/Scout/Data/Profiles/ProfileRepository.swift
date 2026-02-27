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
}

final class ProfileRepository: ProfileProviding {
    private let supabase: SupabaseClient

    init(supabase: SupabaseClient = SupabaseProvider.shared.client) {
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

    func updateDisplayName(_ newName: String) async throws {
        guard let user = supabase.auth.currentUser else { throw DataError.notAuthenticated }

        _ = try await supabase
            .from("profiles")
            .update(["display_name": newName])
            .eq("id", value: user.id)
            .execute()
    }
}
