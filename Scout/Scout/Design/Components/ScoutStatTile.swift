//
//  ScoutStatTile.swift
//  Scout
//
//  Created by Codex on 4/1/26.
//

import SwiftUI

struct ScoutStatTile: View {
    let title: String
    let value: String
    var detail: String? = nil

    var body: some View {
        GlassCard(padding: ScoutLayout.Spacing.md) {
            VStack(alignment: .leading, spacing: ScoutLayout.Spacing.xs) {
                Text(title.uppercased())
                    .font(.scoutLabelCaps)
                    .tracking(2.5)
                    .foregroundStyle(Color.scoutTextSecondary)

                Text(value)
                    .font(.scoutNumberM)
                    .foregroundStyle(Color.scoutTextPrimary)

                if let detail {
                    Text(detail)
                        .font(.scoutCaption)
                        .foregroundStyle(Color.scoutTextSecondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview("Stat Tiles") {
    ZStack {
        ScoutTheme.screenBackground.ignoresSafeArea()

        HStack(spacing: ScoutLayout.Spacing.md) {
            ScoutStatTile(title: "Skill", value: "4.3")
            ScoutStatTile(title: "Win Rate", value: "71%")
            ScoutStatTile(title: "Matches", value: "38")
        }
        .padding()
    }
}
