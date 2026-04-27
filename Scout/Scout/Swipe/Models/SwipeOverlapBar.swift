//
//  SwipeOverlapBar.swift
//  Scout
//
//  Created by Codex on 4/27/26.
//

import Foundation

struct SwipeOverlapBar: Identifiable {
    let id: String
    let label: String
    let value: CGFloat

    init(label: String, value: CGFloat) {
        self.id = label
        self.label = label
        self.value = value
    }
}
