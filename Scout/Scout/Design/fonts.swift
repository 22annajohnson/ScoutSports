//
//  fonts.swift
//  Scout
//
//  Created by Anna on 2/19/26.
//

import SwiftUI

// MARK: - Scout Typography
extension Font {

    // HERO / CARD
    /// Big score like "87" on the card.
    static let scoutScore = Font.system(size: 64, weight: .black, design: .rounded)
    /// Name on the hero card.
    static let scoutHeroName = Font.system(size: 48, weight: .black, design: .rounded)
    /// Small helper text on hero (distance, sport).
    static let scoutHeroMeta = Font.system(size: 15, weight: .semibold, design: .rounded)

    // SCREEN TITLES / NAV
    static let scoutScreenTitle = Font.system(size: 28, weight: .bold, design: .default)
    static let scoutScreenSubtitle = Font.system(size: 17, weight: .semibold, design: .default)

    // SECTIONS
    static let scoutSectionHeader = Font.system(size: 20, weight: .bold, design: .default)
    static let scoutSectionSubheader = Font.system(size: 16, weight: .semibold, design: .default)

    // BODY
    static let scoutBody = Font.system(size: 17, weight: .regular, design: .default)
    static let scoutBodyEmphasis = Font.system(size: 17, weight: .semibold, design: .default)

    // CAPS / LABELS / PILLS
    /// Great for small labels like "WIN RATE" above a stat.
    static let scoutLabelCaps = Font.system(size: 13, weight: .bold, design: .default)
    /// Tag pills (Competitive / Vibey).
    static let scoutPill = Font.system(size: 14, weight: .semibold, design: .rounded)

    // CAPTION
    static let scoutCaption = Font.system(size: 13, weight: .medium, design: .default)
    static let scoutMicro = Font.system(size: 12, weight: .medium, design: .default)
}
