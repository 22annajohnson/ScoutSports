//
//  ScoutApp.swift
//  Scout
//
//  Created by Anna on 2/19/26.
//

import SwiftUI

@main
struct ScoutApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(model: randomMockCardViewModel())
        }
    }
}
