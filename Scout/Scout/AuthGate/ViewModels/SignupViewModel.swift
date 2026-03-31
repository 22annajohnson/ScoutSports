//
//  SignupViewModel.swift
//  Scout
//
//  Created by Anna on 2/26/26.
//

import Combine
import Foundation

@MainActor
final class SignupViewModel: ObservableObject {

    // MARK: - Models

    struct Form: Equatable {
        var email: String = ""
        var password: String = ""
        var confirmPassword: String = ""

        var trimmedEmail: String {
            email.trimmingCharacters(in: .whitespacesAndNewlines)
        }

        var passwordsMatch: Bool {
            !password.isEmpty && password == confirmPassword
        }

        var canSubmit: Bool {
            !trimmedEmail.isEmpty && !password.isEmpty && passwordsMatch
        }
    }

    struct AlertItem: Identifiable, Equatable {
        let id = UUID()
        let title: String
        let message: String

        static func missingInfo(_ message: String) -> AlertItem {
            AlertItem(title: "Missing info", message: message)
        }

        static func failure(_ message: String) -> AlertItem {
            AlertItem(title: "Sign up failed", message: message)
        }
    }

    // MARK: - Enums

    enum SubmitState: Equatable {
        case idle
        case working

        var isWorking: Bool {
            if case .working = self { return true }
            return false
        }
    }

    enum ValidationError: Equatable {
        case missingEmail
        case missingPassword
        case passwordsDontMatch

        var alert: AlertItem {
            switch self {
            case .missingEmail:
                return .missingInfo("Please enter an email.")
            case .missingPassword:
                return .missingInfo("Please enter a password.")
            case .passwordsDontMatch:
                return AlertItem(title: "Passwords don't match", message: "Please make sure both password fields are the same.")
            }
        }
    }

    // MARK: - Published State

    @Published var form = Form()
    @Published private(set) var submitState: SubmitState = .idle
    @Published var alert: AlertItem?

    // MARK: - Dependencies

    private let session: SessionStore

    init(session: SessionStore) {
        self.session = session
    }

    // MARK: - Business Logic

    func signUp() async {
        if let error = validate(form) {
            alert = error.alert
            return
        }

        submitState = .working

        do {
            try await session.signUp(email: form.trimmedEmail, password: form.password)
            submitState = .idle
        } catch {
            submitState = .idle
            alert = .failure(friendlyAuthErrorMessage(error))
        }
    }

    private func validate(_ form: Form) -> ValidationError? {
        if form.trimmedEmail.isEmpty { return .missingEmail }
        if form.password.isEmpty { return .missingPassword }
        if !form.passwordsMatch { return .passwordsDontMatch }
        return nil
    }

    private func friendlyAuthErrorMessage(_ error: Error) -> String {
        let lower = error.localizedDescription.lowercased()

        if lower.contains("already") && (lower.contains("registered") || lower.contains("exists")) {
            return "That email is already registered. Try logging in instead."
        }

        if lower.contains("password") && (lower.contains("6") || lower.contains("weak") || lower.contains("short")) {
            return "Please use a stronger password (at least 6 characters)."
        }

        if lower.contains("email") && lower.contains("confirm") {
            return "Please confirm your email, then try logging in."
        }

        if lower.contains("network") || lower.contains("offline") || lower.contains("internet") {
            return "Network error. Please check your connection and try again."
        }

        return error.localizedDescription
    }
}
