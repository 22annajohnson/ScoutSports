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
        SwipeMetricTileView(tile: tile, style: .featureBand)
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
