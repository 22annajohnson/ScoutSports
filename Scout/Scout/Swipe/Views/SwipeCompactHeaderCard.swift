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
            .padding(.horizontal, ScoutLayout.Spacing.md)
            .padding(.vertical, ScoutLayout.Spacing.sm)
            .background(background)
            .overlay(stroke)
            .shadow(color: Color.scoutShadowSoft, radius: 16, y: 8)
    }

    private var background: some View {
        RoundedRectangle(cornerRadius: ScoutLayout.Radius.xl, style: .continuous)
            .fill(Color.scoutGlassFill)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: ScoutLayout.Radius.xl, style: .continuous))
    }

    private var stroke: some View {
        RoundedRectangle(cornerRadius: ScoutLayout.Radius.xl, style: .continuous)
            .stroke(Color.scoutGlassStroke, lineWidth: ScoutLayout.Stroke.hairline)
    }
}
