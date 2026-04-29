//
//  GlassChip.swift
//  Scout
//
//  Created by Codex on 4/1/26.
//

import SwiftUI

struct GlassChip: View {
    enum Style {
        case neutral
        case accent
        case selected
    }

    let title: String
    var systemImage: String? = nil
    var style: Style = .neutral
    var isEmphasized: Bool = false

    var body: some View {
        HStack(spacing: ScoutLayout.Spacing.xs) {
            if let systemImage {
                Image(systemName: systemImage)
                    .font(.system(size: 12, weight: .semibold))
            }

            Text(title)
                .font(.scoutPill)
                .lineLimit(1)
                .minimumScaleFactor(0.92)
        }
        .foregroundStyle(foregroundStyle)
        .padding(.horizontal, ScoutLayout.Spacing.md)
        .padding(.vertical, ScoutLayout.Spacing.sm)
        .fixedSize(horizontal: true, vertical: false)
        .background(background)
        .overlay(stroke)
        .scoutPulseHighlight(isActive: isEmphasized)
        .animation(ScoutMotion.selection, value: style)
    }

    private var foregroundStyle: Color {
        switch style {
        case .selected:
            return .scoutTextOnAccent
        case .neutral, .accent:
            return .scoutTextPrimary
        }
    }

    @ViewBuilder
    private var background: some View {
        Capsule()
            .fill(backgroundFill)
            .background(.ultraThinMaterial, in: Capsule())
    }

    private var backgroundFill: some ShapeStyle {
        switch style {
        case .neutral:
            return AnyShapeStyle(Color.scoutGlassFill)
        case .accent:
            return AnyShapeStyle(Color.scoutSurfaceElevated)
        case .selected:
            return AnyShapeStyle(ScoutTheme.accentGradient)
        }
    }

    private var stroke: some View {
        Capsule()
            .stroke(strokeColor, lineWidth: style == .selected ? ScoutLayout.Stroke.emphasis : ScoutLayout.Stroke.hairline)
    }

    private var strokeColor: Color {
        switch style {
        case .selected:
            return .scoutOnImageStroke
        case .neutral, .accent:
            return .scoutGlassStroke
        }
    }
}

#Preview("Glass Chips") {
    ZStack {
        ScoutTheme.screenBackground.ignoresSafeArea()

        VStack(spacing: ScoutLayout.Spacing.md) {
            GlassChip(title: "2.1 mi away")
            GlassChip(title: "92 Match", systemImage: "bolt.fill", style: .accent)
            GlassChip(title: "Tue/Thu Nights", systemImage: "checkmark", style: .selected, isEmphasized: true)
        }
        .padding()
    }
}
