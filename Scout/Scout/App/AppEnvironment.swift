//
//  AppEnvironment.swift
//  Scout
//
//  Created by Anna on 2/26/26.
//

import Foundation
import Supabase
import SwiftUI

final class AppEnvironment {
  static let shared = AppEnvironment()

  let supabase: SupabaseClient
  let authService: AuthProviding
  let profileRepository: ProfileProviding
  let matchSignalsRepository: PlayerMatchSignalsProviding
  let profileRelationshipsRepository: PlayerProfileRelationshipsProviding
  let imageUploadService: ImageUploadProviding
  let swipeCardProvider: SwipeCardProviding

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
    let profileRepository = ProfileRepository(supabase: supabase)
    self.profileRepository = profileRepository
    self.matchSignalsRepository = profileRepository
    self.profileRelationshipsRepository = profileRepository
    imageUploadService = ImageUploadService(
      supabase: supabase,
      projectURL: SupabaseConfig.url,
      bucket: "profile-photos"
    )
    swipeCardProvider = MockSwipeCardProvider()
  }

  func makeSessionStore() -> SessionStore {
    SessionStore(
      supabase: supabase,
      auth: authService,
      profiles: profileRepository
    )
  }

  @MainActor
  func makeOnboardingViewModel() -> OnboardingViewModel {
    OnboardingViewModel(
      profileRepository: profileRepository,
      imageUploadService: imageUploadService
    )
  }

  @MainActor
  func makeProfileBuilderViewModel(userIDProvider: @escaping () -> UUID?) -> ProfileBuilderViewModel {
    ProfileBuilderViewModel(
      mode: .requiredForMatching,
      profileRepository: profileRepository,
      matchSignalsRepository: matchSignalsRepository,
      profileRelationshipsRepository: profileRelationshipsRepository,
      imageUploadService: imageUploadService,
      userIDProvider: userIDProvider
    )
  }

  @MainActor
  func makeSwipeDeckViewModel(session: SessionStore) -> SwipeDeckViewModel {
    SwipeDeckViewModel(
      cardProvider: swipeCardProvider,
      session: session
    )
  }
}

extension AppEnvironment {
  static var preview: AppEnvironment { shared }
}

private struct AppEnvironmentKey: EnvironmentKey {
  static let defaultValue = AppEnvironment.shared
}

extension EnvironmentValues {
  var appEnvironment: AppEnvironment {
    get { self[AppEnvironmentKey.self] }
    set { self[AppEnvironmentKey.self] = newValue }
  }
}
