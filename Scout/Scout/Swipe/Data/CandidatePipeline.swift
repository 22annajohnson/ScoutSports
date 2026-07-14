//
//  CandidatePipeline.swift
//  Scout
//
//  Created by Codex on 7/14/26.
//

import Foundation

struct DiscoveryCurrentPlayerContext: Equatable, Sendable {
    let userID: UUID
    var profileID: UUID?
    var activeSportSlug: String?
    var readinessState: ProfileReadinessState
}

struct DiscoveryCandidateProfile: Identifiable, Equatable, Sendable {
    let id: UUID
    let userID: UUID
    var displayName: String?
    var username: String?
    var profilePhotoPath: String?
    var bio: String?
    var readinessState: ProfileReadinessState
    var accountStatus: ProfileAccountStatus
    var sports: [ProfileSportContext]
    var availability: ProfileAvailabilityContext?
    var privacy: ProfilePrivacySettings?
}

struct CandidatePipeline {
    var queueIDProvider: () -> UUID = UUID.init
    var generatedAtProvider: () -> Date = Date.init

    func makeQueue(
        currentPlayer: DiscoveryCurrentPlayerContext,
        candidates: [DiscoveryCandidateProfile],
        previousQueue: DiscoveryQueue? = nil
    ) -> DiscoveryQueue {
        guard currentPlayer.readinessState.isDiscoveryEligible else {
            return DiscoveryQueue.empty(
                id: queueIDProvider(),
                reason: .profileNotDiscoveryReady,
                generatedAt: generatedAtProvider()
            )
        }

        guard let activeSportSlug = currentPlayer.activeSportSlug, !activeSportSlug.isEmpty else {
            return DiscoveryQueue.empty(
                id: queueIDProvider(),
                reason: .activeSportUnavailable,
                generatedAt: generatedAtProvider()
            )
        }

        var seenCandidateIDs = Set<UUID>()
        let previouslyPresentedIDs = previousQueue?.metadata.presentedCandidateIDs ?? []
        let visibleCandidates = candidates.compactMap { candidate -> CandidateCard? in
            guard candidate.id != currentPlayer.profileID else { return nil }
            guard candidate.userID != currentPlayer.userID else { return nil }
            guard candidate.accountStatus == .active else { return nil }
            guard candidate.readinessState.isDiscoveryEligible else { return nil }
            guard candidate.privacy?.allowsDiscoveryDisplay == true else { return nil }
            guard !previouslyPresentedIDs.contains(candidate.id) else { return nil }
            guard seenCandidateIDs.insert(candidate.id).inserted else { return nil }
            guard let matchingSport = candidate.sports.first(where: { $0.sportSlug == activeSportSlug }) else {
                return nil
            }

            return makeCandidateCard(
                from: candidate,
                matchingSport: matchingSport,
                activeSportSlug: activeSportSlug
            )
        }

        guard !visibleCandidates.isEmpty else {
            return DiscoveryQueue.empty(
                id: queueIDProvider(),
                reason: .noEligibleCandidates,
                generatedAt: generatedAtProvider()
            )
        }

        return DiscoveryQueue.ready(
            id: queueIDProvider(),
            candidates: visibleCandidates,
            generatedAt: generatedAtProvider(),
            activeSportSlug: activeSportSlug
        )
    }

    private func makeCandidateCard(
        from candidate: DiscoveryCandidateProfile,
        matchingSport: ProfileSportContext,
        activeSportSlug: String
    ) -> CandidateCard {
        let sportDisplayName = displayName(forSportSlug: activeSportSlug)
        let availabilitySummary = summary(for: candidate.availability)
        let locationSummary = locationSummary(
            availability: candidate.availability,
            privacy: candidate.privacy
        )

        return CandidateCard(
            id: candidate.id,
            displayName: displayName(for: candidate),
            profilePhotoPath: candidate.profilePhotoPath,
            primarySport: CandidateSportSummary(
                sportSlug: matchingSport.sportSlug,
                displayName: sportDisplayName,
                skillSummary: matchingSport.skillLevel
            ),
            bioSummary: candidate.bio,
            availabilitySummary: availabilitySummary,
            locationSummary: locationSummary,
            contextLabels: contextLabels(
                sportDisplayName: sportDisplayName,
                skillSummary: matchingSport.skillLevel,
                availabilitySummary: availabilitySummary,
                locationSummary: locationSummary,
                readinessState: candidate.readinessState
            )
        )
    }

    private func displayName(for candidate: DiscoveryCandidateProfile) -> String {
        if let displayName = candidate.displayName?.trimmedNonEmpty {
            return displayName
        }

        if let username = candidate.username?.trimmedNonEmpty {
            return username
        }

        return "Scout Player"
    }

    private func displayName(forSportSlug sportSlug: String) -> String {
        sportSlug
            .replacingOccurrences(of: "-", with: " ")
            .replacingOccurrences(of: "_", with: " ")
            .capitalized
    }

    private func summary(for availability: ProfileAvailabilityContext?) -> String? {
        guard let availability else { return nil }

        let days = availability.preferredDays.joined(separator: ", ").trimmedNonEmpty
        let times = availability.preferredTimes.joined(separator: ", ").trimmedNonEmpty
        let intent = availability.playIntent?.trimmedNonEmpty

        return [days, times, intent]
            .compactMap { $0 }
            .joined(separator: " - ")
            .trimmedNonEmpty
    }

    private func locationSummary(
        availability: ProfileAvailabilityContext?,
        privacy: ProfilePrivacySettings?
    ) -> String? {
        guard privacy?.locationPrecision == "coarse" else { return nil }
        return availability?.homeArea?.trimmedNonEmpty
    }

    private func contextLabels(
        sportDisplayName: String,
        skillSummary: String?,
        availabilitySummary: String?,
        locationSummary: String?,
        readinessState: ProfileReadinessState
    ) -> [CandidateContextLabel] {
        var labels = [
            CandidateContextLabel(
                kind: .sportCompatibility,
                text: "Plays \(sportDisplayName)"
            )
        ]

        if let skillSummary = skillSummary?.trimmedNonEmpty {
            labels.append(CandidateContextLabel(kind: .skillCompatibility, text: skillSummary))
        }

        if availabilitySummary != nil {
            labels.append(CandidateContextLabel(kind: .availability, text: "Availability shared"))
        }

        if locationSummary != nil {
            labels.append(CandidateContextLabel(kind: .location, text: "Coarse area shared"))
        }

        if readinessState == .fullyComplete {
            labels.append(CandidateContextLabel(kind: .profileCompleteness, text: "Complete profile"))
        }

        return labels
    }
}

private extension ProfileReadinessState {
    var isDiscoveryEligible: Bool {
        switch self {
        case .discoveryReady, .eventReady, .fullyComplete:
            return true
        case .accountCreated, .basicIdentity, .unknown:
            return false
        }
    }
}

private extension ProfilePrivacySettings {
    var allowsDiscoveryDisplay: Bool {
        discoverable && profileVisibility != "private"
    }
}

private extension String {
    var trimmedNonEmpty: String? {
        let trimmed = trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }
}
