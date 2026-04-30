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

    init(id: String, label: String, value: CGFloat) {
        self.id = id
        self.label = label
        self.value = value
    }

    init(label: String, value: CGFloat, position: Int) {
        self.init(id: "\(label)-\(position)", label: label, value: value)
    }
}
