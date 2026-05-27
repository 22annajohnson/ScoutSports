//
//  MockFeedProvider.swift
//  Scout
//
//  Created by Codex on 5/5/26.
//

import Foundation

struct MockFeedProvider: FeedProviding {
    func fetchFeedPosts() async throws -> [FeedPreviewPost] {
        FeedPreviewPost.mockPosts
    }
}

