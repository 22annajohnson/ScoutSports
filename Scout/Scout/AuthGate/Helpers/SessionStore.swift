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
    
    @Published var user: Supabase.User?
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
    
    func loadInitialSession() async {
        user = supabase.auth.currentUser
        if user != nil {
            try? await fetchProfile()
        }
        isLoading = false
    }
    
    func signIn(email: String, password: String) async throws {
        try await auth.signIn(email: email, password: password)
        user = supabase.auth.currentUser
        try await fetchProfile()
    }
    
    func signUp(email: String, password: String) async throws {
        try await auth.signUp(email: email, password: password)
        user = supabase.auth.currentUser
        try await fetchProfile()
    }
    
    func signOut() async throws {
        try await auth.signOut()
        user = nil
        profile = nil
    }
    
    func fetchProfile() async throws {
        profile = try await profiles.fetchMyProfile()
    }
}
