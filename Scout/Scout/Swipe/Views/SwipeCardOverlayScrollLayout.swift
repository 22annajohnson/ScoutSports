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
            let metrics = LayoutMetrics(geometry: geo, heroStartRatio: heroStartRatio)

            ZStack(alignment: .top) {
                fullScreenWash
                    .frame(width: geo.size.width, height: metrics.backgroundHeight)
                    .offset(y: -metrics.backgroundTopInset)
                    .ignoresSafeArea()

                background
                    .frame(width: geo.size.width, height: metrics.backgroundHeight)
                    .offset(y: -metrics.backgroundTopInset)
                    .ignoresSafeArea()

                topBar
                    .padding(.horizontal, ScoutSpacing.md)
                    .padding(.top, metrics.topBarTopInset)
                    .frame(maxWidth: .infinity, alignment: .top)
                    .zIndex(2)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: ScoutSpacing.lg) {
                        Color.clear
                            .frame(height: metrics.heroStart)

                        content
                            .padding(.horizontal, ScoutSpacing.lg)

                        Color.clear
                            .frame(height: metrics.scrollBottomClearance)
                    }
                    .frame(maxWidth: .infinity)
                }
                .ignoresSafeArea(edges: .bottom)
                .zIndex(1)

                VStack {
                    Spacer()

                    dock
                        .padding(.horizontal, ScoutSpacing.lg)
                        .padding(.bottom, metrics.dockBottomInset)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .zIndex(3)
            }
            .background(fullScreenWash.ignoresSafeArea())
            .ignoresSafeArea()
        }
        .ignoresSafeArea()
    }

    private var fullScreenWash: some View {
        LinearGradient(
            colors: [
                Color.scoutBackground,
                Color.scoutBackground,
                Color.scoutAccentStart.opacity(0.26),
                Color.scoutAccentEnd.opacity(0.32)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    private struct LayoutMetrics {
        let backgroundTopInset: CGFloat
        let backgroundHeight: CGFloat
        let heroStart: CGFloat
        let topBarTopInset: CGFloat
        let dockBottomInset: CGFloat
        let scrollBottomClearance: CGFloat

        init(geometry: GeometryProxy, heroStartRatio: CGFloat) {
            let safeTop = geometry.safeAreaInsets.top
            let safeBottom = max(geometry.safeAreaInsets.bottom, ScoutSpacing.sm)

            self.backgroundTopInset = safeTop
            self.backgroundHeight = geometry.size.height + safeTop + geometry.safeAreaInsets.bottom
            self.heroStart = max(220, geometry.size.height * heroStartRatio)
            self.topBarTopInset = safeTop + (2 * ScoutSpacing.xxxl)
            self.dockBottomInset = safeBottom + ScoutSpacing.lg
            self.scrollBottomClearance = 140 + safeBottom
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
