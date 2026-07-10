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
final class MockProfileRepository: ProfileProviding, PlayerMatchSignalsProviding, PlayerProfileRelationshipsProviding, MatchFeedbackProviding, InternalMatchFeedbackProviding, PlayerMetricsProviding {

    // MARK: - Captured inputs

    private(set) var fetchMyProfileCallCount: Int = 0
    private(set) var updateDisplayNameCalls: [String] = []
    private(set) var setMySinglePhotoCalls: [(type: ProfilePhotoType, path: String, blurhash: String?)] = []
    private(set) var addGalleryPhotoCalls: [(id: UUID, path: String, position: Int16, isPrimary: Bool, blurhash: String?)] = []
    private(set) var updateMyProfileCalls: [PlayerPublicProfileUpdateInput] = []
    private(set) var updateMatchSignalsCalls: [PlayerMatchSignalsUpdateInput] = []
    private(set) var replaceClubMembershipCalls: [[String]] = []
    private(set) var submittedMatchFeedbackCalls: [MatchPlayerFeedbackInput] = []
    private(set) var markProfileCompletedCallCount: Int = 0

    // MARK: - Configurable behavior

    /// If set, `fetchMyProfile()` will throw.
    var fetchMyProfileError: Error?

    /// If set, `fetchMyProfile()` will return this profile.
    var fetchMyProfileResult: Profile = Profile(id: "test-user", displayName: "Test")
    var fetchMyProfileState: RepositoryFixtureState<Profile>?

    /// If set, `updateDisplayName(_:)` will throw.
    var updateDisplayNameError: Error?
    var setMySinglePhotoError: Error?
    var addGalleryPhotoError: Error?
    var updateMyProfileError: Error?
    var updateMatchSignalsError: Error?
    var replaceClubMembershipError: Error?
    var submitMatchFeedbackError: Error?
    var markProfileCompletedError: Error?
    var feedbackReceivedResult: [MatchPlayerFeedback] = []
    var feedbackReceivedState: RepositoryFixtureState<[MatchPlayerFeedback]>?
    var derivedMetricsResult = PlayerDerivedMetrics(
        id: "test-user",
        friendlinessScore: nil,
        competitivenessScore: nil,
        vibesScore: nil,
        reliabilityScore: nil,
        skillConfidence: nil,
        repeatPlayRate: nil
    )
    var publicMetricSummaryResult = PlayerPublicMetricSummary(
        id: "test-user",
        totalReviews: 0,
        stats: []
    )

    /// Optional hooks if you want side effects.
    var onFetchMyProfile: (() -> Void)?
    var onUpdateDisplayName: ((String) -> Void)?
    var onSetMySinglePhoto: ((ProfilePhotoType, String, String?) -> Void)?
    var onAddGalleryPhoto: ((UUID, String, Int16, Bool, String?) -> Void)?
    var onUpdateMyProfile: ((PlayerPublicProfileUpdateInput) -> Void)?
    var onUpdateMatchSignals: ((PlayerMatchSignalsUpdateInput) -> Void)?
    var onReplaceClubMemberships: (([String]) -> Void)?
    var onSubmitMatchFeedback: ((MatchPlayerFeedbackInput) -> Void)?
    var onMarkProfileCompleted: (() -> Void)?

    // MARK: - Fixture conventions

    static func success(profile: Profile = ProfileFixtures.make()) -> MockProfileRepository {
        let repository = MockProfileRepository()
        repository.configureFetchMyProfile(.success(profile))
        return repository
    }

    static func empty() -> MockProfileRepository {
        let repository = MockProfileRepository()
        repository.configureFetchMyProfile(.empty)
        repository.configureFeedbackReceived(.empty)
        return repository
    }

    static func failure(_ error: Error) -> MockProfileRepository {
        let repository = MockProfileRepository()
        repository.configureFetchMyProfile(.failure(error))
        repository.configureFeedbackReceived(.failure(error))
        return repository
    }

    func configureFetchMyProfile(_ state: RepositoryFixtureState<Profile>) {
        fetchMyProfileState = state
    }

    func configureFeedbackReceived(_ state: RepositoryFixtureState<[MatchPlayerFeedback]>) {
        feedbackReceivedState = state
    }

    // MARK: - ProfileProviding

    func fetchMyProfile() async throws -> Profile {
        fetchMyProfileCallCount += 1
        onFetchMyProfile?()
        if let fetchMyProfileState {
            return try fetchMyProfileState.value(emptyValue: ProfileFixtures.empty)
        }
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

    func addCurrentUserGalleryPhoto(id: UUID, path: String, position: Int16, isPrimary: Bool, blurhash: String?) async throws {
        addGalleryPhotoCalls.append((id: id, path: path, position: position, isPrimary: isPrimary, blurhash: blurhash))
        onAddGalleryPhoto?(id, path, position, isPrimary, blurhash)
        if let addGalleryPhotoError { throw addGalleryPhotoError }
    }

    func fetchCurrentUserPublicProfile() async throws -> PlayerPublicProfile {
        PlayerPublicProfile(
            id: fetchMyProfileResult.id,
            displayName: fetchMyProfileResult.displayName,
            birthdate: nil,
            primarySport: nil,
            bio: nil,
            homeCourtName: nil,
            clubNames: replaceClubMembershipCalls.last ?? [],
            skillLevel: nil,
            playStyle: nil
        )
    }

    func updateCurrentUserProfile(_ input: PlayerPublicProfileUpdateInput) async throws {
        updateMyProfileCalls.append(input)
        onUpdateMyProfile?(input)
        if let updateMyProfileError { throw updateMyProfileError }
    }

    func updateCurrentUserMatchSignals(_ input: PlayerMatchSignalsUpdateInput) async throws {
        updateMatchSignalsCalls.append(input)
        onUpdateMatchSignals?(input)
        if let updateMatchSignalsError { throw updateMatchSignalsError }
    }

    func replaceCurrentUserClubMemberships(with clubNames: [String]) async throws {
        replaceClubMembershipCalls.append(clubNames)
        onReplaceClubMemberships?(clubNames)
        if let replaceClubMembershipError { throw replaceClubMembershipError }
    }

    func submitCurrentUserMatchFeedback(_ input: MatchPlayerFeedbackInput) async throws {
        submittedMatchFeedbackCalls.append(input)
        onSubmitMatchFeedback?(input)
        if let submitMatchFeedbackError { throw submitMatchFeedbackError }
    }

    func fetchPrivateFeedbackReceived(for reviewedUserID: UUID) async throws -> [MatchPlayerFeedback] {
        let feedback = try feedbackReceivedState?.value(emptyValue: []) ?? feedbackReceivedResult
        return feedback.filter { $0.reviewedUserID == reviewedUserID }
    }

    func fetchDerivedMetrics(for userID: UUID) async throws -> PlayerDerivedMetrics {
        derivedMetricsResult
    }

    func fetchPublicMetricSummary(for userID: UUID) async throws -> PlayerPublicMetricSummary {
        publicMetricSummaryResult
    }

    func markProfileCompletedIfReady() async throws {
        markProfileCompletedCallCount += 1
        onMarkProfileCompleted?()
        if let markProfileCompletedError { throw markProfileCompletedError }
    }
}
