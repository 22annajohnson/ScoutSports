//
//  ProfileDTOTests.swift
//  ScoutTests
//
//  Created by Anna on 3/2/26.
//

import XCTest
@testable import Scout

final class ProfileDTOTests: XCTestCase {

    func test_decode_displayNameSnakeCaseKey_mapsToDisplayNameProperty() async throws {
        // Arrange
        let json = """
        {
          "id": "user-123",
          "display_name": "Anna"
        }
        """

        // Act
        let data = try XCTUnwrap(json.data(using: .utf8))
        let decoded = try await MainActor.run {
            try JSONDecoder().decode(ProfileDTO.self, from: data)
        }

        // Assert
        let (id, displayName) = await MainActor.run { (decoded.id, decoded.displayName) }
        XCTAssertEqual(id, "user-123")
        XCTAssertEqual(displayName, "Anna")
    }

    func test_toDomain_whenValidDTO_returnsMatchingDomainModel() async {
        // Act
        let domain = await MainActor.run { () -> Profile in
            let dto = ProfileDTO(id: "user-abc", displayName: "Noah")
            return dto.toDomain()
        }

        // Assert
        let (id, displayName) = await MainActor.run { (domain.id, domain.displayName) }
        XCTAssertEqual(id, "user-abc")
        XCTAssertEqual(displayName, "Noah")
    }
}
