//
//  AppEnvironment.swift
//  Scout
//
//  Created by Anna on 2/26/26.
//

import Foundation
import Supabase

final class AppEnvironment {
  static let shared = AppEnvironment()

  let supabase: SupabaseClient
  let authService: AuthProviding
  let profileRepository: ProfileProviding
  let imageUploadService: ImageUploadProviding

  private init() {
      let options = SupabaseClientOptions(
        auth: SupabaseClientOptions.AuthOptions(
            emitLocalSessionAsInitialSession: true
        )
      )
    supabase = SupabaseClient(
      supabaseURL: AppConfig.supabaseURL,
      supabaseKey: AppConfig.supabaseAnonKey,
      options: options
    )

    authService = AuthService(supabase: supabase)
    profileRepository = ProfileRepository(supabase: supabase)
    imageUploadService = ImageUploadService(
      supabase: supabase,
      projectURL: SupabaseConfig.url,
      bucket: "profile-photos"
    )
  }

  func makeSessionStore() -> SessionStore {
    SessionStore(
      supabase: supabase,
      auth: authService,
      profiles: profileRepository
    )
  }

  @MainActor
  func makeProfileBuilderViewModel(userIDProvider: @escaping () -> UUID?) -> ProfileBuilderViewModel {
    ProfileBuilderViewModel(
      mode: .requiredForMatching,
      profileRepository: profileRepository,
      imageUploadService: imageUploadService,
      userIDProvider: userIDProvider
    )
  }
}
