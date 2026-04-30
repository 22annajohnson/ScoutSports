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
    static let scoutTextPrimary = Color("PrimaryTextColor")
    static let scoutTextSecondary = Color("SecondaryTextColor")
    static let scoutTextOnAccent = Color.contrastText
    static let scoutAccentStart = Color.secondaryAccent
    static let scoutAccentEnd = Color.accent
    static let scoutHighlight = Color.vibe
    static let scoutSwipeOverlaySurface = Color("SwipeOverlaySurfaceColor")
    static let scoutSwipeOverlayStroke = Color("SwipeOverlayStrokeColor")
    static let scoutSwipeOverlayTrack = Color("SwipeOverlayTrackColor")
    static let scoutSuccess = Color("SuccessColor")
    static let scoutWarning = Color("WarningColor")
    static let scoutDanger = Color("DangerColor")
    static let scoutOnImageTextPrimary = Color.white
    static let scoutOnImageTextSecondary = Color.white.opacity(0.94)
    static let scoutOnImageTextMuted = Color.white.opacity(0.9)
    static let scoutOnImageTextSoft = Color.white.opacity(0.82)
    static let scoutOnImageBrand = Color.white.opacity(0.92)
    static let scoutOnImageStroke = Color.white.opacity(0.18)
    static let scoutOnImageStrokeSoft = Color.white.opacity(0.14)
    static let scoutOnImageStrokeStrong = Color.white.opacity(0.8)
    static let scoutGlassHighlight = Color.white.opacity(0.12)
    static let scoutGlassHighlightStrong = Color.white.opacity(0.22)
    static let scoutGlassHighlightSoft = Color.white.opacity(0.14)
    static let scoutScrimSoft = Color.black.opacity(0.12)
    static let scoutScrimMedium = Color.black.opacity(0.18)
    static let scoutScrimStrong = Color.black.opacity(0.28)
    static let scoutScrimHero = Color.black.opacity(0.45)
    static let scoutScrimModal = Color.black.opacity(0.95)
    static let scoutImageOverlayTop = Color.black.opacity(0.10)
    static let scoutImageOverlayBottom = Color.black.opacity(0.34)
    static let scoutShadowSoft = Color.black.opacity(0.18)
    static let scoutShadowStrong = Color.black.opacity(0.25)
    static let scoutShadowGlow = Color.scoutAccentEnd.opacity(0.35)
    static let scoutFeedHeaderBackground = Color.background
    static let scoutFeedCardFill = Color.scoutGlassFill.opacity(0.78)
    static let scoutFeedCardStroke = Color.scoutGlassStroke.opacity(0.9)
    static let scoutFeedFilterFill = Color.scoutGlassFill.opacity(0.62)
    static let scoutFeedSelectedFill = Color.scoutAccentEnd.opacity(0.12)
    static let scoutFeedSelectedStroke = Color.scoutAccentStart.opacity(0.5)
    static let scoutFeedImagePlaceholder = Color.scoutSwipeOverlaySurface
    static let scoutGradientViolet = Color("GradientVioletColor")
    static let scoutGradientCyan = Color("GradientCyanColor")
    static let scoutGradientEmerald = Color("GradientEmeraldColor")
    static let scoutGradientSky = Color("GradientSkyColor")
    static let scoutGradientFuchsia = Color("GradientFuchsiaColor")
    static let scoutGradientBlue = Color("GradientBlueColor")
    static let scoutGradientOrange = Color("GradientOrangeColor")
    static let scoutGradientPink = Color("GradientPinkColor")
    static let scoutGradientAmber = Color("GradientAmberColor")
    static let scoutGradientTangerine = Color("GradientTangerineColor")
    static let scoutGradientPeriwinkle = Color("GradientPeriwinkleColor")
    static let scoutGradientCoral = Color("GradientCoralColor")
    static let scoutAchievementCream = Color("AchievementCreamColor")
}
