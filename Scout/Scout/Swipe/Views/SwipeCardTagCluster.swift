//
//  SwipeCardTagCluster.swift
//  Scout
//
//  Created by Codex on 4/23/26.
//

import SwiftUI
import ScoutDesign

struct SwipeCardTagCluster: View {
    let tags: [SwipeCardTagItem]

    var body: some View {
        LazyVGrid(
            columns: [GridItem(.adaptive(minimum: 118), spacing: ScoutLayout.Spacing.sm)],
            alignment: .leading,
            spacing: ScoutLayout.Spacing.sm
        ) {
            ForEach(tags) { tag in
                SwipeTagPill(item: tag)
            }
        }
    }
}

#Preview("Swipe Card Tag Cluster") {
    ZStack {
        ScoutTheme.screenBackground.ignoresSafeArea()

        SwipeCardTagCluster(
            tags: [
                SwipeCardTagItem(title: "4.7 Competitive", style: .accent),
                SwipeCardTagItem(title: "Reliable", style: .info),
                SwipeCardTagItem(title: "Tue/Thu Nights"),
                SwipeCardTagItem(title: "Pickleball")
            ]
        )
        .padding()
    }
}
