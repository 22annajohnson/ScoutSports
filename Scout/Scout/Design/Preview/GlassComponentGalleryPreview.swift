//
//  GlassComponentGalleryPreview.swift
//  Scout
//
//  Created by Codex on 4/1/26.
//

import SwiftUI

private struct GlassComponentGalleryPreview: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: ScoutSpacing.xl) {
                Text("COMPONENT KIT")
                    .font(.scoutLabelCaps)
                    .tracking(3)
                    .foregroundStyle(Color.scoutTextSecondary)

                Text("Glass Primitives")
                    .font(.scoutDisplayCompact)
                    .foregroundStyle(Color.scoutTextPrimary)

                HStack(spacing: ScoutSpacing.sm) {
                    GlassChip(title: "2.1 mi away")
                    GlassChip(title: "92 Match", style: .accent)
                }

                GlassCard {
                    VStack(alignment: .leading, spacing: ScoutSpacing.md) {
                        HStack {
                            Text("How you show up")
                                .font(.scoutSectionTitle)
                                .foregroundStyle(Color.scoutTextPrimary)
                            Spacer()
                            GlassChip(title: "Selected", systemImage: "checkmark", style: .selected)
                        }

                        ScoutSelectionRow(title: "Competitive", subtitle: "Looking for stronger games", isSelected: true)
                        ScoutSelectionRow(title: "Casual", subtitle: "Fun-first and flexible", isSelected: false)
                    }
                }

                HStack(spacing: ScoutSpacing.md) {
                    ScoutStatTile(title: "Skill", value: "4.3")
                    ScoutStatTile(title: "Win Rate", value: "71%")
                }

                VStack(spacing: ScoutSpacing.md) {
                    Button("Continue") {}
                        .buttonStyle(ScoutPrimaryButtonStyle())

                    Button("Back") {}
                        .buttonStyle(ScoutSecondaryGlassButtonStyle())
                }

                ScoutActionDock()
            }
            .padding(ScoutSpacing.xl)
        }
        .background(ScoutTheme.screenBackground.ignoresSafeArea())
    }
}

#Preview("Glass Component Gallery") {
    GlassComponentGalleryPreview()
}
