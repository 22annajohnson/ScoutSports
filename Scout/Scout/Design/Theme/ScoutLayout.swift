//
//  ScoutLayout.swift
//  Scout
//
//  Created by Codex on 4/29/26.
//

import SwiftUI

enum ScoutLayout {
    enum Spacing {
        static let xxxs: CGFloat = 4
        static let xxs: CGFloat = 6
        static let xs: CGFloat = 8
        static let sm: CGFloat = 12
        static let md: CGFloat = 16
        static let lg: CGFloat = 20
        static let xl: CGFloat = 24
        static let xxl: CGFloat = 32
        static let xxxl: CGFloat = 40
    }

    enum Radius {
        static let sm: CGFloat = 12
        static let md: CGFloat = 18
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let capsule: CGFloat = 999
    }

    enum Stroke {
        static let hairline: CGFloat = 1
        static let emphasis: CGFloat = 1.5
        static let selected: CGFloat = 2
    }

    enum Blur {
        static let glass: CGFloat = 12
        static let heroGlow: CGFloat = 18
        static let backgroundWash: CGFloat = 28
    }

    enum Shadow {
        static let raisedRadius: CGFloat = 18
        static let raisedY: CGFloat = 10
    }

    enum SafeArea {
        static func topInset(from insets: EdgeInsets) -> CGFloat {
            insets.top
        }

        static func bottomInset(from insets: EdgeInsets, minimum: CGFloat = Spacing.sm) -> CGFloat {
            max(insets.bottom, minimum)
        }

        static func fullHeight(for size: CGSize, insets: EdgeInsets) -> CGFloat {
            size.height + insets.top + insets.bottom
        }

        static func overlayBottomInset(from insets: EdgeInsets, base: CGFloat = Spacing.lg) -> CGFloat {
            bottomInset(from: insets) + base
        }
    }
}
