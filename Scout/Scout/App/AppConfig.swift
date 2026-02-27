//
//  AppConfig.swift
//  Scout
//
//  Created by Anna on 2/26/26.
//

import Foundation

enum AppConfig {

    static var supabaseURL: URL {
        SupabaseConfig.url
    }

    static var supabaseAnonKey: String {
        SupabaseConfig.anonKey
    }

    static var isDebug: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
}
