//
//  CardViewModel.swift
//  Scout
//
//  Created by Anna on 2/19/26.
//

import Foundation

struct CardViewModel: Identifiable {
    let id: UUID = UUID()
    var name: String
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
