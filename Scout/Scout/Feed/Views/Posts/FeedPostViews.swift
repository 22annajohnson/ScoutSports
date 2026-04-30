//
//  FeedPostViews.swift
//  Scout
//
//  Created by Codex on 4/29/26.
//

import SwiftUI

struct FeedPostCard: View {
    let post: FeedPreviewPost

    var body: some View {
        switch post.kind {
        case let .upcomingMatchup(teams, featuredPlayers):
            FeedUpcomingMatchupPost(post: post, teams: teams, featuredPlayers: featuredPlayers)
        case let .image(imageURL, statLabel, ctaTitle, relevanceLabel):
            FeedImagePost(post: post, imageURL: imageURL, statLabel: statLabel, ctaTitle: ctaTitle, relevanceLabel: relevanceLabel)
        case let .matchUpdate(winner, loser, score):
            FeedMatchUpdatePost(post: post, winner: winner, loser: loser, score: score)
        case let .achievement(symbol, progress, next):
            FeedAchievementPost(post: post, symbol: symbol, progress: progress, next: next)
        case let .stat(metrics):
            FeedStatPost(post: post, metrics: metrics)
        case let .rivalry(records):
            FeedRivalryPost(post: post, records: records)
        case let .hotspot(pills):
            FeedHotspotPost(post: post, pills: pills)
        }
    }
}
