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
        HStack(spacing: ScoutSpacing.md) {
            content
        }
        .padding(.horizontal, ScoutSpacing.lg)
        .padding(.top, ScoutSpacing.md)
        .padding(.bottom, ScoutSpacing.lg)
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
