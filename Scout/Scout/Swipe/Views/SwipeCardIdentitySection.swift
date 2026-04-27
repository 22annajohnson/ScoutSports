//
//  SwipeCardIdentitySection.swift
//  Scout
//
//  Created by Codex on 4/21/26.
//

import SwiftUI

struct SwipeCardIdentitySection: View {
    let model: Model

    var body: some View {
        GlassCard(padding: ScoutSpacing.lg) {
            VStack(alignment: .leading, spacing: ScoutSpacing.md) {
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
        HStack(alignment: .top, spacing: ScoutSpacing.lg) {
            VStack(alignment: .leading, spacing: ScoutSpacing.md) {
                intentChip
                nameRow
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            scoreCapsule
        }
    }

    private var nameRow: some View {
        HStack(alignment: .firstTextBaseline, spacing: ScoutSpacing.xs) {
            Text(model.name)
                .font(.scoutDisplayCompact)
                .foregroundStyle(Color.white)
                .lineLimit(1)
                .minimumScaleFactor(0.72)

            if let age = model.age {
                Text("\(age)")
                    .font(.scoutNumberM)
                    .foregroundStyle(Color.scoutAccentStart)
                    .lineLimit(1)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var intentChip: some View {
        HStack(spacing: ScoutSpacing.sm) {
            Circle()
                .fill(Color.scoutAccentEnd)
                .frame(width: 9, height: 9)

            Text(model.intent)
                .font(.scoutCallout)
                .foregroundStyle(Color.scoutAccentStart)
                .lineLimit(1)
                .minimumScaleFactor(0.84)
        }
        .padding(.horizontal, ScoutSpacing.md)
        .padding(.vertical, ScoutSpacing.xs)
        .background(
            Capsule()
                .fill(Color.scoutAccentStart.opacity(0.12))
                .background(.ultraThinMaterial, in: Capsule())
        )
        .overlay(
            Capsule()
                .stroke(Color.scoutAccentStart.opacity(0.24), lineWidth: ScoutStroke.hairline)
        )
    }

    private var scoreCapsule: some View {
        VStack(spacing: ScoutSpacing.xs) {
            Text("OVERALL")
                .font(.scoutMicro)
                .tracking(4)
                .foregroundStyle(Color.scoutTextSecondary.opacity(0.9))
                .lineLimit(1)

            Text("\(model.score)")
                .font(.scoutNumberL)
                .foregroundStyle(Color.white)
                .lineLimit(1)
                .minimumScaleFactor(0.82)
        }
        .frame(width: 108)
        .frame(minHeight: 88)
        .background(
            RoundedRectangle(cornerRadius: ScoutRadius.lg, style: .continuous)
                .fill(Color.black.opacity(0.24))
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: ScoutRadius.lg, style: .continuous))
        )
        .overlay(
            RoundedRectangle(cornerRadius: ScoutRadius.lg, style: .continuous)
                .stroke(Color.scoutAccentStart.opacity(0.24), lineWidth: ScoutStroke.hairline)
        )
    }

    private var bodyCopy: some View {
        VStack(alignment: .leading, spacing: ScoutSpacing.xs) {
            ForEach(Array(model.summaryLines.prefix(3).enumerated()), id: \.offset) { _, line in
                Text(line)
                    .font(.scoutBody)
                    .foregroundStyle(Color.white.opacity(0.9))
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var compactHighlights: some View {
        HStack(alignment: .top, spacing: ScoutSpacing.sm) {
            ForEach(model.highlights) { tile in
                compactHighlightCard(tile)
            }
        }
    }

    private func compactHighlightCard(_ tile: SwipeHighlightTile) -> some View {
        VStack(alignment: .leading, spacing: ScoutSpacing.md) {
            Text(tile.title.uppercased())
                .font(.scoutMicro)
                .tracking(3)
                .foregroundStyle(Color.scoutTextSecondary)
                .lineLimit(1)
                .minimumScaleFactor(0.7)

            Text(tile.value)
                .font(.scoutNumberL)
                .foregroundStyle(Color.white)
                .lineLimit(1)
                .minimumScaleFactor(0.72)

            GeometryReader { geo in
                Capsule()
                    .fill(Color.white.opacity(0.10))
                    .overlay(alignment: .leading) {
                        Capsule()
                            .fill(ScoutTheme.accentGradient)
                            .frame(width: geo.size.width * tile.progress)
                    }
            }
            .frame(height: 4)
        }
        .padding(ScoutSpacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .aspectRatio(1, contentMode: .fit)
        .background(
            RoundedRectangle(cornerRadius: ScoutRadius.lg, style: .continuous)
                .fill(Color.black.opacity(0.22))
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: ScoutRadius.lg, style: .continuous))
        )
        .overlay(
            RoundedRectangle(cornerRadius: ScoutRadius.lg, style: .continuous)
                .stroke(Color.white.opacity(0.12), lineWidth: ScoutStroke.hairline)
        )
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
