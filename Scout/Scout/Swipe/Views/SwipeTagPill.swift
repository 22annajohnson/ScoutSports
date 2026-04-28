//
//  SwipeTagPill.swift
//  Scout
//
//  Created by Codex on 4/27/26.
//

import SwiftUI

struct SwipeTagPill: View {
    let item: SwipeCardTagItem
    var minHeight: CGFloat = 36

    var body: some View {
        Text(item.title)
            .font(.scoutPill)
            .foregroundStyle(foregroundColor)
            .lineLimit(1)
            .minimumScaleFactor(0.84)
            .frame(maxWidth: .infinity, minHeight: minHeight)
            .padding(.horizontal, ScoutSpacing.sm)
            .background(
                Capsule()
                    .fill(backgroundFill)
                    .background(.ultraThinMaterial, in: Capsule())
            )
            .overlay(
                Capsule()
                    .stroke(borderColor, lineWidth: ScoutStroke.hairline)
            )
    }

    private var foregroundColor: Color {
        switch item.style {
        case .neutral:
            return .scoutTextPrimary
        case .accent, .info:
            return .white.opacity(0.94)
        }
    }

    private var backgroundFill: some ShapeStyle {
        switch item.style {
        case .neutral:
            return AnyShapeStyle(Color.scoutSwipeOverlaySurface)
        case .accent:
            return AnyShapeStyle(
                LinearGradient(
                    colors: [
                        Color.scoutAccentStart.opacity(0.30),
                        Color.scoutAccentStart.opacity(0.16)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
        case .info:
            return AnyShapeStyle(
                LinearGradient(
                    colors: [
                        Color.scoutAccentEnd.opacity(0.24),
                        Color.scoutAccentEnd.opacity(0.12)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
        }
    }

    private var borderColor: Color {
        switch item.style {
        case .neutral:
            return Color.scoutAccentStart.opacity(0.18)
        case .accent:
            return Color.scoutAccentStart.opacity(0.34)
        case .info:
            return Color.scoutAccentEnd.opacity(0.30)
        }
    }
}
