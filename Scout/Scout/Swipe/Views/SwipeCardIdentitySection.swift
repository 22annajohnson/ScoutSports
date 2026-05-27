//
//  SwipeCardIdentitySection.swift
//  Scout
//
//  Created by Codex on 4/21/26.
//

import SwiftUI
import ScoutDesign

struct SwipeCardIdentitySection: View {
    let model: Model

    private var readableAccent: Color {
        Color.scoutAccentEnd.opacity(0.96)
    }

    var body: some View {
        GlassCard(padding: ScoutLayout.Spacing.lg) {
            VStack(alignment: .leading, spacing: ScoutLayout.Spacing.md) {
                header
                bodyCopy

                if !model.tags.isEmpty {
                    SwipeCardTagCluster(tags: model.tags)
                }

                if !model.highlights.isEmpty {
                    compactHighlights
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var header: some View {
        HStack(alignment: .top, spacing: ScoutLayout.Spacing.lg) {
            VStack(alignment: .leading, spacing: ScoutLayout.Spacing.md) {
                intentChip
                nameRow
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            scoreCapsule
        }
    }

    private var nameRow: some View {
        HStack(alignment: .firstTextBaseline, spacing: ScoutLayout.Spacing.xs) {
            Text(model.name)
                .font(.scoutDisplayCompact)
                .foregroundStyle(Color.scoutOnImageTextPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.72)

            if let age = model.age {
                Text("\(age)")
                    .font(.scoutNumberM)
                    .foregroundStyle(readableAccent)
                    .lineLimit(1)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var intentChip: some View {
        HStack(spacing: ScoutLayout.Spacing.sm) {
            Circle()
                .fill(Color.scoutAccentEnd)
                .frame(width: 9, height: 9)

            Text(model.intent)
                .font(.scoutCallout)
                .foregroundStyle(readableAccent)
                .lineLimit(1)
                .minimumScaleFactor(0.84)
        }
        .padding(.horizontal, ScoutLayout.Spacing.md)
        .padding(.vertical, ScoutLayout.Spacing.xs)
        .background(
            Capsule()
                .fill(Color.scoutAccentEnd.opacity(0.16))
                .background(.ultraThinMaterial, in: Capsule())
        )
        .overlay(
            Capsule()
                .stroke(Color.scoutAccentStart.opacity(0.24), lineWidth: ScoutLayout.Stroke.hairline)
                .stroke(Color.scoutAccentEnd.opacity(0.28), lineWidth: ScoutLayout.Stroke.hairline)
        )
    }

    private var scoreCapsule: some View {
        VStack(spacing: ScoutLayout.Spacing.xs) {
            Text("OVERALL")
                .font(.scoutMicro)
                .tracking(4)
                .foregroundStyle(Color.scoutTextSecondary.opacity(0.9))
                .lineLimit(1)

            Text("\(model.score)")
                .font(.scoutNumberL)
                .foregroundStyle(Color.scoutOnImageTextPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.82)
        }
        .frame(width: 108)
        .frame(minHeight: 88)
        .background(
            RoundedRectangle(cornerRadius: ScoutLayout.Radius.lg, style: .continuous)
                .fill(Color.scoutSwipeOverlaySurface)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: ScoutLayout.Radius.lg, style: .continuous))
        )
        .overlay(
            RoundedRectangle(cornerRadius: ScoutLayout.Radius.lg, style: .continuous)
                .stroke(Color.scoutSwipeOverlayStroke, lineWidth: ScoutLayout.Stroke.hairline)
        )
    }

    private var bodyCopy: some View {
        VStack(alignment: .leading, spacing: ScoutLayout.Spacing.xs) {
            ForEach(Array(model.summaryLines.prefix(3).enumerated()), id: \.offset) { _, line in
                Text(line)
                    .font(.scoutBody)
                    .foregroundStyle(Color.scoutOnImageTextMuted)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var compactHighlights: some View {
        HStack(alignment: .top, spacing: ScoutLayout.Spacing.sm) {
            ForEach(model.highlights) { tile in
                compactHighlightCard(tile)
            }
        }
    }

    private func compactHighlightCard(_ tile: SwipeHighlightTile) -> some View {
        SwipeMetricTileView(tile: tile, style: .compactSquare)
    }
}

extension SwipeCardIdentitySection {
    struct Model {
        let name: String
        let age: Int?
        let summaryLines: [String]
        let intent: String
        let score: Int
        let tags: [SwipeCardTagItem]
        let highlights: [SwipeHighlightTile]
    }
}

#Preview("Swipe Card Identity") {
    ZStack {
        PlayerBackgroundView(imageURL: randomMockCardViewModel().heroImageURL, color: .scoutAccentStart)
            .ignoresSafeArea()

        SwipeCardIdentitySection(
            model: .init(
                name: "Sophie",
                age: 27,
                summaryLines: [
                    "Aggressive at the net.",
                    "Loves fast doubles.",
                    "Usually free Tue/Thu nights."
                ],
                intent: "Competitive games",
                score: 88,
                tags: [
                    SwipeCardTagItem(title: "4.7 Competitive", style: .accent),
                    SwipeCardTagItem(title: "Reliable", style: .info),
                    SwipeCardTagItem(title: "Tue/Thu Nights"),
                    SwipeCardTagItem(title: "Pickleball")
                ],
                highlights: [
                    SwipeHighlightTile(title: "Skill", value: "4.2", progress: 0.76),
                    SwipeHighlightTile(title: "Matches", value: "38", progress: 0.64),
                    SwipeHighlightTile(title: "Win Rate", value: "71%", progress: 0.81)
                ]
            )
        )
        .padding()
    }
}
