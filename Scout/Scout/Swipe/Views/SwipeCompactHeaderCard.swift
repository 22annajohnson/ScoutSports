//
//  SwipeCompactHeaderCard.swift
//  Scout
//
//  Created by Codex on 4/28/26.
//

import SwiftUI

struct SwipeCompactHeaderCard<Content: View>: View {
    private let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(.horizontal, ScoutSpacing.md)
            .padding(.vertical, ScoutSpacing.sm)
            .background(background)
            .overlay(stroke)
            .shadow(color: Color.black.opacity(0.12), radius: 16, y: 8)
    }

    private var background: some View {
        RoundedRectangle(cornerRadius: ScoutRadius.xl, style: .continuous)
            .fill(Color.scoutGlassFill)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: ScoutRadius.xl, style: .continuous))
    }

    private var stroke: some View {
        RoundedRectangle(cornerRadius: ScoutRadius.xl, style: .continuous)
            .stroke(Color.scoutGlassStroke, lineWidth: ScoutStroke.hairline)
    }
}
