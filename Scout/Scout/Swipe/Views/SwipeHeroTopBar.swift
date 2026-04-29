//
//  SwipeHeroTopBar.swift
//  Scout
//
//  Created by Codex on 4/23/26.
//

import SwiftUI

struct SwipeHeroTopBar: View {
    let viewModel: SwipeHeroTopBarViewModel

    private var readableAccent: Color {
        Color.scoutAccentEnd.opacity(0.96)
    }

    private var brandAccent: Color {
        Color.white.opacity(0.92)
    }

    init(
        model: SwipeHeroTopBarViewModel.Model,
        mergeProgress: CGFloat = 0
    ) {
        self.viewModel = SwipeHeroTopBarViewModel(model: model, mergeProgress: mergeProgress)
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            expandedHeader
                .opacity(expandedOpacity)

            compactHeader
                .opacity(compactOpacity)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .scaleEffect(viewModel.scale, anchor: .topLeading)
        .opacity(viewModel.opacity)
    }

    private var expandedOpacity: Double {
        switch viewModel.displayMode {
        case .expanded:
            return 1
        case .transitioning, .compact:
            return Double(1 - viewModel.compactProgress)
        }
    }

    private var compactOpacity: Double {
        switch viewModel.displayMode {
        case .expanded:
            return 0
        case .transitioning, .compact:
            return Double(viewModel.compactProgress)
        }
    }

    private var expandedHeader: some View {
        VStack(alignment: .leading, spacing: ScoutSpacing.lg) {
            VStack(alignment: .leading, spacing: ScoutSpacing.xs) {
                Text("SCOUT")
                    .font(.scoutMicro)
                    .tracking(5)
                    .foregroundStyle(brandAccent)
                    .shadow(color: Color.black.opacity(0.28), radius: 10, y: 2)

                Text(viewModel.model.title)
                    .font(.scoutHeroTitle)
                    .foregroundStyle(Color.white)
                    .lineLimit(2)
                    .minimumScaleFactor(0.78)
            }

            metaPill(viewModel.model.distance, systemImage: "location")
        }
    }

    private var compactHeader: some View {
        SwipeCompactHeaderCard {
            HStack(alignment: .center, spacing: ScoutSpacing.md) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("SCOUT")
                        .font(.scoutMicro)
                        .tracking(4)
                        .foregroundStyle(brandAccent)

                    Text(viewModel.model.title)
                        .font(.scoutSectionTitle)
                        .foregroundStyle(Color.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.72)
                        .layoutPriority(1)
                }

                Spacer(minLength: ScoutSpacing.sm)

                metaPill(viewModel.model.distance, systemImage: "location")
                    .fixedSize(horizontal: true, vertical: false)
            }
        }
    }

    private func metaPill(_ title: String, systemImage: String) -> some View {
        HStack(spacing: ScoutSpacing.sm) {
            Image(systemName: systemImage)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(readableAccent)

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
                model: .init(
                    title: "Find your next match",
                    distance: "2.1 mi away"
                )
            )
            Spacer()
        }
        .padding()
    }
}
