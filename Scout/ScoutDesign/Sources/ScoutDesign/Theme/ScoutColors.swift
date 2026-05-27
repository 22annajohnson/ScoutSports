//
//  ScoutColors.swift
//  Scout
//
//  Created by Codex on 4/1/26.
//

import SwiftUI

public extension Color {
    private static func scoutAsset(_ name: String) -> Color {
        Color(name, bundle: .module)
    }

    // MARK: Semantic Theme Tokens

    static let scoutBackground = scoutAsset("BackgroundColor")
    static let scout = scoutAsset("ScoutColor")
    static let scoutSurface = scoutAsset("CardBackgroundColor")
    static let scoutSurfaceElevated = scoutAsset("SurfaceElevatedColor")
    static let scoutGlassFill = scoutAsset("GlassFillColor")
    static let scoutGlassStroke = scoutAsset("GlassStrokeColor")
    static let scoutDivider = scoutAsset("GlassStrokeColor")
    static let scoutTextPrimary = scoutAsset("PrimaryTextColor")
    static let scoutTextSecondary = scoutAsset("SecondaryTextColor")
    static let scoutTextOnAccent = scoutAsset("ContrastTextColor")
    static let scoutAccentStart = scoutAsset("SecondaryAccentColor")
    static let scoutAccentEnd = scoutAsset("AccentColor")
    static let scoutHighlight = scoutAsset("VibeColor")
    static let scoutSwipeOverlaySurface = scoutAsset("SwipeOverlaySurfaceColor")
    static let scoutSwipeOverlayStroke = scoutAsset("SwipeOverlayStrokeColor")
    static let scoutSwipeOverlayTrack = scoutAsset("SwipeOverlayTrackColor")
    static let scoutSuccess = scoutAsset("SuccessColor")
    static let scoutWarning = scoutAsset("WarningColor")
    static let scoutDanger = scoutAsset("DangerColor")
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
    static let scoutFeedHeaderBackground = Color.scoutBackground
    static let scoutFeedCardFill = Color.scoutGlassFill.opacity(0.78)
    static let scoutFeedCardStroke = Color.scoutGlassStroke.opacity(0.9)
    static let scoutFeedFilterFill = Color.scoutGlassFill.opacity(0.62)
    static let scoutFeedSelectedFill = Color.scoutAccentEnd.opacity(0.12)
    static let scoutFeedSelectedStroke = Color.scoutAccentStart.opacity(0.5)
    static let scoutFeedImagePlaceholder = Color.scoutSwipeOverlaySurface
    static let scoutGradientViolet = scoutAsset("GradientVioletColor")
    static let scoutGradientCyan = scoutAsset("GradientCyanColor")
    static let scoutGradientEmerald = scoutAsset("GradientEmeraldColor")
    static let scoutGradientSky = scoutAsset("GradientSkyColor")
    static let scoutGradientFuchsia = scoutAsset("GradientFuchsiaColor")
    static let scoutGradientBlue = scoutAsset("GradientBlueColor")
    static let scoutGradientOrange = scoutAsset("GradientOrangeColor")
    static let scoutGradientPink = scoutAsset("GradientPinkColor")
    static let scoutGradientAmber = scoutAsset("GradientAmberColor")
    static let scoutGradientTangerine = scoutAsset("GradientTangerineColor")
    static let scoutGradientPeriwinkle = scoutAsset("GradientPeriwinkleColor")
    static let scoutGradientCoral = scoutAsset("GradientCoralColor")
    static let scoutAchievementCream = scoutAsset("AchievementCreamColor")
}
