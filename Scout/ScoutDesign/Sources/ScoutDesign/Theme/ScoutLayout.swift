//
//  ScoutLayout.swift
//  Scout
//
//  Created by Codex on 4/29/26.
//

import SwiftUI

public enum ScoutLayout {
    public enum Spacing {
        public static let xxxs: CGFloat = 4
        public static let xxs: CGFloat = 6
        public static let xs: CGFloat = 8
        public static let sm: CGFloat = 12
        public static let md: CGFloat = 16
        public static let lg: CGFloat = 20
        public static let xl: CGFloat = 24
        public static let xxl: CGFloat = 32
        public static let xxxl: CGFloat = 40
    }

    public enum Radius {
        public static let sm: CGFloat = 12
        public static let md: CGFloat = 18
        public static let lg: CGFloat = 24
        public static let xl: CGFloat = 32
        public static let capsule: CGFloat = 999
    }

    public enum Stroke {
        public static let hairline: CGFloat = 1
        public static let emphasis: CGFloat = 1.5
        public static let selected: CGFloat = 2
    }

    public enum Blur {
        public static let glass: CGFloat = 12
        public static let heroGlow: CGFloat = 18
        public static let backgroundWash: CGFloat = 28
    }

    public enum Shadow {
        public static let raisedRadius: CGFloat = 18
        public static let raisedY: CGFloat = 10
    }

    public enum Tracking {
        public static let micro: CGFloat = 2.5
        public static let labelCaps: CGFloat = 3
    }

    public enum SafeArea {
        public static func topInset(from insets: EdgeInsets) -> CGFloat {
            insets.top
        }

        public static func bottomInset(from insets: EdgeInsets, minimum: CGFloat = Spacing.sm) -> CGFloat {
            max(insets.bottom, minimum)
        }

        public static func fullHeight(for size: CGSize, insets: EdgeInsets) -> CGFloat {
            size.height + insets.top + insets.bottom
        }

        public static func overlayBottomInset(from insets: EdgeInsets, base: CGFloat = Spacing.lg) -> CGFloat {
            bottomInset(from: insets) + base
        }
    }
}
