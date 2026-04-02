//
//  ScoutTheme.swift
//  Scout
//
//  Created by Codex on 4/1/26.
//

import SwiftUI

enum ScoutSpacing {
    static let xxxs: CGFloat = 4
    static let xxs: CGFloat = 6
    static let xs: CGFloat = 8
    static let sm: CGFloat = 12
    static let md: CGFloat = 16
    static let lg: CGFloat = 20
    static let xl: CGFloat = 24
    static let xxl: CGFloat = 32
    static let xxxl: CGFloat = 40
}

enum ScoutRadius {
    static let sm: CGFloat = 12
    static let md: CGFloat = 18
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
    static let capsule: CGFloat = 999
}

enum ScoutStroke {
    static let hairline: CGFloat = 1
    static let emphasis: CGFloat = 1.5
    static let selected: CGFloat = 2
}

enum ScoutBlur {
    static let glass: CGFloat = 12
    static let heroGlow: CGFloat = 18
    static let backgroundWash: CGFloat = 28
}

enum ScoutShadow {
    static let soft = Color.black.opacity(0.18)
    static let glow = Color.scoutAccentEnd.opacity(0.35)
    static let raisedRadius: CGFloat = 18
    static let raisedY: CGFloat = 10
}

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
