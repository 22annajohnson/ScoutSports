//
//  LayoutGalleryPreview.swift
//  Scout
//
//  Created by Codex on 4/1/26.
//

import SwiftUI

private struct LayoutGalleryPreview: View {
    var body: some View {
        TabView {
            ScoutFormPageShell {
                ScoutPageHeader(
                    eyebrow: "Onboarding",
                    title: "Play Style",
                    subtitle: "Standardized form-flow shell with shared spacing, header hierarchy, and footer treatment."
                ) {
                    GlassChip(title: "2/4")
                }
            } content: {
                VStack(spacing: ScoutLayout.Spacing.xl) {
                    GlassCard {
                        ScoutSection(title: "Pick your style") {
                            VStack(spacing: ScoutLayout.Spacing.sm) {
                                ScoutSelectionRow(title: "Casual", subtitle: "Fun-first and social", isSelected: false)
                                ScoutSelectionRow(title: "Competitive", subtitle: "Stronger games and clear intent", isSelected: true)
                            }
                        }
                    }

                    GlassCard {
                        ScoutSection(
                            eyebrow: "Match Style",
                            title: "How you show up",
                            subtitle: "Consistent section hierarchy within longer scrolling flows."
                        ) {
                            HStack(spacing: ScoutLayout.Spacing.md) {
                                ScoutStatTile(title: "Competitiveness", value: "3")
                                ScoutStatTile(title: "Friendliness", value: "3")
                            }
                        }
                    }
                }
            } footer: {
                ScoutFooterBar {
                    Button("Back") {}
                        .buttonStyle(ScoutSecondaryGlassButtonStyle())

                    Button("Next") {}
                        .buttonStyle(ScoutPrimaryButtonStyle())
                }
            }
            .tabItem { Text("Form") }

            ScoutHeroLayout {
                RoundedRectangle(cornerRadius: 0)
                    .fill(
                        LinearGradient(
                            colors: [Color.scoutAccentStart.opacity(0.85), Color.scoutAccentEnd.opacity(0.65)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            } topBar: {
                HStack {
                    GlassChip(title: "2.1 mi away")
                    Spacer()
                    GlassChip(title: "92 Match", style: .accent)
                }
            } overlay: {
                VStack(alignment: .leading, spacing: ScoutLayout.Spacing.md) {
                    Text("Find your next match")
                        .font(.scoutLabelCaps)
                        .tracking(3)
                        .foregroundStyle(Color.scoutOnImageTextSoft)

                    Text("Sophie 27")
                        .font(.scoutDisplayCompact)
                        .foregroundStyle(Color.scoutOnImageTextPrimary)

                    HStack(spacing: ScoutLayout.Spacing.sm) {
                        GlassChip(title: "4.7 Competitive")
                        GlassChip(title: "Reliable")
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            } bottom: {
                VStack(spacing: ScoutLayout.Spacing.xl) {
                    HStack(spacing: ScoutLayout.Spacing.md) {
                        ScoutStatTile(title: "Skill", value: "4.3")
                        ScoutStatTile(title: "Matches", value: "38")
                        ScoutStatTile(title: "Win Rate", value: "71%")
                    }
                    .padding(.horizontal, ScoutLayout.Spacing.lg)
                    .padding(.top, ScoutLayout.Spacing.xl)

                    ScoutActionDock()
                        .padding(.horizontal, ScoutLayout.Spacing.lg)
                        .padding(.bottom, ScoutLayout.Spacing.xl)
                }
            }
            .tabItem { Text("Hero") }
        }
    }
}

#Preview("Layout Gallery") {
    LayoutGalleryPreview()
}
