//
//  PlayerSwipeScrollView.swift
//  Scout
//
//  Created by Anna on 2/19/26.
//

import SwiftUI

struct PlayerSwipeScrollView: View {
    let model: CardViewModel
    let onPass: () -> Void
    let onBoost: () -> Void
    let onLike: () -> Void
    private let viewModel: PlayerSwipeCardViewModel

    init(
        model: CardViewModel,
        onPass: @escaping () -> Void = {},
        onBoost: @escaping () -> Void = {},
        onLike: @escaping () -> Void = {}
    ) {
        self.model = model
        self.onPass = onPass
        self.onBoost = onBoost
        self.onLike = onLike
        self.viewModel = PlayerSwipeCardViewModel(card: model)
    }

    private let accent = Color.scoutAccentStart

    var body: some View {
        SwipeCardOverlayScrollLayout {
            PlayerBackgroundView(imageURL: viewModel.heroImageURL, color: accent)
        } topBar: { mergeProgress in
            heroTopBar(mergeProgress: mergeProgress)
        } content: {
            VStack(spacing: ScoutSpacing.lg) {
                identityPanel
                bestOverlapTeaser
            }
        } dock: {
            ScoutActionDock(onPass: onPass, onBoost: onBoost, onLike: onLike)
        }
        .onAppear {
            UIScrollView.appearance().bounces = false
        }
        .onDisappear {
            UIScrollView.appearance().bounces = true
        }
    }

    @ViewBuilder
    private func heroTopBar(mergeProgress: CGFloat) -> some View {
        SwipeHeroTopBar(
            model: .init(
                title: viewModel.screenTitle,
                distance: viewModel.distanceLabel
            ),
            mergeProgress: mergeProgress
        )
    }

    private var identityPanel: some View {
        SwipeCardIdentitySection(
            model: viewModel.identitySection
        )
    }

    private var bestOverlapTeaser: some View {
        SwipeBestOverlapTeaser(
            model: viewModel.bestOverlapSection
        )
    }
}

#Preview {
    PlayerSwipeScrollView(model: randomMockCardViewModel())
}
