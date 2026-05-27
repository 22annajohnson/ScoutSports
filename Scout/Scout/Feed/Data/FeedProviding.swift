//
//  FeedProviding.swift
//  Scout
//
//  Created by Codex on 5/5/26.
//

import Foundation

protocol FeedProviding {
    func fetchFeedPosts() async throws -> [FeedPreviewPost]
}

