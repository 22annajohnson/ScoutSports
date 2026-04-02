//
//  ScoutButtonStyles.swift
//  Scout
//
//  Created by Codex on 4/1/26.
//

import SwiftUI

struct ScoutPrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        ScoutPrimaryButton(configuration: configuration)
    }

    private struct ScoutPrimaryButton: View {
        @Environment(\.isEnabled) private var isEnabled
        let configuration: Configuration

        var body: some View {
            configuration.label
                .font(.scoutBodyEmphasis)
                .foregroundStyle(Color.scoutTextOnAccent.opacity(isEnabled ? 1 : 0.82))
                .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, ScoutSpacing.lg)
                .padding(.vertical, ScoutSpacing.md)
                .background(background(isPressed: configuration.isPressed))
                .overlay(
                    Capsule()
                        .stroke(Color.white.opacity(isEnabled ? 0.18 : 0.12), lineWidth: ScoutStroke.hairline)
                )
                .scoutInteractiveScale(isPressed: isEnabled && configuration.isPressed)
                .opacity(configuration.role == .destructive ? 0.92 : 1)
        }

        private func background(isPressed: Bool) -> some View {
            Capsule()
                .fill(ScoutTheme.accentGradient)
                .overlay {
                    if isPressed && isEnabled {
                        Capsule()
                            .fill(Color.black.opacity(0.12))
                    } else if !isEnabled {
                        Capsule()
                            .fill(Color.black.opacity(0.28))
                    }
                }
                .saturation(isEnabled ? 1 : 0.2)
                .shadow(color: isEnabled ? ScoutShadow.glow : .clear, radius: 18, x: 0, y: 8)
        }
    }
}

struct ScoutSecondaryGlassButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        ScoutSecondaryButton(configuration: configuration)
    }

    private struct ScoutSecondaryButton: View {
        @Environment(\.isEnabled) private var isEnabled
        let configuration: Configuration

        var body: some View {
            configuration.label
                .font(.scoutBodyEmphasis)
                .foregroundStyle(Color.scoutTextPrimary.opacity(isEnabled ? 1 : 0.7))
                .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, ScoutSpacing.lg)
                .padding(.vertical, ScoutSpacing.md)
                .background(
                    Capsule()
                        .fill(Color.scoutGlassFill.opacity(configuration.isPressed && isEnabled ? 0.82 : (isEnabled ? 1 : 0.65)))
                        .background(.ultraThinMaterial, in: Capsule())
                )
                .overlay(
                    Capsule()
                        .stroke(Color.scoutGlassStroke.opacity(isEnabled ? 1 : 0.6), lineWidth: ScoutStroke.hairline)
                )
                .scoutInteractiveScale(isPressed: isEnabled && configuration.isPressed)
                .scoutPulseHighlight(isActive: isEnabled && configuration.isPressed)
        }
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
