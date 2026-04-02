//
//  ScoutStateCard.swift
//  Scout
//
//  Created by Codex on 4/2/26.
//

import SwiftUI

struct ScoutStateCard: View {
    enum State {
        case loading
        case empty
        case error
    }

    let state: State
    let title: String
    let message: String
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil

    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: ScoutSpacing.md) {
                HStack(spacing: ScoutSpacing.md) {
                    stateIcon
                        .frame(width: 44, height: 44)
                        .background(
                            Circle()
                                .fill(Color.scoutSurfaceElevated)
                        )

                    VStack(alignment: .leading, spacing: ScoutSpacing.xxs) {
                        Text(title)
                            .font(.scoutSectionTitle)
                            .foregroundStyle(Color.scoutTextPrimary)
                            .fixedSize(horizontal: false, vertical: true)

                        Text(message)
                            .font(.scoutBody)
                            .foregroundStyle(Color.scoutTextSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }

                if let actionTitle, let action {
                    Button(actionTitle, action: action)
                        .buttonStyle(ScoutSecondaryGlassButtonStyle())
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    @ViewBuilder
    private var stateIcon: some View {
        switch state {
        case .loading:
            ProgressView()
                .tint(Color.scoutAccentStart)
        case .empty:
            Image(systemName: "sparkles")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Color.scoutAccentStart)
        case .error:
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Color.scoutWarning)
        }
    }
}

#Preview("State Cards") {
    ZStack {
        ScoutTheme.screenBackground.ignoresSafeArea()

        VStack(spacing: ScoutSpacing.md) {
            ScoutStateCard(
                state: .loading,
                title: "Loading matches",
                message: "We’re pulling the best nearby candidates for your next game."
            )

            ScoutStateCard(
                state: .empty,
                title: "Nothing here yet",
                message: "Add a couple of photos and Scout will help your profile stand out."
            )

            ScoutStateCard(
                state: .error,
                title: "Something went wrong",
                message: "We couldn’t refresh your profile right now.",
                actionTitle: "Try again",
                action: {}
            )
        }
        .padding()
    }
}
