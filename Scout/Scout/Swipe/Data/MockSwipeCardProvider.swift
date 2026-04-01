//
//  MockSwipeCardProvider.swift
//  Scout
//
//  Created by Codex on 4/1/26.
//

import Foundation

struct MockSwipeCardProvider: SwipeCardProviding {
    func fetchCards() async throws -> [CardViewModel] {
        getMockCardViewModels()
    }
}
