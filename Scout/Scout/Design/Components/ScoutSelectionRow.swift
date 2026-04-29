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
        HStack(spacing: ScoutLayout.Spacing.md) {
            VStack(alignment: .leading, spacing: ScoutLayout.Spacing.xxs) {
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
                    .stroke(isSelected ? Color.clear : Color.scoutGlassStroke, lineWidth: ScoutLayout.Stroke.hairline)
                    .fill(isSelected ? AnyShapeStyle(ScoutTheme.accentGradient) : AnyShapeStyle(Color.clear))

                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(Color.scoutTextOnAccent)
                }
            }
            .frame(width: 28, height: 28)
        }
        .padding(.horizontal, ScoutLayout.Spacing.lg)
        .padding(.vertical, ScoutLayout.Spacing.md)
        .scoutGlassSelectableSurface(isSelected: isSelected, cornerRadius: ScoutLayout.Radius.md)
    }
}

#Preview("Selection Rows") {
    ZStack {
        ScoutTheme.screenBackground.ignoresSafeArea()

        VStack(spacing: ScoutLayout.Spacing.md) {
            ScoutSelectionRow(title: "Casual", subtitle: "Meet people and keep it light", isSelected: false)
            ScoutSelectionRow(title: "Competitive", subtitle: "Looking for strong games", isSelected: true)
        }
        .padding()
    }
}
