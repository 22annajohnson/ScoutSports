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
                .padding(.horizontal, ScoutLayout.Spacing.lg)
                .padding(.vertical, ScoutLayout.Spacing.md)
                .background(background(isPressed: configuration.isPressed))
                .overlay(
                    Capsule()
                        .stroke((isEnabled ? Color.scoutOnImageStroke : Color.scoutGlassHighlight), lineWidth: ScoutLayout.Stroke.hairline)
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
                            .fill(Color.scoutScrimSoft)
                    } else if !isEnabled {
                        Capsule()
                            .fill(Color.scoutScrimStrong)
                    }
                }
                .saturation(isEnabled ? 1 : 0.2)
                .shadow(color: isEnabled ? Color.scoutShadowGlow : .clear, radius: 18, x: 0, y: 8)
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
                .padding(.horizontal, ScoutLayout.Spacing.lg)
                .padding(.vertical, ScoutLayout.Spacing.md)
                .background(
                    Capsule()
                        .fill(Color.scoutGlassFill.opacity(configuration.isPressed && isEnabled ? 0.82 : (isEnabled ? 1 : 0.65)))
                        .background(.ultraThinMaterial, in: Capsule())
                )
                .overlay(
                    Capsule()
                        .stroke(Color.scoutGlassStroke.opacity(isEnabled ? 1 : 0.6), lineWidth: ScoutLayout.Stroke.hairline)
                )
                .scoutInteractiveScale(isPressed: isEnabled && configuration.isPressed)
                .scoutPulseHighlight(isActive: isEnabled && configuration.isPressed)
        }
    }
}

#Preview("Button Styles") {
    ZStack {
        ScoutTheme.screenBackground.ignoresSafeArea()

        VStack(spacing: ScoutLayout.Spacing.md) {
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
