//
//  DiscoveryContracts.swift
//  Scout
//
//  Created by Codex on 7/14/26.
//

import Foundation

struct CandidateCard: Identifiable, Equatable, Sendable {
    let id: UUID
    var displayName: String
    var profilePhotoPath: String?
    var primarySport: CandidateSportSummary
    var bioSummary: String?
    var availabilitySummary: String?
    var locationSummary: String?
    var contextLabels: [CandidateContextLabel]
    var allowedActions: Set<CandidateAction>

    init(
        id: UUID,
        displayName: String,
        profilePhotoPath: String? = nil,
        primarySport: CandidateSportSummary,
        bioSummary: String? = nil,
        availabilitySummary: String? = nil,
        locationSummary: String? = nil,
        contextLabels: [CandidateContextLabel] = [],
        allowedActions: Set<CandidateAction> = CandidateAction.defaultQueueActions
    ) {
        self.id = id
        self.displayName = displayName
        self.profilePhotoPath = profilePhotoPath
        self.primarySport = primarySport
        self.bioSummary = bioSummary
        self.availabilitySummary = availabilitySummary
        self.locationSummary = locationSummary
        self.contextLabels = contextLabels
        self.allowedActions = allowedActions
    }
}

struct CandidateSportSummary: Equatable, Sendable {
    var sportSlug: String
    var displayName: String
    var skillSummary: String?
}

struct CandidateContextLabel: Identifiable, Equatable, Sendable {
    enum Kind: Equatable, Sendable {
        case sportCompatibility
        case skillCompatibility
        case availability
        case location
        case profileCompleteness
    }

    let id: String
    var kind: Kind
    var text: String

    init(kind: Kind, text: String) {
        self.kind = kind
        self.text = text
        self.id = "\(kind)-\(text)"
    }
}

enum CandidateAction: String, CaseIterable, Equatable, Hashable, Sendable {
    case pass
    case like
    case viewProfile
    case report

    static let defaultQueueActions: Set<CandidateAction> = [
        .pass,
        .like,
        .viewProfile,
        .report
    ]
}

struct DiscoveryQueue: Identifiable, Equatable, Sendable {
    let id: UUID
    var state: DiscoveryQueueState
    var candidates: [CandidateCard]
    var metadata: DiscoveryQueueMetadata
    var emptyReason: DiscoveryEmptyReason?
    var exhaustedReason: DiscoveryExhaustedReason?
    var failure: DiscoveryQueueFailure?
    var canRefresh: Bool
    var retryGuidance: DiscoveryRetryGuidance?

    init(
        id: UUID = UUID(),
        state: DiscoveryQueueState = .idle,
        candidates: [CandidateCard] = [],
        metadata: DiscoveryQueueMetadata = DiscoveryQueueMetadata(),
        emptyReason: DiscoveryEmptyReason? = nil,
        exhaustedReason: DiscoveryExhaustedReason? = nil,
        failure: DiscoveryQueueFailure? = nil,
        canRefresh: Bool = true,
        retryGuidance: DiscoveryRetryGuidance? = nil
    ) {
        self.id = id
        self.state = state
        self.candidates = candidates
        self.metadata = metadata
        self.emptyReason = emptyReason
        self.exhaustedReason = exhaustedReason
        self.failure = failure
        self.canRefresh = canRefresh
        self.retryGuidance = retryGuidance
    }
}

extension DiscoveryQueue {
    static func loading(
        id: UUID = UUID(),
        requestedAt: Date = Date()
    ) -> DiscoveryQueue {
        DiscoveryQueue(
            id: id,
            state: .loading,
            metadata: DiscoveryQueueMetadata(requestedAt: requestedAt),
            canRefresh: false
        )
    }

    static func ready(
        id: UUID = UUID(),
        candidates: [CandidateCard],
        generatedAt: Date = Date(),
        activeSportSlug: String? = nil
    ) -> DiscoveryQueue {
        DiscoveryQueue(
            id: id,
            state: .ready,
            candidates: candidates,
            metadata: DiscoveryQueueMetadata(
                generatedAt: generatedAt,
                activeSportSlug: activeSportSlug,
                candidateCount: candidates.count
            )
        )
    }

    static func empty(
        id: UUID = UUID(),
        reason: DiscoveryEmptyReason,
        generatedAt: Date = Date(),
        canRefresh: Bool = true
    ) -> DiscoveryQueue {
        DiscoveryQueue(
            id: id,
            state: .empty,
            metadata: DiscoveryQueueMetadata(generatedAt: generatedAt),
            emptyReason: reason,
            canRefresh: canRefresh
        )
    }

    static func exhausted(
        id: UUID = UUID(),
        candidates: [CandidateCard] = [],
        reason: DiscoveryExhaustedReason,
        generatedAt: Date = Date(),
        canRefresh: Bool = true
    ) -> DiscoveryQueue {
        DiscoveryQueue(
            id: id,
            state: .exhausted,
            candidates: candidates,
            metadata: DiscoveryQueueMetadata(
                generatedAt: generatedAt,
                candidateCount: candidates.count,
                presentedCandidateIDs: Set(candidates.map(\.id))
            ),
            exhaustedReason: reason,
            canRefresh: canRefresh
        )
    }

    static func refreshing(
        existing queue: DiscoveryQueue,
        requestedAt: Date = Date()
    ) -> DiscoveryQueue {
        DiscoveryQueue(
            id: queue.id,
            state: .refreshing,
            candidates: queue.candidates,
            metadata: queue.metadata.refreshing(requestedAt: requestedAt),
            canRefresh: false
        )
    }

    static func failed(
        id: UUID = UUID(),
        failure: DiscoveryQueueFailure,
        retryGuidance: DiscoveryRetryGuidance? = .manualRetry,
        requestedAt: Date = Date()
    ) -> DiscoveryQueue {
        DiscoveryQueue(
            id: id,
            state: .failed,
            metadata: DiscoveryQueueMetadata(requestedAt: requestedAt),
            failure: failure,
            canRefresh: retryGuidance != nil,
            retryGuidance: retryGuidance
        )
    }
}

enum DiscoveryQueueState: Equatable, Sendable {
    case idle
    case loading
    case ready
    case empty
    case exhausted
    case refreshing
    case failed
}

struct DiscoveryQueueMetadata: Equatable, Sendable {
    var requestedAt: Date?
    var generatedAt: Date?
    var activeSportSlug: String?
    var candidateCount: Int
    var presentedCandidateIDs: Set<UUID>

    init(
        requestedAt: Date? = nil,
        generatedAt: Date? = nil,
        activeSportSlug: String? = nil,
        candidateCount: Int = 0,
        presentedCandidateIDs: Set<UUID> = []
    ) {
        self.requestedAt = requestedAt
        self.generatedAt = generatedAt
        self.activeSportSlug = activeSportSlug
        self.candidateCount = candidateCount
        self.presentedCandidateIDs = presentedCandidateIDs
    }

    func refreshing(requestedAt: Date) -> DiscoveryQueueMetadata {
        DiscoveryQueueMetadata(
            requestedAt: requestedAt,
            generatedAt: generatedAt,
            activeSportSlug: activeSportSlug,
            candidateCount: candidateCount,
            presentedCandidateIDs: presentedCandidateIDs
        )
    }
}

enum DiscoveryEmptyReason: Equatable, Sendable {
    case noEligibleCandidates
    case profileNotDiscoveryReady
    case activeSportUnavailable
    case filtersTooRestrictive
    case visibilityLimited
}

enum DiscoveryExhaustedReason: Equatable, Sendable {
    case reachedEndOfQueue
    case allCandidatesPresented
}

struct DiscoveryQueueFailure: Equatable, Sendable {
    enum Kind: Equatable, Sendable {
        case unauthorized
        case profileUnavailable
        case networkUnavailable
        case serviceUnavailable
        case unknown
    }

    var kind: Kind
    var message: String
}

enum DiscoveryRetryGuidance: Equatable, Sendable {
    case manualRetry
    case completeProfile
    case chooseActiveSport
    case tryLater
}
