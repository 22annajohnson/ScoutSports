//
//  PlayerHeroHeaderView.swift
//  Scout
//
//  Created by Anna on 2/19/26.
//

import SwiftUI

struct PlayerHeroHeaderView: View {
    let model: HeroHeaderViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: ScoutSpacing.md) {
            Text(model.name)
                .font(.scoutDisplayCompact)
                .foregroundStyle(Color.white)

            ViewThatFits(in: .horizontal) {
                HStack(spacing: ScoutSpacing.sm) {
                    heroChips
                }

                VStack(alignment: .leading, spacing: ScoutSpacing.sm) {
                    HStack(spacing: ScoutSpacing.sm) {
                        GlassChip(title: "\(model.score) Match", systemImage: "bolt.fill", style: .accent)
                        GlassChip(title: "Competitive")
                    }

                    GlassChip(title: "Pickleball")
                }
            }

            if let bio = model.bio?.trimmingCharacters(in: .whitespacesAndNewlines), !bio.isEmpty {
                Text(bio)
                    .font(.scoutBody)
                    .foregroundStyle(Color.white.opacity(0.84))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var heroChips: some View {
        Group {
            GlassChip(title: "\(model.score) Match", systemImage: "bolt.fill", style: .accent)
            GlassChip(title: "Competitive")
            GlassChip(title: "Pickleball")
        }
    }
}

#Preview ("Hero") {
    ZStack {
        PlayerHeroHeaderView(model: getRandomHeroHeaderViewModel())
            .padding()
            .background(ScoutTheme.screenBackground)
    }
}
