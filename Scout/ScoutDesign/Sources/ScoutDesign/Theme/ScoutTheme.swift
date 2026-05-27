//
//  ScoutTheme.swift
//  Scout
//
//  Created by Codex on 4/1/26.
//

import SwiftUI

public enum ScoutTheme {
    public static let accentGradient = LinearGradient(
        colors: [.scoutAccentStart, .scoutAccentEnd],
        startPoint: .leading,
        endPoint: .trailing
    )

    public static let accentRadialGlow = RadialGradient(
        colors: [
            Color.scoutAccentEnd.opacity(0.45),
            Color.scoutAccentStart.opacity(0.18),
            Color.clear
        ],
        center: .center,
        startRadius: 20,
        endRadius: 160
    )

    public static let screenBackground = LinearGradient(
        colors: [.scoutBackground, .scoutSurface],
        startPoint: .top,
        endPoint: .bottom
    )
}

public enum ScoutChrome {
    public static let bottomBarExpandedHeight: CGFloat = 74
    public static let bottomBarCondensedHeight: CGFloat = 56
    public static let bottomBarReservedHeight: CGFloat = 112
}
