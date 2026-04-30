//
//  SwipeBestOverlapTeaser.swift
//  Scout
//
//  Created by Codex on 4/23/26.
//

import SwiftUI

struct SwipeBestOverlapTeaser: View {
    let model: Model

    private var bodyContent: some View {
        ViewThatFits(in: .horizontal) {
            HStack(alignment: .bottom, spacing: ScoutLayout.Spacing.lg) {
                tagRow

                Spacer(minLength: ScoutLayout.Spacing.md)

                scoreValue
            }

            VStack(alignment: .leading, spacing: ScoutLayout.Spacing.lg) {
                tagRow
                scoreValue
            }
        }
    }

    var body: some View {
        GlassCard(padding: ScoutLayout.Spacing.xl) {
            VStack(alignment: .leading, spacing: ScoutLayout.Spacing.lg) {
                Text(model.title.uppercased())
                    .font(.scoutLabelCaps)
                    .tracking(6)
                    .foregroundStyle(Color.scoutTextPrimary.opacity(0.9))

                bodyContent

                overlapChart
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var tagRow: some View {
        HStack(spacing: ScoutLayout.Spacing.md) {
            ForEach(model.tags) { tag in
                SwipeTagPill(item: tag)
            }
        }
    }

    private var scoreValue: some View {
        Text(model.value)
            .font(.scoutNumberXL)
            .foregroundStyle(Color.scoutTextPrimary)
            .lineLimit(1)
            .minimumScaleFactor(0.82)
            .shadow(color: Color.scoutShadowSoft, radius: 12, y: 3)
    }

    private var overlapChart: some View {
        HStack(alignment: .bottom, spacing: ScoutLayout.Spacing.md) {
            ForEach(model.bars) { bar in
                VStack(spacing: ScoutLayout.Spacing.sm) {
                    RoundedRectangle(cornerRadius: ScoutLayout.Radius.sm, style: .continuous)
                        .fill(Color.scoutSwipeOverlayTrack.opacity(0.45))
                        .frame(height: 86)
                        .overlay(alignment: .bottom) {
                            RoundedRectangle(cornerRadius: ScoutLayout.Radius.sm, style: .continuous)
                                .fill(ScoutTheme.accentGradient)
                                .frame(height: max(12, 72 * bar.value))
                                .padding(.horizontal, ScoutLayout.Spacing.xxs)
                                .padding(.bottom, ScoutLayout.Spacing.xxs)
                        }

                    Text(bar.label)
                        .font(.scoutLabel)
                        .foregroundStyle(Color.scoutTextSecondary)
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
}

extension SwipeBestOverlapTeaser {
    struct Model {
        let title: String
        let tags: [SwipeCardTagItem]
        let value: String
        let bars: [SwipeOverlapBar]
    }
}

#Preview("Best Overlap Teaser") {
    ZStack {
        ScoutTheme.screenBackground.ignoresSafeArea()

        let previewBars: [(String, CGFloat)] = [
            ("M", 0.42),
            ("T", 0.14),
            ("W", 0.26),
            ("T", 0.86),
            ("F", 0.72),
            ("S", 0.12),
            ("S", 0.36)
        ]

        SwipeBestOverlapTeaser(
            model: .init(
                title: "Best Overlap",
                tags: [
                    SwipeCardTagItem(title: "Competitive"),
                    SwipeCardTagItem(title: "Late Night")
                ],
                value: "92%",
                bars: previewBars.enumerated().map { index, bar in
                    SwipeOverlapBar(label: bar.0, value: bar.1, position: index)
                }
            )
        )
        .padding()
    }
}
