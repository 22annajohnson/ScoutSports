//
//  StateAndMotionPreview.swift
//  Scout
//
//  Created by Codex on 4/2/26.
//

import SwiftUI

private struct StateAndMotionPreview: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: ScoutLayout.Spacing.xl) {
                Text("POLISH")
                    .font(.scoutLabelCaps)
                    .tracking(3)
                    .foregroundStyle(Color.scoutTextSecondary)

                Text("States and Motion")
                    .font(.scoutDisplayCompact)
                    .foregroundStyle(Color.scoutTextPrimary)

                VStack(spacing: ScoutLayout.Spacing.md) {
                    Button("Primary Action") {}
                        .buttonStyle(ScoutPrimaryButtonStyle())

                    Button("Secondary Action") {}
                        .buttonStyle(ScoutSecondaryGlassButtonStyle())
                }

                HStack(spacing: ScoutLayout.Spacing.sm) {
                    GlassChip(title: "New", style: .accent, isEmphasized: true)
                    GlassChip(title: "Selected", systemImage: "checkmark", style: .selected, isEmphasized: true)
                    GlassChip(title: "Nearby")
                }

                ScoutActionDock()

                ScoutStateCard(
                    state: .loading,
                    title: "Loading profile",
                    message: "We’re preparing the next step and keeping the flow polished while data arrives."
                )

                ScoutStateCard(
                    state: .empty,
                    title: "Nothing to show yet",
                    message: "Use themed empty states instead of leaving blank surfaces."
                )

                ScoutStateCard(
                    state: .error,
                    title: "Couldn’t finish that",
                    message: "Error states should feel native to the same visual system.",
                    actionTitle: "Retry",
                    action: {}
                )
            }
            .padding(ScoutLayout.Spacing.xl)
        }
        .background(ScoutTheme.screenBackground.ignoresSafeArea())
    }
}

#Preview("State + Motion") {
    StateAndMotionPreview()
}
