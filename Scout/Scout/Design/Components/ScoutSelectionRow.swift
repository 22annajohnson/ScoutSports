//
//  ScoutSelectionRow.swift
//  Scout
//
//  Created by Codex on 4/1/26.
//

import SwiftUI

struct ScoutSelectionRow: View {
    let title: String
    var subtitle: String? = nil
    var isSelected: Bool

    var body: some View {
        HStack(spacing: ScoutSpacing.md) {
            VStack(alignment: .leading, spacing: ScoutSpacing.xxs) {
                Text(title)
                    .font(.scoutBodyEmphasis)
                    .foregroundStyle(Color.scoutTextPrimary)

                if let subtitle {
                    Text(subtitle)
                        .font(.scoutCaption)
                        .foregroundStyle(Color.scoutTextSecondary)
                }
            }

            Spacer()

            ZStack {
                Circle()
                    .stroke(isSelected ? Color.clear : Color.scoutGlassStroke, lineWidth: ScoutStroke.hairline)
                    .fill(isSelected ? AnyShapeStyle(ScoutTheme.accentGradient) : AnyShapeStyle(Color.clear))

                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(Color.scoutTextOnAccent)
                }
            }
            .frame(width: 28, height: 28)
        }
        .padding(.horizontal, ScoutSpacing.lg)
        .padding(.vertical, ScoutSpacing.md)
        .background(
            RoundedRectangle(cornerRadius: ScoutRadius.md, style: .continuous)
                .fill(isSelected ? Color.scoutSurfaceElevated : Color.scoutGlassFill)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: ScoutRadius.md, style: .continuous))
        )
        .overlay(
            RoundedRectangle(cornerRadius: ScoutRadius.md, style: .continuous)
                .stroke(isSelected ? Color.scoutAccentStart.opacity(0.55) : Color.scoutGlassStroke, lineWidth: isSelected ? ScoutStroke.emphasis : ScoutStroke.hairline)
        )
    }
}

#Preview("Selection Rows") {
    ZStack {
        ScoutTheme.screenBackground.ignoresSafeArea()

        VStack(spacing: ScoutSpacing.md) {
            ScoutSelectionRow(title: "Casual", subtitle: "Meet people and keep it light", isSelected: false)
            ScoutSelectionRow(title: "Competitive", subtitle: "Looking for strong games", isSelected: true)
        }
        .padding()
    }
}
