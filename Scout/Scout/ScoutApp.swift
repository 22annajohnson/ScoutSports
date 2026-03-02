//
//  ScoutApp.swift
//  Scout
//
//  Created by Anna on 2/19/26.
//

import SwiftUI
import UIKit

@main
struct ScoutApp: App {
    private let environment = AppEnvironment.shared
    @StateObject private var session: SessionStore

    init() {
        // UIKit-wide tint fallback for system controllers (e.g. PhotosPicker)
        UIView.appearance().tintColor = UIColor(Color.scout)
        UINavigationBar.appearance().tintColor = UIColor(Color.scout)

        let env = AppEnvironment.shared
        _session = StateObject(wrappedValue: SessionStore(supabase: env.supabase))
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(session)
                .tint(Color.scout)
        }
    }
}
