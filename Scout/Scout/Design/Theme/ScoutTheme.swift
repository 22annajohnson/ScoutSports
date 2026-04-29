//
//  ScoutTheme.swift
//  Scout
//
//  Created by Codex on 4/1/26.
//

import SwiftUI

enum ScoutTheme {
    static let accentGradient = LinearGradient(
        colors: [.scoutAccentStart, .scoutAccentEnd],
        startPoint: .leading,
        endPoint: .trailing
    )

    static let accentRadialGlow = RadialGradient(
        colors: [
            Color.scoutAccentEnd.opacity(0.45),
            Color.scoutAccentStart.opacity(0.18),
            Color.clear
        ],
        center: .center,
        startRadius: 20,
        endRadius: 160
    )

    static let screenBackground = LinearGradient(
        colors: [.scoutBackground, .scoutSurface],
        startPoint: .top,
        endPoint: .bottom
    )
}
