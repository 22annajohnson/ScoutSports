//
//  ScoutHomeScreen.swift
//  Scout
//
//  Created by Codex on 4/29/26.
//

import SwiftUI
import ScoutDesign

struct ScoutHomeScreen: View {
    @State private var vm = ScoutHomeViewModel()
    @State private var swipeViewModel: SwipeDeckViewModel
    @State private var feedViewModel: FeedViewModel

    init(
        swipeViewModel: SwipeDeckViewModel,
        feedViewModel: FeedViewModel
    ) {
        _swipeViewModel = State(initialValue: swipeViewModel)
        _feedViewModel = State(initialValue: feedViewModel)
    }

    var body: some View {
        @Bindable var vm = vm

        ZStack(alignment: .bottom) {
            activeScreen
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            ScoutBottomNavigationBar(
                selectedTab: vm.selectedTab,
                navigationStyle: vm.navigationStyle,
                visibility: vm.navigationVisibility,
                chromeMode: vm.chromeMode,
                onSelect: vm.select(tab:),
                onToggleMenu: vm.toggleSwipeMenu
            )
            .padding(.horizontal, ScoutLayout.Spacing.lg)
            .padding(.bottom, ScoutLayout.Spacing.md)
        }
        .background(ScoutTheme.screenBackground.ignoresSafeArea())
        .animation(ScoutMotion.selection, value: vm.selectedTab)
        .animation(ScoutMotion.selection, value: vm.chromeMode)
        .animation(ScoutMotion.selection, value: vm.navigationStyle)
        .animation(ScoutMotion.selection, value: vm.navigationVisibility)
    }

    @ViewBuilder
    private var activeScreen: some View {
        switch vm.selectedTab {
        case .swipe:
            SwipeDeckScreen(
                vm: swipeViewModel,
                bottomContentInset: 0,
                onScrollOffsetChange: vm.updateChrome(for:)
            )
        case .feed:
            FeedScreen(
                vm: feedViewModel,
                bottomContentInset: ScoutChrome.bottomBarReservedHeight,
                onScrollOffsetChange: vm.updateChrome(for:)
            )
        }
    }
}

#Preview {
    let appEnvironment = AppEnvironment.preview

    ScoutHomeScreen(
        swipeViewModel: appEnvironment.makeSwipeDeckViewModel(session: appEnvironment.makeSessionStore()),
        feedViewModel: appEnvironment.makeFeedViewModel()
    )
    .environment(\.appEnvironment, appEnvironment)
    .environment(appEnvironment.makeSessionStore())
}
