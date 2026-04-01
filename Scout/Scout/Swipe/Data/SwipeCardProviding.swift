//
//  SwipeCardProviding.swift
//  Scout
//
//  Created by Codex on 4/1/26.
//

import Foundation

protocol SwipeCardProviding {
    func fetchCards() async throws -> [CardViewModel]
}
