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
            HStack(alignment: .bottom, spacing: ScoutSpacing.lg) {
                tagRow

                Spacer(minLength: ScoutSpacing.md)

                scoreValue
            }

            VStack(alignment: .leading, spacing: ScoutSpacing.lg) {
                tagRow
                scoreValue
            }
        }
    }

    var body: some View {
        GlassCard(padding: ScoutSpacing.xl) {
            VStack(alignment: .leading, spacing: ScoutSpacing.lg) {
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
        HStack(spacing: ScoutSpacing.md) {
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
            .shadow(color: Color.black.opacity(0.2), radius: 12, y: 3)
    }

    private var overlapChart: some View {
        HStack(alignment: .bottom, spacing: ScoutSpacing.md) {
            ForEach(model.bars) { bar in
                VStack(spacing: ScoutSpacing.sm) {
                    RoundedRectangle(cornerRadius: ScoutRadius.sm, style: .continuous)
                        .fill(Color.scoutSwipeOverlayTrack.opacity(0.45))
                        .frame(height: 86)
                        .overlay(alignment: .bottom) {
                            RoundedRectangle(cornerRadius: ScoutRadius.sm, style: .continuous)
                                .fill(ScoutTheme.accentGradient)
                                .frame(height: max(12, 72 * bar.value))
                                .padding(.horizontal, ScoutSpacing.xxs)
                                .padding(.bottom, ScoutSpacing.xxs)
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

        SwipeBestOverlapTeaser(
            model: .init(
                title: "Best Overlap",
                tags: [
                    SwipeCardTagItem(title: "Competitive"),
                    SwipeCardTagItem(title: "Late Night")
                ],
                value: "92%",
                bars: [
                    SwipeOverlapBar(label: "M", value: 0.42),
                    SwipeOverlapBar(label: "T", value: 0.14),
                    SwipeOverlapBar(label: "W", value: 0.26),
                    SwipeOverlapBar(label: "T", value: 0.86),
                    SwipeOverlapBar(label: "F", value: 0.72),
                    SwipeOverlapBar(label: "S", value: 0.12),
                    SwipeOverlapBar(label: "S", value: 0.36)
                ]
            )
        )
        .padding()
    }
}
