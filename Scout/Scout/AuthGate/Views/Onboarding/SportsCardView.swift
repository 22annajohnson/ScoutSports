//
//  SportsCardView.swift
//  Scout
//
//  Created by Anna on 2/26/26.
//

import SwiftUI
// MARK: - Sport Card

struct SportCard: View {
    let title: String
    let subtitle: String?
    let isSelected: Bool
    let isEnabled: Bool
    let onTap: () -> Void

    var body: some View {
        Button {
            if isEnabled { onTap() }
        } label: {
            ZStack(alignment: .topTrailing) {
                RoundedRectangle(cornerRadius: ScoutRadius.lg, style: .continuous)
                    .fill(isSelected ? Color.scoutSurfaceElevated : Color.scoutGlassFill)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: ScoutRadius.lg, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: ScoutRadius.lg, style: .continuous)
                            .stroke(isSelected ? Color.scoutAccentStart.opacity(0.55) : Color.scoutGlassStroke, lineWidth: isSelected ? ScoutStroke.emphasis : ScoutStroke.hairline)
                    )

                VStack(alignment: .leading, spacing: ScoutSpacing.sm) {
                    Text(title)
                        .font(.scoutSectionTitle)
                        .foregroundStyle(Color.scoutTextPrimary)

                    if let subtitle {
                        Text(subtitle)
                            .font(.scoutCaption)
                            .foregroundStyle(Color.scoutTextSecondary)
                    }

                    Spacer(minLength: 0)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(ScoutSpacing.lg)

                if isSelected {
                    GlassChip(title: "Selected", systemImage: "checkmark", style: .selected)
                        .padding(ScoutSpacing.sm)
                } else if !isEnabled {
                    GlassChip(title: "Coming soon")
                        .padding(ScoutSpacing.sm)
                }
            }
            .frame(maxWidth: .infinity, minHeight: 148)
            .opacity(isEnabled ? 1.0 : 0.7)
        }
        .buttonStyle(.plain)
    }
}
