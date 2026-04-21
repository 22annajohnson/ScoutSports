//
//  SwipeCardOverlayScrollLayout.swift
//  Scout
//
//  Created by Codex on 4/2/26.
//

import SwiftUI

struct SwipeCardOverlayScrollLayout<Background: View, TopBar: View, Content: View, Dock: View>: View {
    let heroStartRatio: CGFloat
    let background: Background
    let topBar: TopBar
    let content: Content
    let dock: Dock

    init(
        heroStartRatio: CGFloat = 0.52,
        @ViewBuilder background: () -> Background,
        @ViewBuilder topBar: () -> TopBar,
        @ViewBuilder content: () -> Content,
        @ViewBuilder dock: () -> Dock
    ) {
        self.heroStartRatio = heroStartRatio
        self.background = background()
        self.topBar = topBar()
        self.content = content()
        self.dock = dock()
    }

    var body: some View {
        GeometryReader { geo in
            let safeTop = geo.safeAreaInsets.top
            let safeBottom = max(geo.safeAreaInsets.bottom, ScoutSpacing.sm)
            let heroStart = max(220, geo.size.height * heroStartRatio)

            ZStack(alignment: .top) {
                background
                    .frame(width: geo.size.width, height: geo.size.height)
                    .ignoresSafeArea()

                topBar
                    .padding(.horizontal, ScoutSpacing.md)
                    .padding(.top, max(ScoutSpacing.xs, safeTop - ScoutSpacing.xs))
                    .frame(maxWidth: .infinity, alignment: .top)
                    .zIndex(2)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: ScoutSpacing.lg) {
                        Color.clear
                            .frame(height: heroStart)

                        content
                            .padding(.horizontal, ScoutSpacing.lg)

                        Color.clear
                            .frame(height: 140 + safeBottom)
                    }
                    .frame(maxWidth: .infinity)
                }
                .ignoresSafeArea(edges: .bottom)
                .zIndex(1)

                VStack {
                    Spacer()

                    dock
                        .padding(.horizontal, ScoutSpacing.lg)
                        .padding(.bottom, safeBottom)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .zIndex(3)
            }
            .background(ScoutTheme.screenBackground)
        }
    }
}

#Preview("Swipe Overlay Layout") {
    SwipeCardOverlayScrollLayout {
        PlayerBackgroundView(imageURL: getRandomHeroHeaderViewModel().imageURL, color: .scoutAccentStart)
    } topBar: {
        HStack {
            GlassChip(title: "2.1 mi away")
            Spacer()
            GlassChip(title: "92 Match", style: .accent)
        }
    } content: {
        VStack(spacing: ScoutSpacing.lg) {
            GlassCard {
                Text("Identity section starts around mid-screen and can scroll upward over the image.")
                    .font(.scoutBody)
                    .foregroundStyle(Color.scoutTextPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            GlassCard {
                Text("Additional swipe segments stack below the hero section.")
                    .font(.scoutBody)
                    .foregroundStyle(Color.scoutTextPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    } dock: {
        ScoutActionDock()
    }
}
