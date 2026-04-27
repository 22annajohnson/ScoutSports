//
//  SwipeCardTagItem.swift
//  Scout
//
//  Created by Codex on 4/27/26.
//

import Foundation

struct SwipeCardTagItem: Identifiable {
    enum Style {
        case neutral
        case accent
        case info
    }

    let id: String
    let title: String
    let style: Style

    init(title: String, style: Style = .neutral) {
        self.id = "\(style)-\(title)"
        self.title = title
        self.style = style
    }
}
