//
//  SwipeHeroTopBar.swift
//  Scout
//
//  Created by Codex on 4/23/26.
//

import SwiftUI

struct SwipeHeroTopBar: View {
    let title: String
    let distance: String

    var body: some View {
        VStack(alignment: .leading, spacing: ScoutSpacing.lg) {
            VStack(alignment: .leading, spacing: ScoutSpacing.xs) {
                Text("SCOUT")
                    .font(.scoutMicro)
                    .tracking(5)
                    .foregroundStyle(Color.scoutAccentStart)

                Text(title)
                    .font(.scoutHeroTitle)
                    .foregroundStyle(Color.white)
                    .lineLimit(2)
                    .minimumScaleFactor(0.78)
            }

            metaPill(distance, systemImage: "location")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func metaPill(_ title: String, systemImage: String) -> some View {
        HStack(spacing: ScoutSpacing.sm) {
            Image(systemName: systemImage)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(Color.scoutAccentStart)

            Text(title)
                .font(.scoutCallout)
                .foregroundStyle(Color.white.opacity(0.94))
                .lineLimit(1)
                .minimumScaleFactor(0.88)
        }
        .padding(.horizontal, ScoutSpacing.md)
        .padding(.vertical, ScoutSpacing.sm)
        .background(
            Capsule()
                .fill(Color.black.opacity(0.28))
                .background(.ultraThinMaterial, in: Capsule())
        )
        .overlay(
            Capsule()
                .stroke(Color.white.opacity(0.14), lineWidth: ScoutStroke.hairline)
        )
    }
}

#Preview("Swipe Hero Top Bar") {
    ZStack {
        PlayerBackgroundView(imageURL: randomMockCardViewModel().heroImageURL, color: .scoutAccentStart)
            .ignoresSafeArea()

        VStack {
            SwipeHeroTopBar(
                title: "Find your next match",
                distance: "2.1 mi away"
            )
            Spacer()
        }
        .padding()
    }
}
