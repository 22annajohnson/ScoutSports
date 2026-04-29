//
//  GlassCard.swift
//  Scout
//
//  Created by Codex on 4/1/26.
//

import SwiftUI

struct GlassCard<Content: View>: View {
    private let shape = RoundedRectangle(cornerRadius: ScoutLayout.Radius.lg, style: .continuous)
    private let padding: CGFloat
    private let content: Content

    init(
        padding: CGFloat = ScoutLayout.Spacing.lg,
        @ViewBuilder content: () -> Content
    ) {
        self.padding = padding
        self.content = content()
    }

    var body: some View {
        content
            .padding(padding)
            .background(cardBackground)
            .overlay(cardStroke)
            .overlay(cardHighlights)
            .shadow(
                color: Color.scoutShadowSoft,
                radius: ScoutLayout.Shadow.raisedRadius,
                x: 0,
                y: ScoutLayout.Shadow.raisedY
            )
    }

    private var cardBackground: some View {
        shape
            .fill(.ultraThinMaterial)
            .overlay {
                shape
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.scoutGlassHighlight,
                                Color.scoutGlassFill.opacity(0.92),
                                Color.scoutAccentStart.opacity(0.08)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            .overlay {
                shape
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.scoutAccentEnd.opacity(0.12),
                                Color.clear
                            ],
                            center: .topTrailing,
                            startRadius: 8,
                            endRadius: 180
                        )
                    )
            }
    }

    private var cardStroke: some View {
        shape
            .stroke(
                LinearGradient(
                    colors: [
                        Color.scoutGlassHighlightStrong,
                        Color.scoutGlassStroke,
                        Color.scoutAccentStart.opacity(0.16)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                lineWidth: ScoutLayout.Stroke.hairline
            )
    }

    private var cardHighlights: some View {
        shape
            .inset(by: 1)
            .stroke(
                LinearGradient(
                    colors: [
                        Color.scoutGlassHighlightStrong,
                        Color.clear,
                        Color.clear
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                lineWidth: 1
            )
    }
}

#Preview("Glass Card") {
    ZStack {
        ScoutTheme.screenBackground.ignoresSafeArea()

        GlassCard {
            VStack(alignment: .leading, spacing: ScoutLayout.Spacing.sm) {
                Text("MATCHUP")
                    .font(.scoutLabelCaps)
                    .tracking(3)
                    .foregroundStyle(Color.scoutTextSecondary)

                Text("Tuesday 6:30 PM")
                    .font(.scoutSectionTitle)
                    .foregroundStyle(Color.scoutTextPrimary)

                Text("Best overlap for a competitive game this week.")
                    .font(.scoutBody)
                    .foregroundStyle(Color.scoutTextSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
    }
}
