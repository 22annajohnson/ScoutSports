//
//  ScoutButtonStyles.swift
//  Scout
//
//  Created by Codex on 4/1/26.
//

import SwiftUI

struct ScoutPrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.scoutBodyEmphasis)
            .foregroundStyle(Color.scoutTextOnAccent)
            .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, ScoutSpacing.lg)
            .padding(.vertical, ScoutSpacing.md)
            .background(background(isPressed: configuration.isPressed))
            .overlay(
                Capsule()
                    .stroke(Color.white.opacity(0.18), lineWidth: ScoutStroke.hairline)
            )
            .scoutInteractiveScale(isPressed: configuration.isPressed)
            .opacity(configuration.role == .destructive ? 0.92 : 1)
    }

    private func background(isPressed: Bool) -> some View {
        Capsule()
            .fill(ScoutTheme.accentGradient)
            .overlay {
                if isPressed {
                    Capsule()
                        .fill(Color.black.opacity(0.12))
                }
            }
            .shadow(color: ScoutShadow.glow, radius: 18, x: 0, y: 8)
    }
}

struct ScoutSecondaryGlassButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.scoutBodyEmphasis)
            .foregroundStyle(Color.scoutTextPrimary)
            .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, ScoutSpacing.lg)
            .padding(.vertical, ScoutSpacing.md)
            .background(
                Capsule()
                    .fill(Color.scoutGlassFill.opacity(configuration.isPressed ? 0.82 : 1))
                    .background(.ultraThinMaterial, in: Capsule())
            )
            .overlay(
                Capsule()
                    .stroke(Color.scoutGlassStroke, lineWidth: ScoutStroke.hairline)
            )
            .scoutInteractiveScale(isPressed: configuration.isPressed)
            .scoutPulseHighlight(isActive: configuration.isPressed)
    }
}

#Preview("Button Styles") {
    ZStack {
        ScoutTheme.screenBackground.ignoresSafeArea()

        VStack(spacing: ScoutSpacing.md) {
            Button("Next") {}
                .buttonStyle(ScoutPrimaryButtonStyle())

            Button("Back") {}
                .buttonStyle(ScoutSecondaryGlassButtonStyle())

            Button("Disabled") {}
                .buttonStyle(ScoutPrimaryButtonStyle())
                .disabled(true)
        }
        .padding()
    }
}
