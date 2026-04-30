//
//  SwipeCardMatchupSection.swift
//  Scout
//
//  Created by Codex on 4/23/26.
//

import SwiftUI

struct SwipeCardMatchupSection: View {
    let matchupScore: Int
    let fitLabel: String
    let tiles: [SwipeCardMatchupTile]

    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: ScoutLayout.Spacing.lg) {
                ViewThatFits(in: .horizontal) {
                    HStack(alignment: .firstTextBaseline, spacing: ScoutLayout.Spacing.md) {
                        scoreBlock
                        Spacer(minLength: ScoutLayout.Spacing.md)
                        GlassChip(title: fitLabel, systemImage: "sparkles", style: .selected)
                    }

                    VStack(alignment: .leading, spacing: ScoutLayout.Spacing.md) {
                        scoreBlock
                        GlassChip(title: fitLabel, systemImage: "sparkles", style: .selected)
                    }
                }

                LazyVGrid(
                    columns: [GridItem(.adaptive(minimum: 132), spacing: ScoutLayout.Spacing.md)],
                    alignment: .leading,
                    spacing: ScoutLayout.Spacing.md
                ) {
                    ForEach(tiles) { tile in
                        summaryTile(tile)
                    }
                }
            }
        }
    }

    private var scoreBlock: some View {
        VStack(alignment: .leading, spacing: ScoutLayout.Spacing.xs) {
            Text("MATCHUP")
                .font(.scoutLabelCaps)
                .tracking(3)
                .foregroundStyle(Color.scoutTextSecondary)

            Text("\(matchupScore)")
                .font(.scoutNumberXL)
                .foregroundStyle(Color.scoutTextPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
    }

    private func summaryTile(_ tile: SwipeCardMatchupTile) -> some View {
        VStack(alignment: .leading, spacing: ScoutLayout.Spacing.xxs) {
            Text(tile.title.uppercased())
                .font(.scoutMicro)
                .tracking(1.5)
                .foregroundStyle(Color.scoutTextSecondary)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)

            Text(tile.value)
                .font(.scoutCallout)
                .foregroundStyle(Color.scoutTextPrimary)
                .lineLimit(2)
                .minimumScaleFactor(0.9)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, minHeight: 84, alignment: .leading)
        .padding(ScoutLayout.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: ScoutLayout.Radius.md, style: .continuous)
                .fill(Color.scoutSurfaceElevated)
        )
        .overlay(
            RoundedRectangle(cornerRadius: ScoutLayout.Radius.md, style: .continuous)
                .stroke(Color.scoutGlassStroke, lineWidth: ScoutLayout.Stroke.hairline)
        )
    }
}

struct SwipeCardMatchupTile: Identifiable {
    let id: String
    let title: String
    let value: String

    init(title: String, value: String) {
        self.id = title
        self.title = title
        self.value = value
    }
}

#Preview("Swipe Matchup") {
    ZStack {
        ScoutTheme.screenBackground.ignoresSafeArea()

        SwipeCardMatchupSection(
            matchupScore: 92,
            fitLabel: "Great fit",
            tiles: [
                SwipeCardMatchupTile(title: "Sport", value: "Pickleball"),
                SwipeCardMatchupTile(title: "Style", value: "Competitive"),
                SwipeCardMatchupTile(title: "Reliability", value: "High")
            ]
        )
        .padding()
    }
}
