//
//  SessionStore.swift
//  Scout
//
//  Created by Anna on 2/25/26.
//

import Combine
import Foundation
import Supabase

@MainActor
final class SessionStore: ObservableObject {
    private let supabase: SupabaseClient
    private let auth: AuthProviding
    private let profiles: ProfileProviding
    
    @Published private(set) var sessionUser: SessionUser?
    @Published private(set) var userID: UUID?
    @Published var profile: Profile?
    @Published var isLoading = true
    
    init(
        supabase: SupabaseClient,
        auth: AuthProviding? = nil,
        profiles: ProfileProviding? = nil
    ) {
        self.supabase = supabase
        self.auth = auth ?? AuthService(supabase: supabase)
        self.profiles = profiles ?? ProfileRepository(supabase: supabase)

        Task {
            await loadInitialSession()
        }
    }
    
    private func updateSessionFromCurrentUser() {
        if let current = supabase.auth.currentUser {
            userID = current.id
            sessionUser = SessionUser(id: current.id)
        } else {
            userID = nil
            sessionUser = nil
        }
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
        try await fetchProfile()
    }
    
    func signUp(email: String, password: String) async throws {
        try await auth.signUp(email: email, password: password)
        updateSessionFromCurrentUser()
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
}

// MARK: - Domain Session Model

/// Lightweight domain representation of an authenticated user.
struct SessionUser: Equatable {
    let id: UUID
}
