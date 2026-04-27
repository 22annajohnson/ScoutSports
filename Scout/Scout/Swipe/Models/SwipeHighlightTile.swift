//
//  SwipeHighlightTile.swift
//  Scout
//
//  Created by Codex on 4/27/26.
//

import Foundation

struct SwipeHighlightTile: Identifiable {
    let id: String
    let title: String
    let value: String
    let progress: CGFloat

    init(title: String, value: String, progress: CGFloat) {
        self.id = title
        self.title = title
        self.value = value
        self.progress = progress
    }
}
