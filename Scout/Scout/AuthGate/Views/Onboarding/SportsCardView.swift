//
//  SportsCardView.swift
//  Scout
//
//  Created by Anna on 2/26/26.
//

import SwiftUI
import ScoutDesign
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
                VStack(alignment: .leading, spacing: ScoutLayout.Spacing.sm) {
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
                .padding(ScoutLayout.Spacing.lg)

                if isSelected {
                    GlassChip(title: "Selected", systemImage: "checkmark", style: .selected)
                        .padding(ScoutLayout.Spacing.sm)
                } else if !isEnabled {
                    GlassChip(title: "Coming soon")
                        .padding(ScoutLayout.Spacing.sm)
                }
            }
            .frame(maxWidth: .infinity, minHeight: 148)
            .scoutGlassSelectableSurface(isSelected: isSelected, cornerRadius: ScoutLayout.Radius.lg)
            .opacity(isEnabled ? 1.0 : 0.7)
        }
        .buttonStyle(.plain)
    }
}
