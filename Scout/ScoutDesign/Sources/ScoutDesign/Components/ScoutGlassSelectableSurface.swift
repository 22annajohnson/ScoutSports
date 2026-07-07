//
//  ScoutGlassSelectableSurface.swift
//  Scout
//
//  Created by Codex on 4/29/26.
//

import SwiftUI

public struct ScoutGlassSelectableSurface: ViewModifier {
    let isSelected: Bool
    let cornerRadius: CGFloat

    public init(isSelected: Bool, cornerRadius: CGFloat = ScoutLayout.Radius.lg) {
        self.isSelected = isSelected
        self.cornerRadius = cornerRadius
    }

    public func body(content: Content) -> some View {
        let shape = RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)

        content
            .background(
                shape
                    .fill(isSelected ? Color.scoutSurfaceElevated : Color.scoutGlassFill)
                    .background(.ultraThinMaterial, in: shape)
            )
            .overlay(
                shape
                    .stroke(
                        isSelected ? Color.scoutAccentStart.opacity(0.55) : Color.scoutGlassStroke,
                        lineWidth: isSelected ? ScoutLayout.Stroke.emphasis : ScoutLayout.Stroke.hairline
                    )
            )
    }
}

public extension View {
    func scoutGlassSelectableSurface(
        isSelected: Bool,
        cornerRadius: CGFloat = ScoutLayout.Radius.lg
    ) -> some View {
        modifier(ScoutGlassSelectableSurface(isSelected: isSelected, cornerRadius: cornerRadius))
    }
}
