//
//  FeedScreen.swift
//  Scout
//
//  Created by Codex on 4/29/26.
//

import SwiftUI
import ScoutDesign

private enum FeedHeaderMetrics {
    static let expandedHeight: CGFloat = 144
    static let collapsedHeight: CGFloat = 92
    static let collapseRange: CGFloat = 120
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
                        returnSignals: vm.returnSignals,
                        visiblePosts: vm.visiblePosts,
                        innerCircleProfiles: vm.innerCircleProfiles,
                        innerCirclePosts: vm.innerCirclePosts,
                        hasInnerCircleSection: vm.hasInnerCircleSection,
                        selectedSport: vm.filterState.sport,
                        selectedLocation: vm.filterState.location
                    )
                }
            }

            FeedCollapsibleHeaderView(
                filterState: vm.filterState,
                availableCategories: vm.availableCategories,
                availableSports: vm.availableSports,
                availableLocations: vm.availableLocations,
                collapseProgress: headerCollapseProgress,
                onSelectCircle: vm.selectCircle(_:),
                onSelectSport: vm.selectSport(_:),
                onSelectLocation: vm.selectLocation(_:),
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
        returnSignals: [FeedReturnSignal],
        visiblePosts: [FeedPreviewPost],
        innerCircleProfiles: [FeedProfileSnippet],
        innerCirclePosts: [FeedPreviewPost],
        hasInnerCircleSection: Bool,
        selectedSport: FeedSportFilter,
        selectedLocation: FeedLocationFilter
    ) -> some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(alignment: .leading, spacing: ScoutLayout.Spacing.lg) {
                Color.clear
                    .frame(height: FeedHeaderMetrics.expandedHeight)

                FeedReturnSection(signals: returnSignals)

                if hasInnerCircleSection {
                    FeedInnerCircleSection(
                        profiles: innerCircleProfiles,
                        posts: innerCirclePosts,
                        selectedSport: selectedSport,
                        selectedLocation: selectedLocation
                    )
                }

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
    @State private var isFilterMenuOpen = false

    let filterState: FeedFilterState
    let availableCategories: [FeedPostCategory]
    let availableSports: [FeedSportFilter]
    let availableLocations: [FeedLocationFilter]
    let collapseProgress: CGFloat
    let onSelectCircle: (FeedCircleFilter) -> Void
    let onSelectSport: (FeedSportFilter) -> Void
    let onSelectLocation: (FeedLocationFilter) -> Void
    let onSelectCategory: (FeedPostCategory) -> Void

    var body: some View {
        VStack {
            ZStack(alignment: .topTrailing) {
                VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: ScoutLayout.Spacing.xs) {
                        Text("SCOUT")
                            .font(.scoutMicro)
                            .tracking(ScoutLayout.Tracking.labelCaps)
                            .foregroundStyle(Color.scoutTextSecondary)
                        Text("Feed")
                            .font(collapseProgress > 0.45 ? .scoutTitleCompact : .scoutHeroTitle)
                            .foregroundStyle(Color.scoutTextPrimary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.88)

                        Text(filterSummary)
                            .font(.scoutCaption)
                            .foregroundStyle(Color.scoutTextSecondary)
                            .opacity(summaryOpacity)
                    }

                    Spacer()

                    Button {
                        withAnimation(ScoutMotion.selection) {
                            isFilterMenuOpen.toggle()
                        }
                    } label: {
                        Image(systemName: isFilterMenuOpen ? "xmark" : "slider.horizontal.3")
                            .font(.scoutCallout)
                            .foregroundStyle(Color.scoutTextPrimary)
                            .frame(width: 58, height: 58)
                    }
                    .buttonStyle(.plain)
                    .background(
                        Circle()
                            .fill(Color.scoutGlassFill.opacity(0.95))
                            .background(.ultraThinMaterial, in: Circle())
                    )
                    .overlay(
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color.scoutGlassHighlightStrong,
                                        Color.scoutGlassStroke,
                                        Color.scoutAccentStart.opacity(0.18)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: ScoutLayout.Stroke.hairline
                            )
                    )
                    .shadow(color: Color.scoutShadowStrong.opacity(0.72), radius: 16, y: 8)
                }
                .padding(.top, ScoutLayout.Spacing.lg)
                }
                .padding(.horizontal, ScoutLayout.Spacing.lg)
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: headerHeight, alignment: .top)
                .background(glassPanel)
                .overlay(glassStroke)
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .shadow(color: Color.scoutShadowStrong.opacity(0.88), radius: 24, y: 14)

                if isFilterMenuOpen {
                    FeedFilterMenu(
                        filterState: filterState,
                        availableCategories: availableCategories,
                        availableSports: availableSports,
                        availableLocations: availableLocations,
                        onSelectCircle: onSelectCircle,
                        onSelectSport: onSelectSport,
                        onSelectLocation: onSelectLocation,
                        onSelectCategory: onSelectCategory
                    )
                    .frame(width: 312)
                    .padding(.top, 72)
                    .padding(.trailing, ScoutLayout.Spacing.md)
                    .transition(.asymmetric(
                        insertion: .opacity.combined(with: .scale(scale: 0.94, anchor: .topTrailing)),
                        removal: .opacity.combined(with: .scale(scale: 0.96, anchor: .topTrailing))
                    ))
                }
            }
        }
        .padding(.horizontal, ScoutLayout.Spacing.lg)
        .padding(.top, ScoutLayout.Spacing.sm)
    }

    private var headerHeight: CGFloat {
        FeedHeaderMetrics.expandedHeight - ((FeedHeaderMetrics.expandedHeight - FeedHeaderMetrics.collapsedHeight) * collapseProgress)
    }

    private var summaryOpacity: CGFloat {
        1 - min(collapseProgress * 1.6, 0.92)
    }

    private var filterSummary: String {
        "\(filterState.circle.title) • \(filterState.sport.title) • \(filterState.location.title)"
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

private struct FeedFilterMenu: View {
    let filterState: FeedFilterState
    let availableCategories: [FeedPostCategory]
    let availableSports: [FeedSportFilter]
    let availableLocations: [FeedLocationFilter]
    let onSelectCircle: (FeedCircleFilter) -> Void
    let onSelectSport: (FeedSportFilter) -> Void
    let onSelectLocation: (FeedLocationFilter) -> Void
    let onSelectCategory: (FeedPostCategory) -> Void

    var body: some View {
        GlassCard(padding: ScoutLayout.Spacing.md) {
            VStack(alignment: .leading, spacing: ScoutLayout.Spacing.md) {
                audienceSegmentedControl

                filterRow(title: "Sport") {
                    ForEach(availableSports) { sport in
                        Button(sport.title) {
                            onSelectSport(sport)
                        }
                        .buttonStyle(FeedCategoryFilterButtonStyle(isSelected: filterState.sport == sport))
                    }
                }

                filterRow(title: "Location") {
                    ForEach(availableLocations) { location in
                        Button(location.title) {
                            onSelectLocation(location)
                        }
                        .buttonStyle(FeedCategoryFilterButtonStyle(isSelected: filterState.location == location))
                    }
                }

                filterRow(title: "Post Type") {
                    ForEach(availableCategories) { category in
                        Button(category.title) {
                            onSelectCategory(category)
                        }
                        .buttonStyle(FeedCategoryFilterButtonStyle(isSelected: filterState.category == category))
                    }
                }
            }
        }
    }

    private var audienceSegmentedControl: some View {
        VStack(alignment: .leading, spacing: ScoutLayout.Spacing.sm) {
            Text("AUDIENCE")
                .font(.scoutLabelCaps)
                .tracking(ScoutLayout.Tracking.micro)
                .foregroundStyle(Color.scoutTextSecondary)

            ScoutSegmentedToggle(
                options: FeedCircleFilter.allCases,
                selection: filterState.circle,
                title: \.title,
                onSelect: onSelectCircle
            )
        }
    }

    private func filterRow<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: ScoutLayout.Spacing.sm) {
            Text(title.uppercased())
                .font(.scoutLabelCaps)
                .tracking(ScoutLayout.Tracking.micro)
                .foregroundStyle(Color.scoutTextSecondary)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: ScoutLayout.Spacing.sm) {
                    content()
                }
            }
        }
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
    FeedScreen(vm: FeedViewModel(feedProvider: MockFeedProvider()))
}
