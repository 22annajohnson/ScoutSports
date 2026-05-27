//
//  SwipeHeroTopBar.swift
//  Scout
//
//  Created by Codex on 4/23/26.
//

import SwiftUI
import ScoutDesign

struct SwipeHeroTopBar: View {
    let viewModel: SwipeHeroTopBarViewModel

    private var readableAccent: Color {
        Color.scoutAccentEnd.opacity(0.96)
    }

    private var brandAccent: Color {
        Color.scoutAccentEnd.opacity(0.96)
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
        VStack(alignment: .leading, spacing: ScoutLayout.Spacing.lg) {
            VStack(alignment: .leading, spacing: ScoutLayout.Spacing.xs) {
                Text("SCOUT")
                    .font(.scoutMicro)
                    .tracking(5)
                    .foregroundStyle(brandAccent)
                    .shadow(color: Color.scoutScrimStrong, radius: 10, y: 2)

                Text(viewModel.model.title)
                    .font(.scoutHeroTitle)
                    .foregroundStyle(Color.scoutOnImageTextPrimary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.78)
            }

            metaPill(viewModel.model.distance, systemImage: "location")
        }
    }

    private var compactHeader: some View {
        SwipeCompactHeaderCard {
            HStack(alignment: .center, spacing: ScoutLayout.Spacing.md) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("SCOUT")
                        .font(.scoutMicro)
                        .tracking(4)
                        .foregroundStyle(brandAccent)

                    Text(viewModel.model.title)
                        .font(.scoutSectionTitle)
                        .foregroundStyle(Color.scoutOnImageTextPrimary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.72)
                        .layoutPriority(1)
                }

                Spacer(minLength: ScoutLayout.Spacing.sm)

                metaPill(viewModel.model.distance, systemImage: "location")
                    .fixedSize(horizontal: true, vertical: false)
            }
        }
    }

    private func metaPill(_ title: String, systemImage: String) -> some View {
        HStack(spacing: ScoutLayout.Spacing.sm) {
            Image(systemName: systemImage)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(readableAccent)

            Text(title)
                .font(.scoutCallout)
                .foregroundStyle(Color.scoutOnImageTextSecondary)
                .lineLimit(1)
                .minimumScaleFactor(0.88)
        }
        .padding(.horizontal, ScoutLayout.Spacing.md)
        .padding(.vertical, ScoutLayout.Spacing.sm)
        .background(
            Capsule()
                .fill(Color.scoutScrimStrong)
                .background(.ultraThinMaterial, in: Capsule())
        )
        .overlay(
            Capsule()
                .stroke(Color.scoutOnImageStrokeSoft, lineWidth: ScoutLayout.Stroke.hairline)
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
