//
//  SupabaseConfig.swift
//  Scout
//
//  Created by Anna on 2/26/26.
//

import Foundation

enum SupabaseConfig {
    static var url: URL {
        guard
            let value = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_URL") as? String,
            let url = URL(string: value)
        else {
            preconditionFailure("Missing/invalid SUPABASE_URL in Info.plist")
        }
        return url
    }

    static var anonKey: String {
        guard let value = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_ANON_KEY") as? String,
              !value.isEmpty
        else {
            preconditionFailure("Missing SUPABASE_ANON_KEY in Info.plist")
        }
        return value
    }
}
