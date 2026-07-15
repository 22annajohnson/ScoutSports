import XCTest
@testable import Scout

final class DesignFactoryAccessTests: XCTestCase {
    func test_canAccess_requiresAuthenticatedEmployeeEmail() {
        XCTAssertTrue(
            DesignFactoryAccess.canAccess(
                isAuthenticated: true,
                email: "maintainer@scoutsports.app"
            )
        )
    }

    func test_canAccess_allowsEmployeeEmailCaseInsensitively() {
        XCTAssertTrue(
            DesignFactoryAccess.canAccess(
                isAuthenticated: true,
                email: " Maintainer@ScoutSports.App "
            )
        )
    }

    func test_canAccess_rejectsNonEmployeeEmail() {
        XCTAssertFalse(
            DesignFactoryAccess.canAccess(
                isAuthenticated: true,
                email: "player@example.com"
            )
        )
    }

    func test_canAccess_rejectsUnauthenticatedEmployeeEmail() {
        XCTAssertFalse(
            DesignFactoryAccess.canAccess(
                isAuthenticated: false,
                email: "maintainer@scoutsports.app"
            )
        )
    }

    func test_canAccess_rejectsMissingEmail() {
        XCTAssertFalse(
            DesignFactoryAccess.canAccess(
                isAuthenticated: true,
                email: nil
            )
        )
    }
}
