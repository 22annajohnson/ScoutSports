//
//  FeedPreviewPost.swift
//  Scout
//
//  Created by Codex on 4/29/26.
//

import Foundation
import SwiftUI

enum FeedPostCategory: String, CaseIterable, Identifiable {
    case all
    case matchup
    case sponsored
    case gear
    case matchUpdate
    case achievement
    case stat
    case rivalry
    case hotspot

    var id: String { rawValue }

    var title: String {
        switch self {
        case .all:
            return "All"
        case .matchup:
            return "Matchup"
        case .sponsored:
            return "Sponsored"
        case .gear:
            return "Gear"
        case .matchUpdate:
            return "Match Update"
        case .achievement:
            return "Achievement"
        case .stat:
            return "Stat"
        case .rivalry:
            return "Rivalry"
        case .hotspot:
            return "Hotspot"
        }
    }
}

struct FeedProfileSnippet: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let score: Int
    let avatarURL: URL?
}

struct FeedPreviewPost: Identifiable, Equatable {
    struct Metric: Identifiable, Equatable {
        let id = UUID()
        let label: String
        let value: String
    }

    struct Team: Identifiable, Equatable {
        let id = UUID()
        let name: String
        let odds: Int
        let members: [FeedProfileSnippet]
    }

    struct RivalryRecord: Identifiable, Equatable {
        let id = UUID()
        let player: FeedProfileSnippet
        let record: String
    }

    enum AccentStyle: Equatable {
        case violetCyan
        case emeraldCyan
        case fuchsiaViolet
        case cyanBlue
        case orangePink
        case amberOrange
        case blueViolet
        case redFuchsia

        var gradient: LinearGradient {
            LinearGradient(
                colors: colors,
                startPoint: .leading,
                endPoint: .trailing
            )
        }

        var colors: [Color] {
            switch self {
            case .violetCyan:
                return [Color.scoutGradientViolet, Color.scoutGradientCyan]
            case .emeraldCyan:
                return [Color.scoutGradientEmerald, Color.scoutGradientSky]
            case .fuchsiaViolet:
                return [Color.scoutGradientFuchsia, Color.scoutGradientViolet]
            case .cyanBlue:
                return [Color.scoutGradientCyan, Color.scoutGradientBlue]
            case .orangePink:
                return [Color.scoutGradientOrange, Color.scoutGradientPink]
            case .amberOrange:
                return [Color.scoutGradientAmber, Color.scoutGradientTangerine]
            case .blueViolet:
                return [Color.scoutGradientPeriwinkle, Color.scoutGradientViolet]
            case .redFuchsia:
                return [Color.scoutGradientCoral, Color.scoutGradientFuchsia]
            }
        }
    }

    enum Kind: Equatable {
        case upcomingMatchup(teams: [Team], featuredPlayers: [FeedProfileSnippet])
        case image(imageURL: URL?, statLabel: String, ctaTitle: String?, relevanceLabel: String)
        case matchUpdate(winner: FeedProfileSnippet, loser: FeedProfileSnippet, score: String)
        case achievement(symbol: String, progress: Int, next: Int)
        case stat(metrics: [Metric])
        case rivalry(records: [RivalryRecord])
        case hotspot(pills: [String])
    }

    let id: String
    let category: FeedPostCategory
    let typeTitle: String
    let eyebrow: String
    let title: String
    let description: String
    let tag: String
    let accent: AccentStyle
    let kind: Kind
    let isSponsored: Bool
}

extension FeedPreviewPost {
    static let activeFilters = ["Pickleball", "Portland", "Beginner+", "Doubles"]

    private static let players: [String: FeedProfileSnippet] = [
        "anna": .init(
            name: "Anna",
            score: 92,
            avatarURL: URL(string: "https://picsum.photos/seed/scout-anna/400/400")
        ),
        "mia": .init(
            name: "Mia",
            score: 96,
            avatarURL: URL(string: "https://picsum.photos/seed/scout-mia/400/400")
        ),
        "jake": .init(
            name: "Jake",
            score: 90,
            avatarURL: URL(string: "https://picsum.photos/seed/scout-jake/400/400")
        ),
        "noah": .init(
            name: "Noah",
            score: 88,
            avatarURL: URL(string: "https://picsum.photos/seed/scout-noah/400/400")
        )
    ]

    private static func player(_ id: String) -> FeedProfileSnippet {
        guard let player = players[id] else {
            preconditionFailure("Missing mock feed player for id: \(id)")
        }

        return player
    }

    static let mockPosts: [FeedPreviewPost] = [
        FeedPreviewPost(
            id: "matchup",
            category: .matchup,
            typeTitle: "Upcoming Matchup",
            eyebrow: "Tonight · 6:30 PM",
            title: "Anna + Noah vs Mia + Jake",
            description: "Vote who takes the set before first serve.",
            tag: "Prediction open",
            accent: .violetCyan,
            kind: .upcomingMatchup(
                teams: [
                    .init(name: "Anna + Noah", odds: 58, members: [player("anna"), player("noah")]),
                    .init(name: "Mia + Jake", odds: 42, members: [player("mia"), player("jake")])
                ],
                featuredPlayers: [player("anna"), player("noah"), player("mia"), player("jake")]
            ),
            isSponsored: false
        ),
        FeedPreviewPost(
            id: "ad-court",
            category: .sponsored,
            typeTitle: "Sponsored Court",
            eyebrow: "Sponsored · Portland pickleball",
            title: "Baseline Social has open courts tonight",
            description: "Book a court, grab a drink after, and get 20% off your first reservation through Scout.",
            tag: "Local court",
            accent: .emeraldCyan,
            kind: .image(
                imageURL: URL(string: "https://picsum.photos/seed/scout-court/1200/900"),
                statLabel: "Local court",
                ctaTitle: "Book court",
                relevanceLabel: "Relevant to pickleball"
            ),
            isSponsored: true
        ),
        FeedPreviewPost(
            id: "gear",
            category: .gear,
            typeTitle: "Equipment Upgrade",
            eyebrow: "Anna upgraded gear",
            title: "New paddle day",
            description: "Testing a lighter control paddle for faster kitchen hands.",
            tag: "Gear flex",
            accent: .fuchsiaViolet,
            kind: .image(
                imageURL: URL(string: "https://picsum.photos/seed/scout-gear/1200/900"),
                statLabel: "Control build",
                ctaTitle: nil,
                relevanceLabel: "Equipment"
            ),
            isSponsored: false
        ),
        FeedPreviewPost(
            id: "match-update",
            category: .matchUpdate,
            typeTitle: "Match Update",
            eyebrow: "Final · Baseline Social",
            title: "Mia def. Jake",
            description: "Clean match, chaotic rallies, and one absolutely disrespectful ATP.",
            tag: "Score + vibes",
            accent: .cyanBlue,
            kind: .matchUpdate(
                winner: player("mia"),
                loser: player("jake"),
                score: "11-8 · 11-6"
            ),
            isSponsored: false
        ),
        FeedPreviewPost(
            id: "ad-restaurant",
            category: .sponsored,
            typeTitle: "Sponsored Local",
            eyebrow: "Sponsored · Post-match food",
            title: "Smoothie Bar is 0.4 mi away",
            description: "Show this Scout post after a logged match and get $3 off a recovery smoothie.",
            tag: "Nearby offer",
            accent: .orangePink,
            kind: .image(
                imageURL: URL(string: "https://picsum.photos/seed/scout-smoothie/1200/900"),
                statLabel: "Nearby offer",
                ctaTitle: "Claim offer",
                relevanceLabel: "Relevant nearby"
            ),
            isSponsored: true
        ),
        FeedPreviewPost(
            id: "achievement",
            category: .achievement,
            typeTitle: "Achievement",
            eyebrow: "Badge unlocked",
            title: "Traveller II",
            description: "Anna has now logged games at 25 different courts.",
            tag: "25 courts",
            accent: .amberOrange,
            kind: .achievement(symbol: "⌖", progress: 25, next: 50),
            isSponsored: false
        ),
        FeedPreviewPost(
            id: "stat",
            category: .stat,
            typeTitle: "Stat Post",
            eyebrow: "Monthly recap",
            title: "Anna is on a heater",
            description: "Best 30-day stretch yet: higher win rate, better reliability, and a +4 Scout Score jump.",
            tag: "Boast unlocked",
            accent: .violetCyan,
            kind: .stat(metrics: [
                .init(label: "Win Rate", value: "72%"),
                .init(label: "Score", value: "+4"),
                .init(label: "Games", value: "18")
            ]),
            isSponsored: false
        ),
        FeedPreviewPost(
            id: "ad-store",
            category: .sponsored,
            typeTitle: "Sponsored Gear",
            eyebrow: "Sponsored · Pickleball gear",
            title: "PaddlePro: 15% off court shoes",
            description: "Recommended for players filtering by pickleball, doubles, and outdoor courts.",
            tag: "Online store",
            accent: .blueViolet,
            kind: .image(
                imageURL: URL(string: "https://picsum.photos/seed/scout-store/1200/900"),
                statLabel: "Online store",
                ctaTitle: "Shop deal",
                relevanceLabel: "Recommended gear"
            ),
            isSponsored: true
        ),
        FeedPreviewPost(
            id: "rivalry",
            category: .rivalry,
            typeTitle: "Rivalry Post",
            eyebrow: "Rivalry heating up",
            title: "Anna vs Mia is now 4-4",
            description: "Next match breaks the tie.",
            tag: "Series tied",
            accent: .redFuchsia,
            kind: .rivalry(records: [
                .init(player: player("anna"), record: "Anna 4"),
                .init(player: player("mia"), record: "Mia 4")
            ]),
            isSponsored: false
        ),
        FeedPreviewPost(
            id: "hotspot",
            category: .hotspot,
            typeTitle: "Hotspot Post",
            eyebrow: "Live nearby",
            title: "Eastern Prom is active right now",
            description: "6 players checked in, 2 courts open, and a beginner+ group forming soon.",
            tag: "Hotspot live",
            accent: .emeraldCyan,
            kind: .hotspot(pills: ["6 checked in", "2 courts open", "Beginner+"]),
            isSponsored: false
        )
    ]
}
