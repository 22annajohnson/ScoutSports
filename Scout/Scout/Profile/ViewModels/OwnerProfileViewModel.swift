//
//  OwnerProfileViewModel.swift
//  Scout
//

import Foundation
import Observation

@MainActor
@Observable
final class OwnerProfileViewModel {
    enum State: Equatable {
        case idle
        case loading
        case loaded(OwnerEditableProfile)
        case incomplete(message: String)
        case error(message: String)
    }

    private let repository: OwnerEditableProfileProviding

    private(set) var state: State = .idle

    init(repository: OwnerEditableProfileProviding) {
        self.repository = repository
    }

    var profile: OwnerEditableProfile? {
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

    func load(forceRefresh: Bool = false) async {
        state = .loading

        do {
            let profile = try await repository.currentEditableProfile(forceRefresh: forceRefresh)
            if profile.isOwnerProfileIncomplete {
                state = .incomplete(message: "Finish setting up your profile so other players know how you like to play.")
            } else {
                state = .loaded(profile)
            }
        } catch let error as ProfileRepositoryError {
            state = mappedState(for: error)
        } catch {
            state = .error(message: "Could not load your profile. Please try again.")
        }
    }

    private func mappedState(for error: ProfileRepositoryError) -> State {
        switch error {
        case .profileMissing:
            return .incomplete(message: "Create your profile to start matching with players.")
        case .notAuthenticated:
            return .error(message: "Sign in to view your profile.")
        case .permissionDenied:
            return .error(message: "You do not have permission to view this profile.")
        case .networkUnavailable:
            return .error(message: "Check your connection and try again.")
        case .serverUnavailable:
            return .error(message: "Scout is having trouble loading your profile. Please try again.")
        case .decodingFailed, .mappingFailed:
            return .error(message: "Scout could not read your profile yet. Please try again.")
        case .conflictOrStaleWrite, .validationFailed, .unknown:
            return .error(message: "Could not load your profile. Please try again.")
        }
    }
}

private extension OwnerEditableProfile {
    var isOwnerProfileIncomplete: Bool {
        completionState == .accountCreated || displayName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
