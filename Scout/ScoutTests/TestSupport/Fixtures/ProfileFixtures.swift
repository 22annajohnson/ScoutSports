//
//  ProfileFixtures.swift
//  ScoutTests
//
//  Created by Anna on 3/2/26.
//

import Foundation

/// Convenience fixtures for building deterministic `Profile` values in tests.
enum ProfileFixtures {

    /// A stable, commonly-used profile fixture.
    static var anna: Profile {
        Profile(id: "user-anna", displayName: "Anna")
    }

    /// Another stable profile fixture.
    static var noah: Profile {
        Profile(id: "user-noah", displayName: "Noah")
    }

    /// Factory for quickly generating a profile with overrides.
    static func make(
        id: String = UUID().uuidString,
        displayName: String = "Test User"
    ) -> Profile {
        Profile(id: id, displayName: displayName)
    }
}
