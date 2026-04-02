//
//  DesignFoundationPreview.swift
//  Scout
//
//  Created by Codex on 4/1/26.
//

import SwiftUI

private struct DesignFoundationPreview: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: ScoutSpacing.xl) {
                titleBlock
                colorSection
                typeSection
                spacingSection
            }
            .padding(ScoutSpacing.xl)
        }
        .background(ScoutTheme.screenBackground.ignoresSafeArea())
    }

    private var titleBlock: some View {
        VStack(alignment: .leading, spacing: ScoutSpacing.sm) {
            Text("SCOUT DESIGN")
                .font(.scoutLabelCaps)
                .tracking(3)
                .foregroundStyle(Color.scoutTextSecondary)

            Text("Foundation Tokens")
                .font(.scoutDisplayCompact)
                .foregroundStyle(Color.scoutTextPrimary)

            Text("Phase 1 establishes the palette, type hierarchy, and layout constants for the glass-forward UI system.")
                .font(.scoutBody)
                .foregroundStyle(Color.scoutTextSecondary)

            Capsule()
                .fill(ScoutTheme.accentGradient)
                .frame(width: 140, height: 10)
                .overlay {
                    Capsule()
                        .stroke(Color.scoutGlassStroke, lineWidth: ScoutStroke.hairline)
                }
        }
        .padding(ScoutSpacing.lg)
        .background(
            RoundedRectangle(cornerRadius: ScoutRadius.lg, style: .continuous)
                .fill(Color.scoutGlassFill)
        )
        .overlay {
            RoundedRectangle(cornerRadius: ScoutRadius.lg, style: .continuous)
                .stroke(Color.scoutGlassStroke, lineWidth: ScoutStroke.hairline)
        }
    }

    private var colorSection: some View {
        VStack(alignment: .leading, spacing: ScoutSpacing.md) {
            sectionLabel("Color Tokens")

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: ScoutSpacing.md) {
                colorSwatch(name: "Background", color: .scoutBackground)
                colorSwatch(name: "Surface", color: .scoutSurface)
                colorSwatch(name: "Glass Fill", color: .scoutGlassFill)
                colorSwatch(name: "Glass Stroke", color: .scoutGlassStroke)
                colorSwatch(name: "Text Primary", color: .scoutTextPrimary)
                colorSwatch(name: "Text Secondary", color: .scoutTextSecondary)
                colorSwatch(name: "Accent Start", color: .scoutAccentStart)
                colorSwatch(name: "Accent End", color: .scoutAccentEnd)
                colorSwatch(name: "Highlight", color: .scoutHighlight)
                colorSwatch(name: "Success", color: .scoutSuccess)
            }
        }
    }

    private var typeSection: some View {
        VStack(alignment: .leading, spacing: ScoutSpacing.md) {
            sectionLabel("Type Scale")

            typeRow(name: "Display", sample: "Find your next match", font: .scoutDisplayCompact)
            typeRow(name: "Hero Title", sample: "Sophie 27", font: .scoutHeroTitle)
            typeRow(name: "Title", sample: "Play Style", font: .scoutTitle)
            typeRow(name: "Section", sample: "Best overlap", font: .scoutSectionTitle)
            typeRow(name: "Body", sample: "Aggressive at the net. Looking for competitive games.", font: .scoutBody)
            typeRow(name: "Pill", sample: "Tue/Thu Nights", font: .scoutPill)
            typeRow(name: "Label Caps", sample: "MATCHUP", font: .scoutLabelCaps)
            typeRow(name: "Number XL", sample: "100", font: .scoutNumberXL)
        }
    }

    private var spacingSection: some View {
        VStack(alignment: .leading, spacing: ScoutSpacing.md) {
            sectionLabel("Spacing + Radius")

            HStack(alignment: .bottom, spacing: ScoutSpacing.md) {
                spacingPill(label: "12", width: ScoutSpacing.sm * 6)
                spacingPill(label: "16", width: ScoutSpacing.md * 6)
                spacingPill(label: "24", width: ScoutSpacing.xl * 4)
            }

            HStack(spacing: ScoutSpacing.md) {
                radiusCard(label: "18", radius: ScoutRadius.md)
                radiusCard(label: "24", radius: ScoutRadius.lg)
                radiusCard(label: "32", radius: ScoutRadius.xl)
            }
        }
    }

    private func sectionLabel(_ label: String) -> some View {
        Text(label.uppercased())
            .font(.scoutLabelCaps)
            .tracking(3)
            .foregroundStyle(Color.scoutTextSecondary)
    }

    private func colorSwatch(name: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: ScoutSpacing.sm) {
            RoundedRectangle(cornerRadius: ScoutRadius.md, style: .continuous)
                .fill(color)
                .frame(height: 88)
                .overlay {
                    RoundedRectangle(cornerRadius: ScoutRadius.md, style: .continuous)
                        .stroke(Color.scoutGlassStroke, lineWidth: ScoutStroke.hairline)
                }

            Text(name)
                .font(.scoutLabel)
                .foregroundStyle(Color.scoutTextPrimary)
        }
        .padding(ScoutSpacing.md)
        .background(
            RoundedRectangle(cornerRadius: ScoutRadius.lg, style: .continuous)
                .fill(Color.scoutGlassFill)
        )
        .overlay {
            RoundedRectangle(cornerRadius: ScoutRadius.lg, style: .continuous)
                .stroke(Color.scoutGlassStroke, lineWidth: ScoutStroke.hairline)
        }
    }

    private func typeRow(name: String, sample: String, font: Font) -> some View {
        VStack(alignment: .leading, spacing: ScoutSpacing.xs) {
            Text(name.uppercased())
                .font(.scoutMicro)
                .tracking(2)
                .foregroundStyle(Color.scoutTextSecondary)

            Text(sample)
                .font(font)
                .foregroundStyle(Color.scoutTextPrimary)
                .lineLimit(2)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(ScoutSpacing.md)
        .background(
            RoundedRectangle(cornerRadius: ScoutRadius.md, style: .continuous)
                .fill(Color.scoutGlassFill)
        )
        .overlay {
            RoundedRectangle(cornerRadius: ScoutRadius.md, style: .continuous)
                .stroke(Color.scoutGlassStroke, lineWidth: ScoutStroke.hairline)
        }
    }

    private func spacingPill(label: String, width: CGFloat) -> some View {
        VStack(alignment: .leading, spacing: ScoutSpacing.xs) {
            Capsule()
                .fill(ScoutTheme.accentGradient)
                .frame(width: width, height: 18)
            Text(label)
                .font(.scoutLabel)
                .foregroundStyle(Color.scoutTextSecondary)
        }
    }

    private func radiusCard(label: String, radius: CGFloat) -> some View {
        VStack(spacing: ScoutSpacing.sm) {
            RoundedRectangle(cornerRadius: radius, style: .continuous)
                .fill(Color.scoutSurfaceElevated)
                .frame(width: 88, height: 64)
                .overlay {
                    RoundedRectangle(cornerRadius: radius, style: .continuous)
                        .stroke(Color.scoutGlassStroke, lineWidth: ScoutStroke.hairline)
                }

            Text(label)
                .font(.scoutLabel)
                .foregroundStyle(Color.scoutTextSecondary)
        }
    }
}

#Preview("Design Foundation") {
    DesignFoundationPreview()
}
