//
//  SupabaseConfig.swift
//  Scout
//
//  Created by Anna on 2/26/26.
//

import Foundation

enum SupabaseConfig {
    static var url: URL {
        guard let value = resolvedString(forInfoKey: "SUPABASE_URL") else {
            preconditionFailure("Missing/invalid SUPABASE_URL in Info.plist")
        }

        guard let url = URL(string: value) else {
            preconditionFailure("Missing/invalid SUPABASE_URL in Info.plist")
        }

        return url
    }

    static var anonKey: String {
        guard let value = resolvedString(forInfoKey: "SUPABASE_ANON_KEY") else {
            preconditionFailure("Missing SUPABASE_ANON_KEY in Info.plist")
        }

        return value
    }

    private static func resolvedString(forInfoKey key: String) -> String? {
        let bundles = [Bundle.main, Bundle(for: BundleLocator.self)]

        for bundle in bundles {
            guard
                let rawValue = bundle.object(forInfoDictionaryKey: key) as? String,
                let value = normalized(rawValue)
            else {
                continue
            }

            return value
        }

        if let envValue = normalized(ProcessInfo.processInfo.environment[key]) {
            return envValue
        }

        return nil
    }

    private static func normalized(_ rawValue: String?) -> String? {
        guard let rawValue else { return nil }

        let trimmed = rawValue.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        guard !trimmed.hasPrefix("$(") else { return nil }

        return trimmed
    }
}

private final class BundleLocator {}
