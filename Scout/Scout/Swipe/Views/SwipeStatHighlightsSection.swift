//
//  SwipeStatHighlightsSection.swift
//  Scout
//
//  Created by Codex on 4/23/26.
//

import SwiftUI

struct SwipeStatHighlightsSection: View {
    let tiles: [SwipeHighlightTile]

    var body: some View {
        HStack(alignment: .top, spacing: ScoutSpacing.md) {
            ForEach(tiles) { tile in
                statCard(tile)
            }
        }
    }

    private func statCard(_ tile: SwipeHighlightTile) -> some View {
        GlassCard(padding: ScoutSpacing.lg) {
            VStack(alignment: .leading, spacing: ScoutSpacing.lg) {
                Text(tile.title.uppercased())
                    .font(.scoutLabelCaps)
                    .tracking(4.5)
                    .foregroundStyle(Color.scoutTextSecondary)
                    .lineLimit(1)

                Text(tile.value)
                    .font(.scoutNumberL)
                    .foregroundStyle(Color.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.82)

                GeometryReader { geo in
                    Capsule()
                        .fill(Color.white.opacity(0.12))
                        .overlay(alignment: .leading) {
                            Capsule()
                                .fill(ScoutTheme.accentGradient)
                                .frame(width: geo.size.width * tile.progress)
                        }
                }
                .frame(height: 4)
            }
            .frame(maxWidth: .infinity, minHeight: 158, alignment: .leading)
        }
    }
}

struct SwipeHighlightTile: Identifiable {
    let id: String
    let title: String
    let value: String
    let progress: CGFloat

    init(title: String, value: String, progress: CGFloat) {
        self.id = title
        self.title = title
        self.value = value
        self.progress = progress
    }
}

#Preview("Swipe Stat Highlights") {
    ZStack {
        ScoutTheme.screenBackground.ignoresSafeArea()

        SwipeStatHighlightsSection(
            tiles: [
                SwipeHighlightTile(title: "Skill", value: "4.3", progress: 0.78),
                SwipeHighlightTile(title: "Matches", value: "38", progress: 0.64),
                SwipeHighlightTile(title: "Win Rate", value: "71%", progress: 0.81)
            ]
        )
        .padding()
    }
}
