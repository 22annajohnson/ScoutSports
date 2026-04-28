//
//  PlayerSwipeCardViewModel.swift
//  Scout
//
//  Created by Codex on 4/27/26.
//

import Foundation

struct PlayerSwipeCardViewModel {
    let heroImageURL: URL
    let screenTitle: String
    let distanceLabel: String
    let identitySection: SwipeCardIdentitySection.Model
    let bestOverlapSection: SwipeBestOverlapTeaser.Model

    init(card: CardViewModel) {
        self.heroImageURL = card.heroImageURL
        self.screenTitle = "Find your next match"
        self.distanceLabel = "2.1 mi away"
        self.identitySection = Self.makeIdentitySection(from: card)
        self.bestOverlapSection = Self.makeBestOverlapSection()
    }

    private static func makeIdentitySection(from card: CardViewModel) -> SwipeCardIdentitySection.Model {
        .init(
            name: card.name,
            age: 27,
            summaryLines: summaryLines(from: card.bio),
            intent: "Competitive games",
            score: matchupScore(from: card.stats),
            tags: [
                SwipeCardTagItem(title: "4.7 Competitive", style: .accent),
                SwipeCardTagItem(title: "Reliable", style: .info),
                SwipeCardTagItem(title: "Tue/Thu Nights"),
                SwipeCardTagItem(title: card.sports.first ?? "Pickleball")
            ],
            highlights: [
                SwipeHighlightTile(title: "Skill", value: skillValue(from: card.stats), progress: 0.78),
                SwipeHighlightTile(title: "Matches", value: "38", progress: 0.64),
                SwipeHighlightTile(title: "Win Rate", value: "71%", progress: 0.81)
            ]
        )
    }

    private static func makeBestOverlapSection() -> SwipeBestOverlapTeaser.Model {
        .init(
            title: "Best Overlap",
            tags: [
                SwipeCardTagItem(title: "Competitive"),
                SwipeCardTagItem(title: "Late Night")
            ],
            value: "92%",
            bars: [
                SwipeOverlapBar(label: "M", value: 0.42),
                SwipeOverlapBar(label: "T", value: 0.14),
                SwipeOverlapBar(label: "W", value: 0.26),
                SwipeOverlapBar(label: "T", value: 0.86),
                SwipeOverlapBar(label: "F", value: 0.72),
                SwipeOverlapBar(label: "S", value: 0.12),
                SwipeOverlapBar(label: "S", value: 0.36)
            ]
        )
    }

    private static func matchupScore(from stats: [StatsViewModel]) -> Int {
        let cappedStars = stats.map { min(max($0.rating, 0), 5) }
        guard !cappedStars.isEmpty else { return 82 }
        let normalized = cappedStars.reduce(0, +) * 100 / (cappedStars.count * 5)
        return max(72, normalized)
    }

    private static func summaryLines(from bio: String?) -> [String] {
        guard let bio = bio?.trimmingCharacters(in: .whitespacesAndNewlines), !bio.isEmpty else {
            return [
                "Aggressive at the net.",
                "Looking for competitive games and late night runs."
            ]
        }

        let sentences = bio
            .split(separator: ".")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .map { "\($0)." }

        return Array(sentences.prefix(3))
    }

    private static func skillValue(from stats: [StatsViewModel]) -> String {
        guard !stats.isEmpty else { return "4.3" }
        let total = Double(stats.reduce(0) { $0 + $1.rating })
        let average = total / Double(stats.count)
        return String(format: "%.1f", average)
    }
}
