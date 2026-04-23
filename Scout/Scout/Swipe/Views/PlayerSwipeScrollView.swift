//
//  PlayerSwipeScrollView.swift
//  Scout
//
//  Created by Anna on 2/19/26.
//

import SwiftUI

struct PlayerSwipeScrollView: View {
    let model: CardViewModel
    let onPass: () -> Void
    let onBoost: () -> Void
    let onLike: () -> Void
    private let presentation: SwipeCardPresentation

    init(
        model: CardViewModel,
        onPass: @escaping () -> Void = {},
        onBoost: @escaping () -> Void = {},
        onLike: @escaping () -> Void = {}
    ) {
        self.model = model
        self.onPass = onPass
        self.onBoost = onBoost
        self.onLike = onLike
        self.presentation = SwipeCardPresentation(model: model)
    }

    private let accent = Color.scoutAccentStart

    var body: some View {
        SwipeCardOverlayScrollLayout {
            PlayerBackgroundView(imageURL: presentation.heroImageURL, color: accent)
        } topBar: {
            topBar
        } content: {
            VStack(spacing: ScoutSpacing.lg) {
                identityPanel
                matchupSection
                RatingsView(stats: model.stats)
            }
        } dock: {
            ScoutActionDock(onPass: onPass, onBoost: onBoost, onLike: onLike)
        }
        .onAppear {
            UIScrollView.appearance().bounces = false
        }
        .onDisappear {
            UIScrollView.appearance().bounces = true
        }
    }

    private var topBar: some View {
        HStack(spacing: ScoutSpacing.sm) {
            GlassChip(title: "2.1 mi away")

            Spacer()

            GlassChip(title: "\(presentation.matchupScore) Match", style: .accent)
        }
    }

    private var identityPanel: some View {
        SwipeCardIdentitySection(
            name: presentation.name,
            age: presentation.displayAge,
            summaryLines: presentation.identitySummaryLines,
            intent: presentation.intent,
            score: presentation.matchupScore,
            tags: presentation.identityTags
        )
    }

    private var matchupSection: some View {
        SwipeCardMatchupSection(
            matchupScore: presentation.matchupScore,
            fitLabel: presentation.fitLabel,
            tiles: presentation.matchupTiles
        )
    }
}

#Preview {
    PlayerSwipeScrollView(model: randomMockCardViewModel())
}

private struct SwipeCardPresentation {
    let name: String
    let heroImageURL: URL
    let intent: String
    let displayAge: Int?
    let identitySummaryLines: [String]
    let identityTags: [SwipeCardTagItem]
    let matchupScore: Int
    let fitLabel: String
    let matchupTiles: [SwipeCardMatchupTile]

    init(model: CardViewModel) {
        self.name = model.name
        self.heroImageURL = model.heroImageURL
        self.intent = "Looking for competitive games"
        self.displayAge = 27
        self.identitySummaryLines = Self.summaryLines(from: model.bio)
        self.identityTags = [
            SwipeCardTagItem(title: "4.7 Competitive", style: .accent),
            SwipeCardTagItem(title: "Reliable", style: .info),
            SwipeCardTagItem(title: "Tue/Thu Nights"),
            SwipeCardTagItem(title: model.sports.first ?? "Pickleball")
        ]
        self.matchupScore = Self.matchupScore(from: model.stats)
        self.fitLabel = "Great fit"
        self.matchupTiles = [
            SwipeCardMatchupTile(title: "Sport", value: model.sports.first ?? "Pickleball"),
            SwipeCardMatchupTile(title: "Style", value: "Competitive"),
            SwipeCardMatchupTile(title: "Reliability", value: "High")
        ]
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
                "Loves fast doubles.",
                "Usually free Tue/Thu nights."
            ]
        }

        let sentences = bio
            .split(separator: ".")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .map { "\($0)." }

        return Array(sentences.prefix(3))
    }
}
