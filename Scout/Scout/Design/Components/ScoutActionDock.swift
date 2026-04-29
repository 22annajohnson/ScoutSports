//
//  ScoutActionDock.swift
//  Scout
//
//  Created by Codex on 4/1/26.
//

import SwiftUI

struct ScoutActionDock: View {
    let onPass: () -> Void
    let onBoost: () -> Void
    let onLike: () -> Void

    init(
        onPass: @escaping () -> Void = {},
        onBoost: @escaping () -> Void = {},
        onLike: @escaping () -> Void = {}
    ) {
        self.onPass = onPass
        self.onBoost = onBoost
        self.onLike = onLike
    }

    var body: some View {
        HStack(spacing: ScoutSpacing.lg) {
            actionButton(systemImage: "xmark", size: 68, action: onPass)

            Button(action: onBoost) {
                Image(systemName: "bolt.fill")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(Color.scoutTextOnAccent)
                    .frame(width: 96, height: 96)
                    .background(
                        Circle()
                            .fill(ScoutTheme.accentGradient)
                    )
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(0.18), lineWidth: ScoutStroke.hairline)
                    )
                    .shadow(color: ScoutShadow.glow, radius: 22, x: 0, y: 10)
            }
            .buttonStyle(ScoutDockButtonStyle())

            actionButton(systemImage: "heart", size: 68, action: onLike)
        }
        .padding(.horizontal, ScoutSpacing.xl)
        .padding(.vertical, ScoutSpacing.md)
        .background(
            Capsule()
                .fill(Color.scoutGlassFill)
                .background(.ultraThinMaterial, in: Capsule())
        )
        .overlay(
            Capsule()
                .stroke(Color.scoutGlassStroke, lineWidth: ScoutStroke.hairline)
        )
        .shadow(color: Color.black.opacity(0.12), radius: 18, y: 10)
    }

    private func actionButton(systemImage: String, size: CGFloat, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.system(size: 24, weight: .semibold))
                .foregroundStyle(Color.scoutTextPrimary)
                .frame(width: size, height: size)
                .background(
                    Circle()
                        .fill(Color.scoutSwipeOverlaySurface)
                        .background(.ultraThinMaterial, in: Circle())
                )
                .overlay(
                    Circle()
                        .stroke(Color.scoutSwipeOverlayStroke, lineWidth: ScoutStroke.hairline)
                )
        }
        .buttonStyle(ScoutDockButtonStyle())
    }
}

private struct ScoutDockButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scoutInteractiveScale(isPressed: configuration.isPressed, pressedScale: 0.96)
            .brightness(configuration.isPressed ? -0.04 : 0)
            .animation(ScoutMotion.press, value: configuration.isPressed)
    }
}

#Preview("Action Dock") {
    ZStack {
        ScoutTheme.screenBackground.ignoresSafeArea()

        ScoutActionDock()
            .padding()
    }
}
