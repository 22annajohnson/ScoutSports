//
//  LoginViewModel.swift
//  Scout
//
//  Created by Anna on 2/25/26.
//

import Foundation
import Observation

@MainActor
@Observable
final class LoginViewModel {

    enum SubmitState: Equatable {
        case idle
        case working

        var isWorking: Bool {
            if case .working = self { return true }
            return false
        }
    }

    struct AlertItem: Identifiable, Equatable {
        let id = UUID()
        let title: String
        let message: String
    }

    // Inputs
    var email: String = ""
    var password: String = ""

    // Outputs/UI state
    private(set) var submitState: SubmitState = .idle
    var alert: AlertItem?

    private let session: SessionStore

    init(session: SessionStore) {
        self.session = session
    }

    var trimmedEmail: String {
        email.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var canSubmit: Bool {
        !trimmedEmail.isEmpty && !password.isEmpty
    }

    func login() async {
        guard canSubmit else {
            alert = AlertItem(title: "Missing info", message: "Please enter both an email and password.")
            return
        }

        submitState = .working

        do {
            try await session.signIn(email: trimmedEmail, password: password)
            submitState = .idle
        } catch {
            submitState = .idle
            alert = AlertItem(title: "Login failed", message: friendlyAuthErrorMessage(error))
        }
    }

    private func friendlyAuthErrorMessage(_ error: Error) -> String {
        let lower = error.localizedDescription.lowercased()

        if lower.contains("invalid login") || lower.contains("credentials") {
            return "Incorrect email or password."
        }

        if lower.contains("email") && lower.contains("confirm") {
            return "Please confirm your email, then try again."
        }

        if lower.contains("network") || lower.contains("offline") || lower.contains("internet") {
            return "Network error. Please check your connection and try again."
        }

        return error.localizedDescription
    }
}
