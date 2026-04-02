//
//  SwipeCardProviding.swift
//  Scout
//
//  Created by Codex on 4/1/26.
//

import Foundation

struct SwipeInteractionSummary: Equatable, Sendable {
    let candidateID: UUID
    var didLike: Bool
    var lastShownAt: Date?
}

struct SwipeRankingContext: Sendable {
    var currentUserID: UUID?
    var currentUserSignals: PlayerMatchSignals?
    var priorInteractions: [SwipeInteractionSummary]
    var candidateMetrics: [UUID: PlayerDerivedMetrics]
}

struct SwipeCandidateBatch: Sendable {
    var candidates: [SwipeCandidate]
    var rankingContext: SwipeRankingContext
}

protocol SwipeRankingProviding {
    func rankCandidates(
        _ candidates: [SwipeCandidate],
        using context: SwipeRankingContext
    ) async throws -> [SwipeCandidate]
}

protocol SwipeCardProviding {
    func fetchSwipeCandidates() async throws -> SwipeCandidateBatch
}
