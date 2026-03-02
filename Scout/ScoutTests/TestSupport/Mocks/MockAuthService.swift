//
//  MockAuthService.swift
//  ScoutTests
//
//  Created by Anna on 3/2/26.
//

import Foundation

/// Test double for `AuthProviding`.
/// - Tracks calls and captures parameters.
/// - Can be configured to throw for specific operations.
final class MockAuthService: AuthProviding {

    // MARK: - Captured inputs

    private(set) var signUpCalls: [(email: String, password: String)] = []
    private(set) var signInCalls: [(email: String, password: String)] = []
    private(set) var signOutCallCount: Int = 0

    // MARK: - Configurable behavior

    var signUpError: Error?
    var signInError: Error?
    var signOutError: Error?

    // Optional hooks if you want side effects.
    var onSignUp: ((String, String) -> Void)?
    var onSignIn: ((String, String) -> Void)?
    var onSignOut: (() -> Void)?

    // MARK: - AuthProviding

    func signUp(email: String, password: String) async throws {
        signUpCalls.append((email: email, password: password))
        onSignUp?(email, password)
        if let signUpError { throw signUpError }
    }

    func signIn(email: String, password: String) async throws {
        signInCalls.append((email: email, password: password))
        onSignIn?(email, password)
        if let signInError { throw signInError }
    }

    func signOut() async throws {
        signOutCallCount += 1
        onSignOut?()
        if let signOutError { throw signOutError }
    }
}
