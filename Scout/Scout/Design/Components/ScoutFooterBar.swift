//
//  ScoutFooterBar.swift
//  Scout
//
//  Created by Codex on 4/1/26.
//

import SwiftUI

struct ScoutFooterBar<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        HStack(spacing: ScoutLayout.Spacing.md) {
            content
        }
        .padding(.horizontal, ScoutLayout.Spacing.lg)
        .padding(.top, ScoutLayout.Spacing.md)
        .padding(.bottom, ScoutLayout.Spacing.lg)
        .background(
            Rectangle()
                .fill(Color.scoutGlassFill)
                .background(.ultraThinMaterial)
                .ignoresSafeArea(edges: .bottom)
        )
        .overlay(alignment: .top) {
            Rectangle()
                .fill(Color.scoutGlassStroke)
                .frame(height: 1)
        }
    }
}

#Preview("Footer Bar") {
    ZStack(alignment: .bottom) {
        ScoutTheme.screenBackground.ignoresSafeArea()

        ScoutFooterBar {
            Button("Back") {}
                .buttonStyle(ScoutSecondaryGlassButtonStyle())

            Button("Next") {}
                .buttonStyle(ScoutPrimaryButtonStyle())
        }
    }
}
