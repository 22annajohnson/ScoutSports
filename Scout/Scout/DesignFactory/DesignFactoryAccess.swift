import Foundation

enum DesignFactoryAccess {
    nonisolated static var employeeEmailDomain: String { "@scoutsports.app" }

    nonisolated static func canAccess(isAuthenticated: Bool, email: String?) -> Bool {
        guard isAuthenticated else { return false }
        return isEmployeeEmail(email)
    }

    nonisolated static func isEmployeeEmail(_ email: String?) -> Bool {
        guard let email else { return false }

        let normalizedEmail = email
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()

        return normalizedEmail.hasSuffix(employeeEmailDomain)
    }
}
