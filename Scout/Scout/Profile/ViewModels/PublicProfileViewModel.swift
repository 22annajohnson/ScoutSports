//
//  PublicProfileViewModel.swift
//  Scout
//

import Foundation
import Observation

@MainActor
@Observable
final class PublicProfileViewModel {
    enum State: Equatable {
        case idle
        case loading
        case loaded(PublicProfile)
        case incomplete(message: String)
        case error(message: String)
    }

    private let profileID: UUID
    private let repository: PublicProfileProviding

    private(set) var state: State = .idle

    init(profileID: UUID, repository: PublicProfileProviding) {
        self.profileID = profileID
        self.repository = repository
    }

    var profile: PublicProfile? {
        if case .loaded(let profile) = state {
            return profile
        }

        return nil
    }

    var isLoading: Bool {
        state == .loading
    }

    var isIncomplete: Bool {
        if case .incomplete = state {
            return true
        }

        return false
    }

    func load() async {
        state = .loading

        do {
            let profile = try await repository.publicProfile(profileID: profileID)
            if profile.isPublicProfileIncomplete {
                state = .incomplete(message: "This profile is not ready to show yet.")
            } else {
                state = .loaded(profile)
            }
        } catch let error as ProfileRepositoryError {
            state = mappedState(for: error)
        } catch {
            state = .error(message: "Could not load this profile. Please try again.")
        }
    }

    private func mappedState(for error: ProfileRepositoryError) -> State {
        switch error {
        case .profileMissing:
            return .incomplete(message: "This profile is not available yet.")
        case .notAuthenticated:
            return .error(message: "Sign in to view player profiles.")
        case .permissionDenied:
            return .error(message: "You do not have permission to view this profile.")
        case .networkUnavailable:
            return .error(message: "Check your connection and try again.")
        case .serverUnavailable:
            return .error(message: "Scout is having trouble loading this profile. Please try again.")
        case .decodingFailed, .mappingFailed:
            return .error(message: "Scout could not read this profile yet. Please try again.")
        case .conflictOrStaleWrite, .validationFailed, .unknown:
            return .error(message: "Could not load this profile. Please try again.")
        }
    }
}

private extension PublicProfile {
    var isPublicProfileIncomplete: Bool {
        let hasName = !(displayName?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
        return !hasName || sports.isEmpty
    }
}
