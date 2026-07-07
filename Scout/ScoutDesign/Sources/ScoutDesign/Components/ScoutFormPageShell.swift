//
//  ScoutFormPageShell.swift
//  Scout
//
//  Created by Codex on 4/1/26.
//

import SwiftUI

public struct ScoutFormPageShell<Header: View, Content: View, Footer: View>: View {
    let header: Header
    let content: Content
    let footer: Footer

    public init(
        @ViewBuilder header: () -> Header,
        @ViewBuilder content: () -> Content,
        @ViewBuilder footer: () -> Footer
    ) {
        self.header = header()
        self.content = content()
        self.footer = footer()
    }

    public var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: ScoutLayout.Spacing.xl) {
                    header
                    content
                }
                .padding(.horizontal, ScoutLayout.Spacing.xl)
                .padding(.top, ScoutLayout.Spacing.xl)
                .padding(.bottom, ScoutLayout.Spacing.xxl)
            }

            footer
        }
        .background(ScoutTheme.screenBackground.ignoresSafeArea())
    }
}

#Preview("Form Page Shell") {
    ScoutFormPageShell {
        ScoutPageHeader(
            eyebrow: "Onboarding",
            title: "Play Style",
            subtitle: "Choose the style that best represents how you want to play."
        ) {
            GlassChip(title: "2/4")
        }
    } content: {
        GlassCard {
            ScoutSection(title: "Pick your style") {
                VStack(spacing: ScoutLayout.Spacing.sm) {
                    ScoutSelectionRow(title: "Casual", subtitle: "Meet people and keep it light", isSelected: false)
                    ScoutSelectionRow(title: "Competitive", subtitle: "Looking for stronger games", isSelected: true)
                    ScoutSelectionRow(title: "Drills / practice", subtitle: "Skill growth first", isSelected: false)
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
}
