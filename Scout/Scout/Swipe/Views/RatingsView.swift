//
//  RatingsView.swift
//  Scout
//
//  Created by Anna on 2/19/26.
//

import SwiftUI
import ScoutDesign

struct RatingsView: View {
    let stats: [StatsViewModel]

    var body: some View {
        GlassCard {
            ScoutSection(
                eyebrow: "Ratings",
                title: "Player snapshot",
                subtitle: "A quick look at how this player tends to show up in matches."
            ) {
                VStack(spacing: ScoutLayout.Spacing.md) {
                    ForEach(Array(stats.enumerated()), id: \.element.id) { index, stat in
                        ratingRow(for: stat)

                        if index < stats.count - 1 {
                            Rectangle()
                                .fill(Color.scoutDivider)
                                .frame(height: 1)
                        }
                    }
                }
            }
        }
    }

    private func ratingRow(for stat: StatsViewModel) -> some View {
        HStack(alignment: .center, spacing: ScoutLayout.Spacing.md) {
            VStack(alignment: .leading, spacing: ScoutLayout.Spacing.xxs) {
                Text(getStatTypeString(stat.statType).uppercased())
                    .font(.scoutLabelCaps)
                    .tracking(2.5)
                    .foregroundStyle(Color.scoutTextSecondary)

                Text("\(stat.totalReviews) reviews")
                    .font(.scoutCaption)
                    .foregroundStyle(Color.scoutTextSecondary)
            }

            Spacer()

            HStack(spacing: ScoutLayout.Spacing.xxs) {
                ForEach(0..<5, id: \.self) { index in
                    Image(systemName: index < stat.rating ? "star.fill" : "star")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(index < stat.rating ? AnyShapeStyle(ScoutTheme.accentGradient) : AnyShapeStyle(Color.scoutGlassStroke))
                }
            }
        }
    }
}

#Preview {
    ZStack {
        ScoutTheme.screenBackground.ignoresSafeArea()
        RatingsView(stats: getRandomStats())
            .padding()
    }
}
