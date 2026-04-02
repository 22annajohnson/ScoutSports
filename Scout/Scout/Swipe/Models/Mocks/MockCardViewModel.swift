//
//  MockCardViewModel.swift
//  Scout
//
//  Created by Anna on 2/19/26.
//

import Foundation

func getMockSwipeCandidates() -> [SwipeCandidate] {
    var models: [SwipeCandidate] = []
    for _ in 0..<10 {
        models.append(randomMockSwipeCandidate())
    }
    return models
}

func randomMockSwipeCandidate() -> SwipeCandidate {
    SwipeCandidate(
        id: UUID(),
        displayName: getRandomName(),
        sports: getRandomSports(),
        heroImageURL: URL(string:"https://picsum.photos/400/800")!,
        stats: getRandomStats(),
        didLike: Bool.random()
    )
}

func randomMockCardViewModel() -> CardViewModel {
    randomMockSwipeCandidate().toCardViewModel()
}

func getRandomName() -> String {
    let names = ["Anna", "Noah", "Goose", "Sir Charles", "Scoopers"]
    return names[Int.random(in: 0..<names.self.count)]
}

func getRandomSports() -> [String] {
    let sports = ["Tennis", "Basketball", "Pickleball", "Golf"]
    return [sports.randomElement()!, sports.randomElement()!]
}

func getRandomStats() -> [StatsViewModel] {
    let stats = [
        StatsViewModel(statType: .vibe, rating: Int.random(in: 0..<6), totalReviews: Int.random(in: 0...25), reviews: []),
        StatsViewModel(statType: .intensity, rating: Int.random(in: 0..<6), totalReviews: Int.random(in: 0...25), reviews: []),
        StatsViewModel(statType: .consistency, rating: Int.random(in: 0..<6), totalReviews: Int.random(in: 0...25), reviews: []),
        StatsViewModel(statType: .skill, rating: Int.random(in: 0..<6), totalReviews: Int.random(in: 0...25), reviews: [])
    ]
    
    return stats
}
