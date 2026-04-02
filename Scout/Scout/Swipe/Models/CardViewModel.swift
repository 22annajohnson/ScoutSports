//
//  CardViewModel.swift
//  Scout
//
//  Created by Anna on 2/19/26.
//

import Foundation

struct SwipeCandidate: Identifiable {
    let id: UUID
    var displayName: String
    var bio: String?
    var sports: [String]
    var heroImageURL: URL
    var stats: [StatsViewModel]
    var didLike: Bool
}

struct CardViewModel: Identifiable {
    let id: UUID = UUID()
    var name: String
    var bio: String?
    var sports: [String]
    var heroImageURL: URL
    var stats: [StatsViewModel]
    var didLike: Bool
}

struct StatsViewModel: Identifiable {
    let id: UUID = UUID()
    var statType: StatType
    var rating: Int
    var totalReviews: Int
    var reviews: [ReviewViewModel]
}

struct ReviewViewModel {
    var username: String
    var rating: Int
    var comment: String
}

extension SwipeCandidate {
    func toCardViewModel() -> CardViewModel {
        CardViewModel(
            name: displayName,
            bio: bio,
            sports: sports,
            heroImageURL: heroImageURL,
            stats: stats,
            didLike: didLike
        )
    }
}
