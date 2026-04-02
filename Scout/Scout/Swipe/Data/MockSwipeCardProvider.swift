//
//  MockSwipeCardProvider.swift
//  Scout
//
//  Created by Codex on 4/1/26.
//

import Foundation

struct MockSwipeCardProvider: SwipeCardProviding {
    private let rankingProvider: SwipeRankingProviding

    init(rankingProvider: SwipeRankingProviding = MockSwipeRankingProvider()) {
        self.rankingProvider = rankingProvider
    }

    func fetchSwipeCandidates() async throws -> SwipeCandidateBatch {
        let candidates = getMockSwipeCandidates()
        let context = makeMockRankingContext(for: candidates)
        let rankedCandidates = try await rankingProvider.rankCandidates(candidates, using: context)
        return SwipeCandidateBatch(candidates: rankedCandidates, rankingContext: context)
    }

    private func makeMockRankingContext(for candidates: [SwipeCandidate]) -> SwipeRankingContext {
        let candidateMetrics = Dictionary(
            uniqueKeysWithValues: candidates.map { candidate in
                (
                    candidate.id,
                    PlayerDerivedMetrics(
                        id: candidate.id.uuidString,
                        friendlinessScore: Double.random(in: 2.0...5.0),
                        competitivenessScore: Double.random(in: 2.0...5.0),
                        vibesScore: Double.random(in: 2.0...5.0),
                        reliabilityScore: Double.random(in: 2.0...5.0),
                        skillConfidence: Double.random(in: 2.0...5.0),
                        repeatPlayRate: Double.random(in: 2.0...5.0)
                    )
                )
            }
        )

        let interactions = candidates.prefix(3).map { candidate in
            SwipeInteractionSummary(
                candidateID: candidate.id,
                didLike: Bool.random(),
                lastShownAt: Date().addingTimeInterval(Double.random(in: -86_400 ... 0))
            )
        }

        let currentUserSignals = PlayerMatchSignals(
            id: UUID().uuidString,
            competitivenessRating: 3,
            friendlinessRating: 4,
            socialVibeRating: 4,
            preferredMatchIntensity: "balanced",
            preferredFormats: [],
            travelRadiusMiles: nil,
            availabilitySummary: nil
        )

        return SwipeRankingContext(
            currentUserID: nil,
            currentUserSignals: currentUserSignals,
            priorInteractions: interactions,
            candidateMetrics: candidateMetrics
        )
    }
}

struct MockSwipeRankingProvider: SwipeRankingProviding {
    func rankCandidates(
        _ candidates: [SwipeCandidate],
        using context: SwipeRankingContext
    ) async throws -> [SwipeCandidate] {
        candidates.sorted { lhs, rhs in
            let lhsScore = score(for: lhs, using: context)
            let rhsScore = score(for: rhs, using: context)
            if lhsScore == rhsScore {
                return lhs.displayName < rhs.displayName
            }
            return lhsScore > rhsScore
        }
    }

    private func score(for candidate: SwipeCandidate, using context: SwipeRankingContext) -> Double {
        let metrics = context.candidateMetrics[candidate.id]
        let vibe = metrics?.vibesScore ?? 0
        let reliability = metrics?.reliabilityScore ?? 0
        let competitiveness = metrics?.competitivenessScore ?? 0

        let repeatPenalty: Double
        if context.priorInteractions.contains(where: { $0.candidateID == candidate.id }) {
            repeatPenalty = 0.5
        } else {
            repeatPenalty = 0
        }

        return vibe + reliability + competitiveness - repeatPenalty
    }
}
