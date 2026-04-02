//
//  PlayerSwipeScrollView.swift
//  Scout
//
//  Created by Anna on 2/19/26.
//

import SwiftUI

struct PlayerSwipeScrollView: View {
    let model: CardViewModel

    private let accent = Color.scoutAccentStart

    var body: some View {
        GeometryReader { geo in
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    ScoutHeroLayout {
                        PlayerBackgroundView(imageURL: model.heroImageURL, color: accent)
                    } topBar: {
                        topBar
                    } overlay: {
                        PlayerHeroHeaderView(
                            model: HeroHeaderViewModel(
                                imageURL: model.heroImageURL,
                                name: model.name,
                                score: matchupScore,
                                accent: accent
                            )
                        )
                    } bottom: {
                        VStack(spacing: ScoutSpacing.xl) {
                            matchupSummary

                            RatingsView(stats: model.stats)

                            ScoutActionDock()
                        }
                        .padding(.horizontal, ScoutSpacing.lg)
                        .padding(.top, ScoutSpacing.xl)
                        .padding(.bottom, ScoutSpacing.xl)
                    }
                    .frame(width: geo.size.width)
                }
            }
            .ignoresSafeArea(.all)
            .background(ScoutTheme.screenBackground.ignoresSafeArea())
            .onAppear {
                UIScrollView.appearance().bounces = false
            }
            .onDisappear {
                UIScrollView.appearance().bounces = true
            }
        }
    }

    private var topBar: some View {
        HStack(spacing: ScoutSpacing.sm) {
            GlassChip(title: "2.1 mi away")

            Spacer()

            GlassChip(title: "\(matchupScore) Match", style: .accent)
        }
    }

    private var matchupSummary: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: ScoutSpacing.lg) {
                ViewThatFits(in: .horizontal) {
                    HStack(alignment: .firstTextBaseline, spacing: ScoutSpacing.md) {
                        scoreBlock
                        Spacer(minLength: ScoutSpacing.md)
                        GlassChip(title: "Great fit", systemImage: "sparkles", style: .selected)
                    }

                    VStack(alignment: .leading, spacing: ScoutSpacing.md) {
                        scoreBlock
                        GlassChip(title: "Great fit", systemImage: "sparkles", style: .selected)
                    }
                }

                LazyVGrid(
                    columns: [GridItem(.adaptive(minimum: 132), spacing: ScoutSpacing.md)],
                    alignment: .leading,
                    spacing: ScoutSpacing.md
                ) {
                    summaryTile(title: "Sport", value: model.sports.first ?? "Pickleball")
                    summaryTile(title: "Style", value: "Competitive")
                    summaryTile(title: "Reliability", value: "High")
                }
            }
        }
    }

    private var scoreBlock: some View {
        VStack(alignment: .leading, spacing: ScoutSpacing.xs) {
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

    private func summaryTile(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: ScoutSpacing.xxs) {
            Text(title.uppercased())
                .font(.scoutMicro)
                .tracking(1.5)
                .foregroundStyle(Color.scoutTextSecondary)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)

            Text(value)
                .font(.scoutCallout)
                .foregroundStyle(Color.scoutTextPrimary)
                .lineLimit(2)
                .minimumScaleFactor(0.9)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, minHeight: 84, alignment: .leading)
        .padding(ScoutSpacing.md)
        .background(
            RoundedRectangle(cornerRadius: ScoutRadius.md, style: .continuous)
                .fill(Color.scoutSurfaceElevated)
        )
        .overlay(
            RoundedRectangle(cornerRadius: ScoutRadius.md, style: .continuous)
                .stroke(Color.scoutGlassStroke, lineWidth: ScoutStroke.hairline)
        )
    }

    private var matchupScore: Int {
        let cappedStars = model.stats.map { min(max($0.rating, 0), 5) }
        guard !cappedStars.isEmpty else { return 82 }
        let normalized = cappedStars.reduce(0, +) * 100 / (cappedStars.count * 5)
        return max(72, normalized)
    }
}

#Preview {
    PlayerSwipeScrollView(model: randomMockCardViewModel())
}
