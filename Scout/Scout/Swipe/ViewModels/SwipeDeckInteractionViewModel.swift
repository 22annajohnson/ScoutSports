//
//  SwipeDeckInteractionViewModel.swift
//  Scout
//
//  Created by Codex on 4/27/26.
//

import Observation
import SwiftUI

@MainActor
@Observable
final class SwipeDeckInteractionViewModel {
    enum SwipeAction {
        case pass
        case like
    }

    private let threshold: CGFloat = 140
    private var dismissalTask: Task<Void, Never>?

    var currentIndex = 0
    var dragOffset: CGSize = .zero
    var isSwipingHorizontally = false
    var isDismissing = false
    var matchPresentation: MatchView.Model?

    var swipeProgress: CGFloat {
        min(abs(dragOffset.width) / threshold, 1)
    }

    var overlaySide: SwipeArcShape.Side {
        dragOffset.width < 0 ? .right : .left
    }

    func currentCard(in cards: [CardViewModel]) -> CardViewModel? {
        guard currentIndex < cards.count else { return nil }
        return cards[currentIndex]
    }

    func nextCard(in cards: [CardViewModel]) -> CardViewModel? {
        let nextIndex = currentIndex + 1
        guard nextIndex < cards.count else { return nil }
        return cards[nextIndex]
    }

    func beginDrag(translation: CGSize) {
        guard !isDismissing else { return }

        let dx = translation.width
        let dy = translation.height

        if abs(dx) > abs(dy) {
            isSwipingHorizontally = true
            dragOffset = CGSize(width: dx, height: 0)
        }
    }

    func endDrag(cardWidth: CGFloat, currentCard: CardViewModel?) {
        guard !isDismissing else { return }

        if isSwipingHorizontally {
            finishSwipe(dx: dragOffset.width, cardWidth: cardWidth, currentCard: currentCard)
        }

        isSwipingHorizontally = false
    }

    func triggerDockSwipe(_ action: SwipeAction, cardWidth: CGFloat, currentCard: CardViewModel?) {
        guard !isDismissing, currentCard != nil else { return }

        let swipeDistance = threshold + 1
        let dx: CGFloat = action == .like ? swipeDistance : -swipeDistance
        finishSwipe(dx: dx, cardWidth: cardWidth, currentCard: currentCard)
    }

    func cleanupTransientState() {
        dismissalTask?.cancel()
        dismissalTask = nil
        dragOffset = .zero
        isSwipingHorizontally = false
        isDismissing = false
    }

    private func finishSwipe(dx: CGFloat, cardWidth: CGFloat, currentCard: CardViewModel?) {
        let shouldDismiss = abs(dx) > threshold
        let direction: CGFloat = dx >= 0 ? 1 : -1
        let isRightSwipe = dx > 0
        let isMutualLike = isRightSwipe && (currentCard?.didLike == true)

        if shouldDismiss {
            isDismissing = true
            isSwipingHorizontally = true

            withAnimation(.easeInOut(duration: 0.22)) {
                dragOffset = CGSize(width: direction * (cardWidth + 160), height: 0)
            }

            dismissalTask?.cancel()
            dismissalTask = Task {
                try? await Task.sleep(for: .milliseconds(230))
                guard !Task.isCancelled else { return }

                var transaction = Transaction()
                transaction.disablesAnimations = true

                if isMutualLike, let currentCard {
                    matchPresentation = MatchView.Model(
                        currentUserName: "You",
                        matchedUserName: currentCard.name,
                        currentUserImageURL: nil,
                        matchedUserImageURL: currentCard.heroImageURL
                    )
                }

                withTransaction(transaction) {
                    dragOffset = .zero
                    isSwipingHorizontally = false
                    isDismissing = false
                    currentIndex += 1
                }
            }
        } else {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.86)) {
                dragOffset = .zero
            }
        }
    }
}
