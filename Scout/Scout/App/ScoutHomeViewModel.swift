//
//  ScoutHomeViewModel.swift
//  Scout
//
//  Created by Codex on 4/29/26.
//

import Foundation
import Observation

enum ScoutHomeTab: String, CaseIterable, Hashable {
    case swipe
    case feed

    var title: String {
        switch self {
        case .swipe:
            return "Swipe"
        case .feed:
            return "Feed"
        }
    }

    var systemImage: String {
        switch self {
        case .swipe:
            return "bolt.fill"
        case .feed:
            return "newspaper.fill"
        }
    }
}

enum ScoutHomeChromeMode: Equatable {
    case expanded
    case condensed
}

enum ScoutHomeNavigationStyle: Equatable {
    case bar
    case bubble
}

enum ScoutHomeNavigationVisibility: Equatable {
    case shown
    case hidden
}

@MainActor
@Observable
final class ScoutHomeViewModel {
    var selectedTab: ScoutHomeTab = .swipe
    var chromeMode: ScoutHomeChromeMode = .expanded
    var navigationVisibility: ScoutHomeNavigationVisibility = .shown
    var isSwipeMenuExpanded: Bool = false

    private var previousScrollOffset: CGFloat = 0

    func select(tab: ScoutHomeTab) {
        selectedTab = tab
        chromeMode = .expanded
        navigationVisibility = .shown
        isSwipeMenuExpanded = false
        previousScrollOffset = 0
    }

    func updateChrome(for scrollOffset: CGFloat) {
        let nextMode: ScoutHomeChromeMode = scrollOffset > 24 ? .condensed : .expanded
        if nextMode != chromeMode {
            chromeMode = nextMode
        }

        let clampedOffset = max(0, scrollOffset)
        let delta = clampedOffset - previousScrollOffset
        previousScrollOffset = clampedOffset

        guard abs(delta) > 8 else { return }

        if delta > 0 {
            navigationVisibility = .hidden
            if selectedTab == .swipe {
                isSwipeMenuExpanded = false
            }
        } else {
            navigationVisibility = .shown
        }
    }

    func resetChrome() {
        chromeMode = .expanded
        navigationVisibility = .shown
        isSwipeMenuExpanded = false
        previousScrollOffset = 0
    }

    func toggleSwipeMenu() {
        guard selectedTab == .swipe else { return }
        navigationVisibility = .shown
        isSwipeMenuExpanded.toggle()
    }

    var navigationStyle: ScoutHomeNavigationStyle {
        if selectedTab == .swipe && !isSwipeMenuExpanded {
            return .bubble
        }

        return .bar
    }
}
