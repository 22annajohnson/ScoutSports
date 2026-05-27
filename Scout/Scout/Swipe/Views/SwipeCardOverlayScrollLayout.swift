//
//  SwipeCardOverlayScrollLayout.swift
//  Scout
//
//  Created by Codex on 4/2/26.
//

import SwiftUI
import ScoutDesign

enum SwipeOverlayCoordinateSpace {
    static let name = "SwipeOverlayLayout"
}

struct SwipeCardOverlayScrollLayout<Background: View, TopBar: View, Content: View, Dock: View>: View {
    let heroStartRatio: CGFloat
    let bottomContentInset: CGFloat
    let background: Background
    let topBar: (CGFloat) -> TopBar
    let content: Content
    let dock: Dock
    let onScrollOffsetChange: (CGFloat) -> Void
    @State private var scrollOffsetY: CGFloat = 0

    init(
        heroStartRatio: CGFloat = 0.52,
        bottomContentInset: CGFloat = 0,
        @ViewBuilder background: () -> Background,
        @ViewBuilder topBar: @escaping (CGFloat) -> TopBar,
        @ViewBuilder content: () -> Content,
        @ViewBuilder dock: () -> Dock,
        onScrollOffsetChange: @escaping (CGFloat) -> Void = { _ in }
    ) {
        self.heroStartRatio = heroStartRatio
        self.bottomContentInset = bottomContentInset
        self.background = background()
        self.topBar = topBar
        self.content = content()
        self.dock = dock()
        self.onScrollOffsetChange = onScrollOffsetChange
    }

    var body: some View {
        GeometryReader { geo in
            let metrics = LayoutMetrics(
                geometry: geo,
                heroStartRatio: heroStartRatio,
                bottomContentInset: bottomContentInset
            )
            let heroMergeProgress = metrics.heroMergeProgress(for: scrollOffsetY)
            let topBarOffset = -metrics.heroDismissDistance * heroMergeProgress

            ZStack(alignment: .top) {
                fullScreenWash
                    .frame(width: geo.size.width, height: metrics.backgroundHeight)
                    .offset(y: -metrics.backgroundTopInset)
                    .ignoresSafeArea()

                background
                    .frame(width: geo.size.width, height: metrics.backgroundHeight)
                    .offset(y: -metrics.backgroundTopInset)
                    .ignoresSafeArea()

                topBar(heroMergeProgress)
                    .padding(.horizontal, ScoutLayout.Spacing.md)
                    .padding(.top, metrics.topBarTopInset)
                    .frame(maxWidth: .infinity, alignment: .top)
                    .offset(y: topBarOffset)
                    .clipped()
                    .animation(ScoutMotion.selection, value: heroMergeProgress)
                    .zIndex(2)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: ScoutLayout.Spacing.lg) {
                        Color.clear
                            .frame(height: metrics.heroStart)

                        content
                            .padding(.horizontal, ScoutLayout.Spacing.lg)

                        Color.clear
                            .frame(height: metrics.scrollBottomClearance)
                    }
                    .frame(maxWidth: .infinity)
                }
                .onScrollGeometryChange(for: CGFloat.self, of: { geometry in
                    geometry.contentOffset.y
                }, action: { _, offsetY in
                    scrollOffsetY = offsetY
                    onScrollOffsetChange(offsetY)
                })
                .ignoresSafeArea(edges: .bottom)
                .zIndex(1)

                VStack {
                    Spacer()

                    dock
                        .padding(.horizontal, ScoutLayout.Spacing.lg)
                        .padding(.bottom, metrics.dockBottomInset)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .zIndex(3)
            }
            .background(fullScreenWash.ignoresSafeArea())
        }
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
        let heroDismissDistance: CGFloat
        let heroMergeRange: CGFloat
        let topBarTopInset: CGFloat
        let compactTopBarTopInset: CGFloat
        let dockBottomInset: CGFloat
        let scrollBottomClearance: CGFloat

        init(geometry: GeometryProxy, heroStartRatio: CGFloat, bottomContentInset: CGFloat) {
            let safeTop = ScoutLayout.SafeArea.topInset(from: geometry.safeAreaInsets)
            let safeBottom = ScoutLayout.SafeArea.bottomInset(from: geometry.safeAreaInsets)

            self.backgroundTopInset = safeTop
            self.backgroundHeight = ScoutLayout.SafeArea.fullHeight(for: geometry.size, insets: geometry.safeAreaInsets)
            self.heroStart = max(220, geometry.size.height * heroStartRatio)
            self.heroMergeRange = 92
            self.topBarTopInset = ScoutLayout.Spacing.lg
            self.compactTopBarTopInset = ScoutLayout.Spacing.sm
            self.heroDismissDistance = max(0, topBarTopInset - compactTopBarTopInset)
            self.dockBottomInset = safeBottom + (3 * ScoutLayout.Spacing.xl) + bottomContentInset
            self.scrollBottomClearance = 256 + safeBottom + bottomContentInset
        }

        func heroMergeProgress(for scrollOffsetY: CGFloat) -> CGFloat {
            guard scrollOffsetY.isFinite else { return 0 }
            return min(max(scrollOffsetY / heroMergeRange, 0), 1)
        }
    }
}

#Preview("Swipe Overlay Layout") {
    SwipeCardOverlayScrollLayout {
        PlayerBackgroundView(imageURL: randomMockCardViewModel().heroImageURL, color: .scoutAccentStart)
    } topBar: { _ in
        HStack {
            GlassChip(title: "2.1 mi away")
            Spacer()
            GlassChip(title: "92 Match", style: .accent)
        }
    } content: {
        VStack(spacing: ScoutLayout.Spacing.lg) {
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
