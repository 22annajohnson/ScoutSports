//
//  MockProfileRepository.swift
//  ScoutTests
//
//  Created by Anna on 3/2/26.
//

import Foundation

/// Test double for `ProfileProviding`.
/// - Configurable return values for fetch/update
/// - Tracks calls and captured inputs
final class MockProfileRepository: ProfileProviding {

    // MARK: - Captured inputs

    private(set) var fetchMyProfileCallCount: Int = 0
    private(set) var updateDisplayNameCalls: [String] = []
    private(set) var setMySinglePhotoCalls: [(type: ProfilePhotoType, path: String, blurhash: String?)] = []
    private(set) var updateMyProfileCalls: [ProfileUpdateInput] = []
    private(set) var markProfileCompletedCallCount: Int = 0

    // MARK: - Configurable behavior

    /// If set, `fetchMyProfile()` will throw.
    var fetchMyProfileError: Error?

    /// If set, `fetchMyProfile()` will return this profile.
    var fetchMyProfileResult: Profile = Profile(id: "test-user", displayName: "Test")

    /// If set, `updateDisplayName(_:)` will throw.
    var updateDisplayNameError: Error?
    var setMySinglePhotoError: Error?
    var updateMyProfileError: Error?
    var markProfileCompletedError: Error?

    /// Optional hooks if you want side effects.
    var onFetchMyProfile: (() -> Void)?
    var onUpdateDisplayName: ((String) -> Void)?
    var onSetMySinglePhoto: ((ProfilePhotoType, String, String?) -> Void)?
    var onUpdateMyProfile: ((ProfileUpdateInput) -> Void)?
    var onMarkProfileCompleted: (() -> Void)?

    // MARK: - ProfileProviding

    func fetchMyProfile() async throws -> Profile {
        fetchMyProfileCallCount += 1
        onFetchMyProfile?()
        if let fetchMyProfileError { throw fetchMyProfileError }
        return fetchMyProfileResult
    }

    func updateDisplayName(_ newName: String) async throws {
        updateDisplayNameCalls.append(newName)
        onUpdateDisplayName?(newName)
        if let updateDisplayNameError { throw updateDisplayNameError }

        // Convenience: mirror the update into the stored result
        fetchMyProfileResult = Profile(id: fetchMyProfileResult.id, displayName: newName)
    }

    func setCurrentUserSinglePhoto(type: ProfilePhotoType, path: String, blurhash: String?) async throws {
        setMySinglePhotoCalls.append((type: type, path: path, blurhash: blurhash))
        onSetMySinglePhoto?(type, path, blurhash)
        if let setMySinglePhotoError { throw setMySinglePhotoError }
    }

    func updateCurrentUserProfile(_ input: ProfileUpdateInput) async throws {
        updateMyProfileCalls.append(input)
        onUpdateMyProfile?(input)
        if let updateMyProfileError { throw updateMyProfileError }
    }

    func markProfileCompletedIfReady() async throws {
        markProfileCompletedCallCount += 1
        onMarkProfileCompleted?()
        if let markProfileCompletedError { throw markProfileCompletedError }
    }
}
