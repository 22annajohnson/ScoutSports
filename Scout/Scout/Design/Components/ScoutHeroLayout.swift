//
//  ScoutHeroLayout.swift
//  Scout
//
//  Created by Codex on 4/1/26.
//

import SwiftUI

struct ScoutHeroLayout<Background: View, TopBar: View, Overlay: View, Bottom: View>: View {
    let background: Background
    let topBar: TopBar
    let overlay: Overlay
    let bottom: Bottom

    init(
        @ViewBuilder background: () -> Background,
        @ViewBuilder topBar: () -> TopBar,
        @ViewBuilder overlay: () -> Overlay,
        @ViewBuilder bottom: () -> Bottom
    ) {
        self.background = background()
        self.topBar = topBar()
        self.overlay = overlay()
        self.bottom = bottom()
    }

    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .top) {
                background
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .overlay(
                        LinearGradient(
                            colors: [.clear, Color.black.opacity(0.45)],
                            startPoint: .center,
                            endPoint: .bottom
                        )
                    )

                VStack(spacing: 0) {
                    topBar
                        .padding(.horizontal, ScoutSpacing.lg)
                        .padding(.top, ScoutSpacing.xl)

                    Spacer()

                    overlay
                        .padding(.horizontal, ScoutSpacing.lg)
                        .padding(.bottom, ScoutSpacing.xl)
                }
            }
            .frame(minHeight: 420)

            bottom
        }
        .background(ScoutTheme.screenBackground.ignoresSafeArea())
    }
}

#Preview("Hero Layout") {
    ScoutHeroLayout {
        RoundedRectangle(cornerRadius: 0)
            .fill(
                LinearGradient(
                    colors: [Color.scoutAccentStart.opacity(0.75), Color.scoutAccentEnd.opacity(0.65)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
    } topBar: {
        HStack {
            GlassChip(title: "2.1 mi away")
            Spacer()
            GlassChip(title: "92 Match", style: .accent)
        }
    } overlay: {
        VStack(alignment: .leading, spacing: ScoutSpacing.md) {
            Text("Sophie 27")
                .font(.scoutDisplayCompact)
                .foregroundStyle(Color.white)

            HStack(spacing: ScoutSpacing.sm) {
                GlassChip(title: "4.7 Competitive")
                GlassChip(title: "Tue/Thu Nights")
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    } bottom: {
        VStack(spacing: ScoutSpacing.xl) {
            HStack(spacing: ScoutSpacing.md) {
                ScoutStatTile(title: "Skill", value: "4.3")
                ScoutStatTile(title: "Matches", value: "38")
                ScoutStatTile(title: "Win Rate", value: "71%")
            }
            .padding(.horizontal, ScoutSpacing.lg)
            .padding(.top, ScoutSpacing.xl)

            ScoutActionDock()
                .padding(.horizontal, ScoutSpacing.lg)
                .padding(.bottom, ScoutSpacing.xl)
        }
    }
}
