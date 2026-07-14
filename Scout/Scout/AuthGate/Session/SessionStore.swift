//
//  SessionStore.swift
//  Scout
//
//  Created by Anna on 2/25/26.
//

import Foundation
import Observation
import Supabase

@MainActor
@Observable
final class SessionStore {
    private let supabase: SupabaseClient
    private let auth: AuthProviding
    private let profiles: ProfileProviding
    
    private(set) var sessionUser: SessionUser?
    private(set) var userID: UUID?
    private(set) var authenticatedEmail: String?
    var profile: Profile?
    var isLoading = true
    
    private var hasLoadedInitialSession = false
    
    init(
        supabase: SupabaseClient,
        auth: AuthProviding? = nil,
        profiles: ProfileProviding? = nil
    ) {
        self.supabase = supabase
        self.auth = auth ?? AuthService(supabase: supabase)
        self.profiles = profiles ?? ProfileRepository(supabase: supabase)
    }
    
    private func updateSessionFromCurrentUser() {
        if let current = supabase.auth.currentUser {
            userID = current.id
            authenticatedEmail = current.email
            sessionUser = SessionUser(id: current.id, email: current.email)
        } else {
            userID = nil
            authenticatedEmail = nil
            sessionUser = nil
        }
    }
    
    func loadInitialSessionIfNeeded() async {
        guard !hasLoadedInitialSession else { return }
        hasLoadedInitialSession = true
        await loadInitialSession()
    }

    func loadInitialSession() async {
        updateSessionFromCurrentUser()
        if sessionUser != nil {
            try? await fetchProfile()
        }
        isLoading = false
    }
    
    func signIn(email: String, password: String) async throws {
        try await auth.signIn(email: email, password: password)
        updateSessionFromCurrentUser()
        if userID != nil && authenticatedEmail == nil {
            authenticatedEmail = email
        }
        try await fetchProfile()
    }
    
    func signUp(email: String, password: String) async throws {
        try await auth.signUp(email: email, password: password)
        updateSessionFromCurrentUser()
        if userID != nil && authenticatedEmail == nil {
            authenticatedEmail = email
        }
        try await fetchProfile()
    }
    
    func signOut() async throws {
        try await auth.signOut()
        updateSessionFromCurrentUser() // clears sessionUser/userID
        profile = nil
    }
    
    func fetchProfile() async throws {
        profile = try await profiles.fetchMyProfile()
    }

    var canAccessDesignFactory: Bool {
        DesignFactoryAccess.canAccess(
            isAuthenticated: userID != nil,
            email: authenticatedEmail
        )
    }
}

// MARK: - Domain Session Model

/// Lightweight domain representation of an authenticated user.
struct SessionUser: Equatable {
    let id: UUID
    let email: String?
}
