//
//  ProfileFixtures.swift
//  ScoutTests
//
//  Created by Anna on 3/2/26.
//

import Foundation

/// Shared repository-state vocabulary for test doubles.
///
/// Repository mocks should use these states when a test needs to exercise
/// success, empty, failure, or deliberately unresolved loading behavior.
enum RepositoryFixtureState<Value> {
    case loading
    case empty
    case success(Value)
    case failure(Error)

    func value(emptyValue: @autoclosure () -> Value) throws -> Value {
        switch self {
        case .loading:
            throw RepositoryFixtureStateError.unresolvedLoadingState
        case .empty:
            return emptyValue()
        case .success(let value):
            return value
        case .failure(let error):
            throw error
        }
    }
}

enum RepositoryFixtureStateError: Error, Equatable {
    case unresolvedLoadingState
}

/// Convenience fixtures for building deterministic `Profile` values in tests.
enum ProfileFixtures {
    static let annaID = "user-anna"
    static let noahID = "user-noah"
    static let testUserID = "user-test"

    /// A stable, commonly-used profile fixture.
    static var anna: Profile {
        Profile(id: annaID, displayName: "Anna")
    }

    /// Another stable profile fixture.
    static var noah: Profile {
        Profile(id: noahID, displayName: "Noah")
    }

    /// Empty-ish profile data for tests that need an empty repository state.
    static var empty: Profile {
        Profile(id: testUserID, displayName: "")
    }

    /// Factory for quickly generating a profile with overrides.
    static func make(
        id: String = testUserID,
        displayName: String = "Test User"
    ) -> Profile {
        Profile(id: id, displayName: displayName)
    }
}
