import Testing
@testable import ScoutDesign

@Test func classNameJoinsNonEmptyParts() {
    #expect(cn("base", nil, " active ", "") == "base active")
}
