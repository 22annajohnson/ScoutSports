//
//  SessionStoreTests.swift
//  ScoutTests
//
//  Created by Anna on 3/2/26.
//

import XCTest
import Supabase
@testable import Scout

@MainActor
final class SessionStoreTests: XCTestCase {

    enum TestError: Error, Equatable {
        case boom
    }

    private func makeSupabaseClient() -> SupabaseClient {
        SupabaseClient(
            supabaseURL: URL(string: "https://preview.local")!,
            supabaseKey: "preview-anon-key"
        )
    }

    func test_loadInitialSession_whenNoCurrentUser_setsIsLoadingFalse_andDoesNotFetchProfile() async {
        // Arrange
        let supabase = makeSupabaseClient()
        let auth = MockAuthService()
        let profiles = MockProfileRepository()
        profiles.fetchMyProfileResult = ProfileFixtures.anna

        let sut = SessionStore(supabase: supabase, auth: auth, profiles: profiles)

        // Act
        await sut.loadInitialSession()

        // Assert
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.userID)
        XCTAssertNil(sut.sessionUser)
        XCTAssertEqual(profiles.fetchMyProfileCallCount, 0)
    }

    func test_signIn_whenAuthSucceeds_fetchesProfile_andStoresProfile() async throws {
        // Arrange
        let supabase = makeSupabaseClient()
        let auth = MockAuthService()
        let profiles = MockProfileRepository()
        profiles.fetchMyProfileResult = ProfileFixtures.anna

        let sut = SessionStore(supabase: supabase, auth: auth, profiles: profiles)

        // Act
        try await sut.signIn(email: "a@test.com", password: "password")

        // Assert
        XCTAssertEqual(auth.signInCalls.count, 1)
        XCTAssertEqual(auth.signInCalls.first?.email, "a@test.com")
        XCTAssertEqual(auth.signInCalls.first?.password, "password")

        XCTAssertEqual(profiles.fetchMyProfileCallCount, 1)
        XCTAssertEqual(sut.profile, ProfileFixtures.anna)
    }

    func test_signIn_whenAuthThrows_doesNotFetchProfile_andDoesNotChangeProfile() async {
        // Arrange
        let supabase = makeSupabaseClient()
        let auth = MockAuthService()
        auth.signInError = TestError.boom

        let profiles = MockProfileRepository()
        profiles.fetchMyProfileResult = ProfileFixtures.anna

        let sut = SessionStore(supabase: supabase, auth: auth, profiles: profiles)
        sut.profile = ProfileFixtures.noah

        // Act
        do {
            try await sut.signIn(email: "a@test.com", password: "password")
            XCTFail("Expected error")
        } catch {
            // expected
        }

        // Assert
        XCTAssertEqual(auth.signInCalls.count, 1)
        XCTAssertEqual(profiles.fetchMyProfileCallCount, 0)
        XCTAssertEqual(sut.profile, ProfileFixtures.noah)
    }

    func test_signUp_whenAuthSucceeds_fetchesProfile_andStoresProfile() async throws {
        // Arrange
        let supabase = makeSupabaseClient()
        let auth = MockAuthService()
        let profiles = MockProfileRepository()
        profiles.fetchMyProfileResult = ProfileFixtures.anna

        let sut = SessionStore(supabase: supabase, auth: auth, profiles: profiles)

        // Act
        try await sut.signUp(email: "new@test.com", password: "password")

        // Assert
        XCTAssertEqual(auth.signUpCalls.count, 1)
        XCTAssertEqual(auth.signUpCalls.first?.email, "new@test.com")
        XCTAssertEqual(auth.signUpCalls.first?.password, "password")

        XCTAssertEqual(profiles.fetchMyProfileCallCount, 1)
        XCTAssertEqual(sut.profile, ProfileFixtures.anna)
    }

    func test_signUp_whenAuthThrows_doesNotFetchProfile() async {
        // Arrange
        let supabase = makeSupabaseClient()
        let auth = MockAuthService()
        auth.signUpError = TestError.boom

        let profiles = MockProfileRepository()
        let sut = SessionStore(supabase: supabase, auth: auth, profiles: profiles)

        // Act
        do {
            try await sut.signUp(email: "new@test.com", password: "password")
            XCTFail("Expected error")
        } catch {
            // expected
        }

        // Assert
        XCTAssertEqual(auth.signUpCalls.count, 1)
        XCTAssertEqual(profiles.fetchMyProfileCallCount, 0)
        XCTAssertNil(sut.profile)
    }

    func test_fetchProfile_whenRepositoryReturnsProfile_updatesPublishedProfile() async throws {
        // Arrange
        let supabase = makeSupabaseClient()
        let auth = MockAuthService()
        let profiles = MockProfileRepository()
        profiles.fetchMyProfileResult = ProfileFixtures.anna

        let sut = SessionStore(supabase: supabase, auth: auth, profiles: profiles)

        // Act
        try await sut.fetchProfile()

        // Assert
        XCTAssertEqual(profiles.fetchMyProfileCallCount, 1)
        XCTAssertEqual(sut.profile, ProfileFixtures.anna)
    }

    func test_fetchProfile_whenRepositoryThrows_doesNotChangeExistingProfile() async {
        // Arrange
        let supabase = makeSupabaseClient()
        let auth = MockAuthService()

        let profiles = MockProfileRepository()
        profiles.fetchMyProfileError = TestError.boom

        let sut = SessionStore(supabase: supabase, auth: auth, profiles: profiles)
        sut.profile = ProfileFixtures.noah

        // Act
        do {
            try await sut.fetchProfile()
            XCTFail("Expected error")
        } catch {
            // expected
        }

        // Assert
        XCTAssertEqual(profiles.fetchMyProfileCallCount, 1)
        XCTAssertEqual(sut.profile, ProfileFixtures.noah)
    }

    func test_signOut_whenCalled_clearsSessionState_andProfile() async throws {
        // Arrange
        let supabase = makeSupabaseClient()
        let auth = MockAuthService()
        let profiles = MockProfileRepository()

        let sut = SessionStore(supabase: supabase, auth: auth, profiles: profiles)
        sut.profile = ProfileFixtures.anna

        // Act
        try await sut.signOut()

        // Assert
        XCTAssertEqual(auth.signOutCallCount, 1)
        XCTAssertNil(sut.profile)
        XCTAssertNil(sut.userID)
        XCTAssertNil(sut.sessionUser)
    }
}
