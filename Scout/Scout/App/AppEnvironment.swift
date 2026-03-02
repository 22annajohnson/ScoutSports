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
  }
}
