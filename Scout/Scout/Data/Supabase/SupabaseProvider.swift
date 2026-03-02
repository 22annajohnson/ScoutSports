//
//  SupabaseProvider.swift
//  Scout
//
//  Created by Anna on 2/26/26.
//

import Foundation
import Supabase

final class SupabaseProvider {

    // MARK: - Singleton (simple + clean for now)

    static let shared = SupabaseProvider()

    // MARK: - Client

    let client: SupabaseClient

    private init() {
        self.client = SupabaseClient(
            supabaseURL: SupabaseConfig.url,
            supabaseKey: SupabaseConfig.anonKey
        )
    }
}
