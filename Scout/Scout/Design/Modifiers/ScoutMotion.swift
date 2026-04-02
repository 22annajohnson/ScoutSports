//
//  ScoutMotion.swift
//  Scout
//
//  Created by Codex on 4/2/26.
//

import SwiftUI

enum ScoutMotion {
    static let press = Animation.spring(response: 0.22, dampingFraction: 0.88)
    static let selection = Animation.spring(response: 0.28, dampingFraction: 0.84)
    static let emphasis = Animation.easeInOut(duration: 0.18)
}

struct ScoutInteractiveScale: ViewModifier {
    let isPressed: Bool
    var pressedScale: CGFloat = 0.98

    func body(content: Content) -> some View {
        content
            .scaleEffect(isPressed ? pressedScale : 1)
            .animation(ScoutMotion.press, value: isPressed)
    }
}

struct ScoutPulseHighlight: ViewModifier {
    let isActive: Bool

    func body(content: Content) -> some View {
        content
            .overlay {
                if isActive {
                    RoundedRectangle(cornerRadius: ScoutRadius.lg, style: .continuous)
                        .stroke(Color.white.opacity(0.14), lineWidth: 1)
                        .blur(radius: 2)
                        .transition(.opacity)
                }
            }
            .animation(ScoutMotion.emphasis, value: isActive)
    }
}

extension View {
    func scoutInteractiveScale(isPressed: Bool, pressedScale: CGFloat = 0.98) -> some View {
        modifier(ScoutInteractiveScale(isPressed: isPressed, pressedScale: pressedScale))
    }

    func scoutPulseHighlight(isActive: Bool) -> some View {
        modifier(ScoutPulseHighlight(isActive: isActive))
    }
}
