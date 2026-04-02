//
//  ScoutPageHeader.swift
//  Scout
//
//  Created by Codex on 4/1/26.
//

import SwiftUI

struct ScoutPageHeader<Trailing: View>: View {
    let eyebrow: String?
    let title: String
    let subtitle: String?
    @ViewBuilder let trailing: Trailing

    init(
        eyebrow: String? = nil,
        title: String,
        subtitle: String? = nil,
        @ViewBuilder trailing: () -> Trailing = { EmptyView() }
    ) {
        self.eyebrow = eyebrow
        self.title = title
        self.subtitle = subtitle
        self.trailing = trailing()
    }

    var body: some View {
        HStack(alignment: .top, spacing: ScoutSpacing.md) {
            VStack(alignment: .leading, spacing: ScoutSpacing.sm) {
                if let eyebrow {
                    Text(eyebrow.uppercased())
                        .font(.scoutLabelCaps)
                        .tracking(3)
                        .foregroundStyle(Color.scoutTextSecondary)
                }

                Text(title)
                    .font(.scoutTitle)
                    .foregroundStyle(Color.scoutTextPrimary)

                if let subtitle {
                    Text(subtitle)
                        .font(.scoutBody)
                        .foregroundStyle(Color.scoutTextSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            Spacer(minLength: 0)

            trailing
        }
    }
}

#Preview("Page Header") {
    ZStack {
        ScoutTheme.screenBackground.ignoresSafeArea()

        GlassCard {
            ScoutPageHeader(
                eyebrow: "Onboarding",
                title: "Play Style",
                subtitle: "Choose the way you like to show up so Scout can build better pairings."
            ) {
                GlassChip(title: "2/4")
            }
        }
        .padding()
    }
}
