//
//  PlayerSwipeScrollView.swift
//  Scout
//
//  Created by Anna on 2/19/26.
//

import SwiftUI

struct PlayerSwipeScrollView: View {
    let model: CardViewModel
    let bottomContentInset: CGFloat
    let onScrollOffsetChange: (CGFloat) -> Void
    let onPass: () -> Void
    let onBoost: () -> Void
    let onLike: () -> Void
    private let viewModel: PlayerSwipeCardViewModel

    init(
        model: CardViewModel,
        bottomContentInset: CGFloat = 0,
        onScrollOffsetChange: @escaping (CGFloat) -> Void = { _ in },
        onPass: @escaping () -> Void = {},
        onBoost: @escaping () -> Void = {},
        onLike: @escaping () -> Void = {}
    ) {
        self.model = model
        self.bottomContentInset = bottomContentInset
        self.onScrollOffsetChange = onScrollOffsetChange
        self.onPass = onPass
        self.onBoost = onBoost
        self.onLike = onLike
        self.viewModel = PlayerSwipeCardViewModel(card: model)
    }

    private let accent = Color.scoutAccentStart

    var body: some View {
        SwipeCardOverlayScrollLayout(
            bottomContentInset: bottomContentInset
        ) {
            PlayerBackgroundView(imageURL: viewModel.heroImageURL, color: accent)
        } topBar: { mergeProgress in
            heroTopBar(mergeProgress: mergeProgress)
        } content: {
            VStack(spacing: ScoutLayout.Spacing.lg) {
                identityPanel
                bestOverlapTeaser
            }
        } dock: {
            ScoutActionDock(onPass: onPass, onBoost: onBoost, onLike: onLike)
        } onScrollOffsetChange: { offsetY in
            onScrollOffsetChange(offsetY)
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
