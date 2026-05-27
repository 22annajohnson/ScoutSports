//
//  fonts.swift
//  Scout
//
//  Created by Anna on 2/19/26.
//

import SwiftUI

// MARK: - Scout Typography

public extension Font {
    static let scoutDisplay = Font.system(size: 52, weight: .black, design: .rounded)
    static let scoutDisplayCompact = Font.system(size: 40, weight: .black, design: .rounded)
    static let scoutHeroTitle = Font.system(size: 34, weight: .bold, design: .rounded)
    static let scoutTitle = Font.system(size: 28, weight: .bold, design: .default)
    static let scoutTitleCompact = Font.system(size: 22, weight: .bold, design: .default)
    static let scoutSectionTitle = Font.system(size: 20, weight: .bold, design: .default)
    static let scoutSectionSubtitle = Font.system(size: 16, weight: .semibold, design: .default)
    static let scoutBody = Font.system(size: 17, weight: .regular, design: .default)
    static let scoutBodyEmphasis = Font.system(size: 17, weight: .semibold, design: .default)
    static let scoutCallout = Font.system(size: 15, weight: .semibold, design: .default)
    static let scoutPill = Font.system(size: 14, weight: .semibold, design: .rounded)
    static let scoutLabel = Font.system(size: 13, weight: .semibold, design: .default)
    static let scoutLabelCaps = Font.system(size: 12, weight: .bold, design: .default)
    static let scoutCaption = Font.system(size: 13, weight: .medium, design: .default)
    static let scoutMicro = Font.system(size: 11, weight: .bold, design: .default)
    static let scoutNumberXL = Font.system(size: 64, weight: .black, design: .rounded)
    static let scoutNumberL = Font.system(size: 40, weight: .bold, design: .rounded)
    static let scoutNumberM = Font.system(size: 28, weight: .bold, design: .rounded)

    // MARK: Backward-Compatible Aliases

    static let scoutScore = scoutNumberXL
    static let scoutHeroName = scoutDisplayCompact
    static let scoutHeroMeta = scoutCallout
    static let scoutScreenTitle = scoutTitle
    static let scoutScreenSubtitle = scoutBodyEmphasis
    static let scoutSectionHeader = scoutSectionTitle
    static let scoutSectionSubheader = scoutSectionSubtitle
}
