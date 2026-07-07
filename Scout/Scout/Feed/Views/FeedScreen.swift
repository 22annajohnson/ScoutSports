//
//  FeedScreen.swift
//  Scout
//
//  Created by Codex on 4/29/26.
//

import SwiftUI
import ScoutDesign

private enum FeedHeaderMetrics {
    static let expandedHeight: CGFloat = 196
    static let collapsedHeight: CGFloat = 92
    static let collapseRange: CGFloat = 110
}

struct FeedScreen: View {
    @State private var vm: FeedViewModel
    @State private var scrollOffsetY: CGFloat = 0

    let bottomContentInset: CGFloat
    let onScrollOffsetChange: (CGFloat) -> Void

    init(
        vm: FeedViewModel,
        bottomContentInset: CGFloat = 0,
        onScrollOffsetChange: @escaping (CGFloat) -> Void = { _ in }
    ) {
        _vm = State(initialValue: vm)
        self.bottomContentInset = bottomContentInset
        self.onScrollOffsetChange = onScrollOffsetChange
    }

    var body: some View {
        @Bindable var vm = vm

        ZStack(alignment: .top) {
            Group {
                switch vm.viewState {
                case .loading:
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                case .empty:
                    ScoutStateCard(
                        state: .empty,
                        title: "Nothing here yet",
                        message: "Your feed will wake up once your inner circle and local activity start flowing."
                    )
                    .padding(.horizontal, ScoutLayout.Spacing.lg)
                case let .error(message):
                    ScoutStateCard(
                        state: .error,
                        title: "Feed unavailable",
                        message: message
                    )
                    .padding(.horizontal, ScoutLayout.Spacing.lg)
                case .loaded:
                    feedContent(
                        visiblePosts: vm.visiblePosts,
                        selectedCategory: vm.selectedCategory,
                        availableCategories: vm.availableCategories,
                        onSelectCategory: vm.selectCategory(_:)
                    )
                }
            }

            FeedCollapsibleHeaderView(
                selectedCategory: vm.selectedCategory,
                availableCategories: vm.availableCategories,
                collapseProgress: headerCollapseProgress,
                onSelectCategory: vm.selectCategory(_:)
            )
        }
        .background(ScoutTheme.screenBackground.ignoresSafeArea())
        .task {
            await vm.loadIfNeeded()
        }
        .onDisappear {
            onScrollOffsetChange(0)
        }
    }

    private func feedContent(
        visiblePosts: [FeedPreviewPost],
        selectedCategory: FeedPostCategory,
        availableCategories: [FeedPostCategory],
        onSelectCategory: @escaping (FeedPostCategory) -> Void
    ) -> some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(alignment: .leading, spacing: ScoutLayout.Spacing.lg) {
                Color.clear
                    .frame(height: FeedHeaderMetrics.expandedHeight)

                ForEach(visiblePosts) { post in
                    FeedPostCard(post: post)
                }

                Color.clear
                    .frame(height: bottomContentInset)
            }
            .padding(.horizontal, ScoutLayout.Spacing.lg)
            .padding(.bottom, ScoutLayout.Spacing.md)
        }
        .onScrollGeometryChange(for: CGFloat.self, of: { geometry in
            geometry.contentOffset.y
        }, action: { _, offsetY in
            scrollOffsetY = max(0, offsetY)
            onScrollOffsetChange(offsetY)
        })
    }

    private var headerCollapseProgress: CGFloat {
        min(max(scrollOffsetY / FeedHeaderMetrics.collapseRange, 0), 1)
    }
}

private struct FeedCollapsibleHeaderView: View {
    let selectedCategory: FeedPostCategory
    let availableCategories: [FeedPostCategory]
    let collapseProgress: CGFloat
    let onSelectCategory: (FeedPostCategory) -> Void

    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: ScoutLayout.Spacing.xs) {
                        Text("SCOUT")
                            .font(.system(size: 11, weight: .bold, design: .default))
                            .tracking(3)
                            .foregroundStyle(Color.scoutTextSecondary)
                        Text("Feed")
                            .font(.system(size: titleSize, weight: .black, design: .rounded))
                            .foregroundStyle(Color.scoutTextPrimary)
                    }

                    Spacer()

                    ZStack {
                        RoundedRectangle(cornerRadius: ScoutLayout.Radius.lg, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [Color.scoutGradientViolet, Color.scoutGradientCyan],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )

                        Text("S")
                            .font(.system(size: 20, weight: .black, design: .rounded))
                            .foregroundStyle(Color.scoutOnImageTextPrimary)
                    }
                    .frame(width: 44, height: 44)
                }
                .padding(.top, ScoutLayout.Spacing.lg)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: ScoutLayout.Spacing.sm) {
                        ForEach(availableCategories) { category in
                            Button(category.title) {
                                onSelectCategory(category)
                            }
                            .buttonStyle(FeedCategoryFilterButtonStyle(isSelected: selectedCategory == category))
                        }
                    }
                }
                .padding(.top, chipsTopPadding)
                .opacity(chipsOpacity)
                .offset(y: chipsVerticalOffset)
            }
            .padding(.horizontal, ScoutLayout.Spacing.lg)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: headerHeight, alignment: .top)
            .background(glassPanel)
            .overlay(glassStroke)
            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            .shadow(color: Color.scoutShadowStrong.opacity(0.88), radius: 24, y: 14)
        }
        .padding(.horizontal, ScoutLayout.Spacing.lg)
        .padding(.top, ScoutLayout.Spacing.sm)
    }

    private var headerHeight: CGFloat {
        FeedHeaderMetrics.expandedHeight - ((FeedHeaderMetrics.expandedHeight - FeedHeaderMetrics.collapsedHeight) * collapseProgress)
    }

    private var titleSize: CGFloat {
        34 - (12 * collapseProgress)
    }

    private var chipsOpacity: CGFloat {
        1 - min(collapseProgress * 1.45, 1)
    }

    private var chipsVerticalOffset: CGFloat {
        -16 * collapseProgress
    }

    private var chipsTopPadding: CGFloat {
        18 - (10 * collapseProgress)
    }

    private var glassPanel: some View {
        RoundedRectangle(cornerRadius: 30, style: .continuous)
            .fill(Color.scoutFeedHeaderBackground.opacity(0.74))
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 30, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.scoutGlassHighlightStrong,
                                Color.scoutGlassHighlightSoft.opacity(0.28),
                                Color.scoutAccentStart.opacity(0.10)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            .overlay(alignment: .topTrailing) {
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.scoutAccentEnd.opacity(0.18),
                                Color.clear
                            ],
                            center: .topTrailing,
                            startRadius: 8,
                            endRadius: 140
                        )
                    )
            }
    }

    private var glassStroke: some View {
        RoundedRectangle(cornerRadius: 30, style: .continuous)
            .stroke(
                LinearGradient(
                    colors: [
                        Color.scoutGlassHighlightStrong.opacity(1.1),
                        Color.scoutGlassStroke,
                        Color.scoutAccentStart.opacity(0.18)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                lineWidth: ScoutLayout.Stroke.hairline
            )
    }
}

private struct FeedCategoryFilterButtonStyle: ButtonStyle {
    let isSelected: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.scoutMicro)
            .foregroundStyle(isSelected ? Color.scoutBackground : Color.scoutTextPrimary.opacity(0.68))
            .padding(.horizontal, ScoutLayout.Spacing.md)
            .padding(.vertical, ScoutLayout.Spacing.sm)
            .background(isSelected ? Color.scoutOnImageTextPrimary : Color.scoutGlassFill.opacity(0.9), in: Capsule())
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(ScoutMotion.press, value: configuration.isPressed)
    }
}

#Preview {
    FeedScreen(vm: FeedViewModel())
}
