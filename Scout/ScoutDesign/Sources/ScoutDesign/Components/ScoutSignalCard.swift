//
//  ScoutSignalCard.swift
//  Scout
//
//  Created by Codex on 5/5/26.
//

import SwiftUI

public struct ScoutSignalCard: View {
    public static let defaultWidth: CGFloat = 220
    public static let defaultHeight: CGFloat = 168

    let eyebrow: String
    let value: String
    let detail: String
    var width: CGFloat = ScoutSignalCard.defaultWidth
    var height: CGFloat = ScoutSignalCard.defaultHeight

    public init(
        eyebrow: String,
        value: String,
        detail: String,
        width: CGFloat = ScoutSignalCard.defaultWidth,
        height: CGFloat = ScoutSignalCard.defaultHeight
    ) {
        self.eyebrow = eyebrow
        self.value = value
        self.detail = detail
        self.width = width
        self.height = height
    }

    public var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: ScoutLayout.Spacing.sm) {
                Text(eyebrow.uppercased())
                    .font(.scoutLabelCaps)
                    .tracking(ScoutLayout.Tracking.micro)
                    .foregroundStyle(Color.scoutTextSecondary)

                Text(value)
                    .font(.scoutNumberM)
                    .foregroundStyle(Color.scoutTextPrimary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.72)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text(detail)
                    .font(.scoutCaption)
                    .foregroundStyle(Color.scoutTextSecondary)
                    .lineLimit(3)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        }
        .frame(width: width, height: height)
    }
}

#Preview {
    ZStack {
        ScoutTheme.screenBackground.ignoresSafeArea()

        ScoutSignalCard(
            eyebrow: "Momentum",
            value: "3 friends active",
            detail: "Irving Park and Baseline Social are both seeing fresh movement."
        )
    }
}
