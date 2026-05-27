//
//  ScoutSegmentedToggle.swift
//  Scout
//
//  Created by Codex on 5/5/26.
//

import SwiftUI

public struct ScoutSegmentedToggle<Option: Identifiable & Hashable>: View {
    let options: [Option]
    let selection: Option
    let title: (Option) -> String
    let onSelect: (Option) -> Void

    public init(
        options: [Option],
        selection: Option,
        title: @escaping (Option) -> String,
        onSelect: @escaping (Option) -> Void
    ) {
        self.options = options
        self.selection = selection
        self.title = title
        self.onSelect = onSelect
    }

    public var body: some View {
        HStack(spacing: ScoutLayout.Spacing.xs) {
            ForEach(options) { option in
                Button(title(option)) {
                    onSelect(option)
                }
                .buttonStyle(ScoutSegmentedToggleButtonStyle(isSelected: selection == option))
            }
        }
        .padding(ScoutLayout.Spacing.xs)
        .background(
            Color.scoutGlassFill.opacity(0.78),
            in: RoundedRectangle(cornerRadius: ScoutLayout.Radius.xl, style: .continuous)
        )
        .overlay(
            RoundedRectangle(cornerRadius: ScoutLayout.Radius.xl, style: .continuous)
                .stroke(Color.scoutFeedCardStroke, lineWidth: ScoutLayout.Stroke.hairline)
        )
    }
}

private struct ScoutSegmentedToggleButtonStyle: ButtonStyle {
    let isSelected: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.scoutCallout)
            .foregroundStyle(isSelected ? Color.scoutTextOnAccent : Color.scoutTextPrimary.opacity(0.8))
            .frame(maxWidth: .infinity)
            .padding(.vertical, ScoutLayout.Spacing.sm)
            .background(
                Group {
                    if isSelected {
                        RoundedRectangle(cornerRadius: ScoutLayout.Radius.lg, style: .continuous)
                            .fill(ScoutTheme.accentGradient)
                    } else {
                        RoundedRectangle(cornerRadius: ScoutLayout.Radius.lg, style: .continuous)
                            .fill(Color.clear)
                    }
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: ScoutLayout.Radius.lg, style: .continuous)
                    .stroke(
                        isSelected ? Color.scoutGlassHighlightStrong : Color.clear,
                        lineWidth: ScoutLayout.Stroke.hairline
                    )
            )
            .scaleEffect(configuration.isPressed ? 0.985 : 1)
            .animation(ScoutMotion.press, value: configuration.isPressed)
    }
}
