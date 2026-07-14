//
//  ProfileContractMapperTests.swift
//  ScoutTests
//

import XCTest
@testable import Scout

final class ProfileContractMapperTests: XCTestCase {
    private let profileID = UUID(uuidString: "00000000-0000-0000-0000-000000000091")!
    private let userID = UUID(uuidString: "11111111-1111-1111-1111-111111111191")!

    func test_ownerProfile_mapsFullOwnerContract() {
        let owner = ProfileContractMapper.ownerProfile(
            profile: ownerRow(
                profileCompletionState: "discovery_ready",
                accountStatus: "active"
            ),
            sports: [
                ProfileSportRow(
                    profileId: profileID,
                    sportSlug: "pickleball",
                    skillLevel: "intermediate",
                    isPrimary: true
                )
            ],
            availability: ProfileAvailabilityRow(
                preferredDays: ["monday", "saturday"],
                preferredTimes: ["morning"],
                playIntent: "competitive",
                homeArea: "Raleigh",
                travelRadiusMiles: 25,
                preferredPlayStyle: "doubles"
            ),
            privacy: ProfilePrivacyRow(
                profileVisibility: "authenticated",
                discoverable: true,
                locationPrecision: "coarse"
            )
        )

        XCTAssertEqual(owner.id, profileID)
        XCTAssertEqual(owner.userID, userID)
        XCTAssertEqual(owner.displayName, "Anna")
        XCTAssertEqual(owner.username, "anna_pb")
        XCTAssertEqual(owner.profilePhotoPath, "profiles/anna/headshot.jpg")
        XCTAssertEqual(owner.actionPhotoPath, "profiles/anna/action.jpg")
        XCTAssertEqual(owner.bio, "Always up for a good doubles game.")
        XCTAssertEqual(owner.readinessState, .discoveryReady)
        XCTAssertEqual(owner.accountStatus, .active)
        XCTAssertEqual(owner.sports, [
            ProfileSportContext(
                sportSlug: "pickleball",
                skillLevel: "intermediate",
                isPrimary: true
            )
        ])
        XCTAssertEqual(owner.availability?.preferredDays, ["monday", "saturday"])
        XCTAssertEqual(owner.availability?.travelRadiusMiles, 25)
        XCTAssertEqual(owner.privacy?.discoverable, true)
    }

    func test_publicProfile_mapsOnlyPublicSummaryFieldsAndSports() throws {
        let profile = try XCTUnwrap(ProfileContractMapper.publicProfile(
            summary: publicSummaryRow(),
            sports: sportSummaryRows()
        ))

        XCTAssertEqual(profile.id, profileID)
        XCTAssertEqual(profile.displayName, "Anna")
        XCTAssertEqual(profile.username, "anna_pb")
        XCTAssertEqual(profile.profilePhotoPath, "profiles/anna/headshot.jpg")
        XCTAssertEqual(profile.bio, "Always up for a good doubles game.")
        XCTAssertEqual(profile.sports.count, 2)
        XCTAssertContractDoesNotExposePrivateFields(profile)
    }

    func test_discoverySummary_usesPrimarySportAndExcludesPrivateFields() throws {
        let summary = try XCTUnwrap(ProfileContractMapper.discoverySummary(
            summary: publicSummaryRow(),
            sports: sportSummaryRows()
        ))

        XCTAssertEqual(summary.id, profileID)
        XCTAssertEqual(summary.displayName, "Anna")
        XCTAssertEqual(summary.profilePhotoPath, "profiles/anna/headshot.jpg")
        XCTAssertEqual(summary.primarySport, ProfileSportContext(
            sportSlug: "pickleball",
            skillLevel: "intermediate",
            isPrimary: true
        ))
        XCTAssertContractDoesNotExposePrivateFields(summary)
    }

    func test_eventSummary_prefersEventSportThenPrimarySport() throws {
        let tennisSummary = try XCTUnwrap(ProfileContractMapper.eventSummary(
            summary: publicSummaryRow(),
            sports: sportSummaryRows(),
            sportSlug: "tennis"
        ))

        XCTAssertEqual(tennisSummary.sport, ProfileSportContext(
            sportSlug: "tennis",
            skillLevel: nil,
            isPrimary: false
        ))
        XCTAssertContractDoesNotExposePrivateFields(tennisSummary)

        let fallbackSummary = try XCTUnwrap(ProfileContractMapper.eventSummary(
            summary: publicSummaryRow(),
            sports: sportSummaryRows(),
            sportSlug: "soccer"
        ))

        XCTAssertEqual(fallbackSummary.sport?.sportSlug, "pickleball")
    }

    func test_chatSummary_exposesMinimalIdentityOnly() throws {
        let summary = try XCTUnwrap(ProfileContractMapper.chatSummary(summary: publicSummaryRow()))

        XCTAssertEqual(summary.id, profileID)
        XCTAssertEqual(summary.displayName, "Anna")
        XCTAssertEqual(summary.profilePhotoPath, "profiles/anna/headshot.jpg")
        XCTAssertContractDoesNotExposePrivateFields(summary)
    }

    func test_missingOptionalValuesDegradeSafely() throws {
        let profile = try XCTUnwrap(ProfileContractMapper.publicProfile(
            summary: ProfilePublicSummaryRow(
                bio: nil,
                displayName: nil,
                profileId: profileID,
                profilePhotoPath: nil,
                username: nil
            ),
            sports: [
                ProfileSportSummaryRow(
                    isPrimary: nil,
                    profileId: profileID,
                    skillLevel: nil,
                    sportSlug: nil
                )
            ]
        ))

        XCTAssertEqual(profile.id, profileID)
        XCTAssertNil(profile.displayName)
        XCTAssertNil(profile.username)
        XCTAssertNil(profile.profilePhotoPath)
        XCTAssertNil(profile.bio)
        XCTAssertTrue(profile.sports.isEmpty)
    }

    func test_missingViewProfileIDReturnsNilContract() {
        let row = ProfilePublicSummaryRow(
            bio: "Visible",
            displayName: "Anna",
            profileId: nil,
            profilePhotoPath: nil,
            username: nil
        )

        XCTAssertNil(ProfileContractMapper.publicProfile(summary: row, sports: []))
        XCTAssertNil(ProfileContractMapper.discoverySummary(summary: row, sports: []))
        XCTAssertNil(ProfileContractMapper.eventSummary(summary: row, sports: []))
        XCTAssertNil(ProfileContractMapper.chatSummary(summary: row))
    }

    func test_readinessAndAccountStatusMapConsistently() {
        let readinessCases: [(String, ProfileReadinessState)] = [
            ("account_created", .accountCreated),
            ("basic_identity", .basicIdentity),
            ("discovery_ready", .discoveryReady),
            ("event_ready", .eventReady),
            ("fully_complete", .fullyComplete),
            ("new_state", .unknown("new_state"))
        ]

        for (databaseValue, expectedState) in readinessCases {
            XCTAssertEqual(ProfileReadinessState(databaseValue: databaseValue), expectedState)
        }

        XCTAssertEqual(
            ProfileContractMapper.ownerProfile(
                profile: ownerRow(accountStatus: "restricted"),
                sports: [],
                availability: nil,
                privacy: nil
            ).accountStatus,
            .restricted
        )
    }

    private func ownerRow(
        profileCompletionState: String = "basic_identity",
        accountStatus: String = "active"
    ) -> ProfileOwnerRow {
        ProfileOwnerRow(
            accountStatus: accountStatus,
            actionPhotoPath: "profiles/anna/action.jpg",
            bio: "Always up for a good doubles game.",
            displayName: "Anna",
            id: profileID,
            lastActiveAt: "2026-07-14T12:00:00Z",
            profileCompletionState: profileCompletionState,
            profilePhotoPath: "profiles/anna/headshot.jpg",
            userId: userID,
            username: "anna_pb"
        )
    }

    private func publicSummaryRow() -> ProfilePublicSummaryRow {
        ProfilePublicSummaryRow(
            bio: "Always up for a good doubles game.",
            displayName: "Anna",
            profileId: profileID,
            profilePhotoPath: "profiles/anna/headshot.jpg",
            username: "anna_pb"
        )
    }

    private func sportSummaryRows() -> [ProfileSportSummaryRow] {
        [
            ProfileSportSummaryRow(
                isPrimary: true,
                profileId: profileID,
                skillLevel: "intermediate",
                sportSlug: "pickleball"
            ),
            ProfileSportSummaryRow(
                isPrimary: false,
                profileId: profileID,
                skillLevel: nil,
                sportSlug: "tennis"
            )
        ]
    }

    private func XCTAssertContractDoesNotExposePrivateFields<T>(
        _ contract: T,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let exposedLabels = Set(Mirror(reflecting: contract).children.compactMap(\.label))
        let privateLabels: Set<String> = [
            "userID",
            "actionPhotoPath",
            "readinessState",
            "accountStatus",
            "availability",
            "privacy"
        ]

        XCTAssertTrue(
            exposedLabels.isDisjoint(with: privateLabels),
            "Contract exposes private labels: \(exposedLabels.intersection(privateLabels))",
            file: file,
            line: line
        )
    }
}
