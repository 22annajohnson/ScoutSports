//
//  ScoutApp.swift
//  Scout
//
//  Created by Anna on 2/19/26.
//

import SwiftUI
import ScoutDesign
import UIKit

@main
struct ScoutApp: App {
    @State private var session: SessionStore

    init() {
        // UIKit-wide tint fallback for system controllers (e.g. PhotosPicker)
        UIView.appearance().tintColor = UIColor(Color.scout)
        UINavigationBar.appearance().tintColor = UIColor(Color.scout)

        let appEnvironment = AppEnvironment.shared
        _session = State(initialValue: appEnvironment.makeSessionStore())
    }

    var body: some Scene {
        WindowGroup {
            let appEnvironment = AppEnvironment.shared

            RootView()
                .environment(\.appEnvironment, appEnvironment)
                .environment(session)
                .tint(Color.scout)
                .preferredColorScheme(.dark)
        }
    }
}
