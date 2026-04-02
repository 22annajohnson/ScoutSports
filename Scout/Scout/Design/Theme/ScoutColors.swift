//
//  ScoutColors.swift
//  Scout
//
//  Created by Codex on 4/1/26.
//

import SwiftUI

extension Color {
    // MARK: Semantic Theme Tokens

    static let scoutBackground = Color.background
    static let scoutSurface = Color.cardBackground
    static let scoutSurfaceElevated = Color("SurfaceElevatedColor")
    static let scoutGlassFill = Color("GlassFillColor")
    static let scoutGlassStroke = Color("GlassStrokeColor")
    static let scoutDivider = Color("GlassStrokeColor")
    static let scoutTextPrimary = Color.primaryText
    static let scoutTextSecondary = Color.secondaryText
    static let scoutTextOnAccent = Color.contrastText
    static let scoutAccentStart = Color.secondaryAccent
    static let scoutAccentEnd = Color.accent
    static let scoutHighlight = Color.vibe
    static let scoutSuccess = Color(red: 0.44, green: 0.88, blue: 0.66)
    static let scoutWarning = Color(red: 0.98, green: 0.76, blue: 0.34)
    static let scoutDanger = Color(red: 0.98, green: 0.42, blue: 0.48)
}
