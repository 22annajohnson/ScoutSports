//
//  FeedViewModel.swift
//  Scout
//
//  Created by Codex on 4/29/26.
//

import Foundation
import Observation

@MainActor
@Observable
final class FeedViewModel {
    enum ViewState: Equatable {
        case loading
        case loaded
        case empty
        case error(message: String)
    }

    private(set) var viewState: ViewState = .loading
    private(set) var posts: [FeedPreviewPost] = []
    var selectedCategory: FeedPostCategory = .all
    private var hasLoaded = false

    var visiblePosts: [FeedPreviewPost] {
        guard selectedCategory != .all else { return posts }
        return posts.filter { $0.category == selectedCategory }
    }

    var availableCategories: [FeedPostCategory] {
        let presentCategories = Set(posts.map(\.category))
        return FeedPostCategory.allCases.filter { $0 == .all || presentCategories.contains($0) }
    }

    func loadIfNeeded() async {
        guard !hasLoaded else { return }
        hasLoaded = true

        posts = FeedPreviewPost.mockPosts
        viewState = posts.isEmpty ? .empty : .loaded
    }

    func selectCategory(_ category: FeedPostCategory) {
        selectedCategory = category
    }
}
