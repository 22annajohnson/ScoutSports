//
//  SwipeHeroTopBarViewModel.swift
//  Scout
//
//  Created by Codex on 4/28/26.
//

import SwiftUI
import ScoutDesign

struct SwipeHeroTopBarViewModel {
    struct Model {
        let title: String
        let distance: String
    }

    enum DisplayMode {
        case expanded
        case transitioning
        case compact
    }

    let model: Model
    let mergeProgress: CGFloat

    var compactProgress: CGFloat {
        min(max((mergeProgress - 0.2) / 0.45, 0), 1)
    }

    var displayMode: DisplayMode {
        switch compactProgress {
        case 0:
            return .expanded
        case 1:
            return .compact
        default:
            return .transitioning
        }
    }

    var scale: CGFloat {
        1 - (0.06 * mergeProgress)
    }

    var opacity: Double {
        Double(1 - (0.08 * mergeProgress))
    }
}
