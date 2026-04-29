//
//  ScoutSection.swift
//  Scout
//
//  Created by Codex on 4/1/26.
//

import SwiftUI

struct ScoutSection<Content: View>: View {
    let eyebrow: String?
    let title: String
    let subtitle: String?
    let content: Content

    init(
        eyebrow: String? = nil,
        title: String,
        subtitle: String? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.eyebrow = eyebrow
        self.title = title
        self.subtitle = subtitle
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: ScoutLayout.Spacing.md) {
            VStack(alignment: .leading, spacing: ScoutLayout.Spacing.xs) {
                if let eyebrow {
                    Text(eyebrow.uppercased())
                        .font(.scoutLabelCaps)
                        .tracking(3)
                        .foregroundStyle(Color.scoutTextSecondary)
                }

                Text(title)
                    .font(.scoutSectionTitle)
                    .foregroundStyle(Color.scoutTextPrimary)

                if let subtitle {
                    Text(subtitle)
                        .font(.scoutCaption)
                        .foregroundStyle(Color.scoutTextSecondary)
                }
            }

            content
        }
    }
}

#Preview("Section") {
    ZStack {
        ScoutTheme.screenBackground.ignoresSafeArea()

        GlassCard {
            ScoutSection(
                eyebrow: "Your Match Style",
                title: "How you show up",
                subtitle: "Use shared section spacing and headings before introducing screen-specific polish."
            ) {
                VStack(spacing: ScoutLayout.Spacing.sm) {
                    ScoutSelectionRow(title: "Competitive", subtitle: "Looking for strong games", isSelected: true)
                    ScoutSelectionRow(title: "Casual", subtitle: "Fun-first and flexible", isSelected: false)
                }
            }
        }
        .padding()
    }
}
