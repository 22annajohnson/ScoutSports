//
//  SwipeDeckView.swift
//  Scout
//
//  Created by Anna on 2/19/26.
//

import SwiftUI

struct SwipeDeckView: View {
    let vm: SwipeDeckViewModel
    let bottomContentInset: CGFloat
    let onScrollOffsetChange: (CGFloat) -> Void

    @State private var interaction = SwipeDeckInteractionViewModel()

    private var models: [CardViewModel] { vm.cards }
    private var currentModel: CardViewModel? { interaction.currentCard(in: models) }
    private var nextModel: CardViewModel? { interaction.nextCard(in: models) }

    var body: some View {
        @Bindable var interaction = interaction

        GeometryReader { geo in
            ZStack {
                if let currentModel {
                    let dx = interaction.dragOffset.width
                    let progress = interaction.swipeProgress
                    let side = interaction.overlaySide
                    let backgroundPresentation = interaction.backgroundCardPresentation

                    // NEXT card underneath (full-screen, becomes clear as progress -> 1)
                    if let nextModel {
                        PlayerSwipeScrollView(model: nextModel)
                            .id(nextModel.id)
                            .scrollDisabled(true)
                            .blur(radius: backgroundPresentation.blurRadius)
                            .overlay(Color.scoutBackground.opacity(backgroundPresentation.dimOpacity).allowsHitTesting(false))
                            .animation(.easeOut(duration: 0.12), value: progress)
                            .zIndex(0)
                    }

                    // CURRENT card on top
                    PlayerSwipeScrollView(
                        model: currentModel,
                        bottomContentInset: bottomContentInset,
                        onScrollOffsetChange: onScrollOffsetChange,
                        onPass: { interaction.triggerDockSwipe(.pass, cardWidth: geo.size.width, currentCard: currentModel) },
                        onBoost: { interaction.triggerDockSwipe(.like, cardWidth: geo.size.width, currentCard: currentModel) },
                        onLike: { interaction.triggerDockSwipe(.like, cardWidth: geo.size.width, currentCard: currentModel) }
                    )
                        .id(currentModel.id)
                        .scrollDisabled(interaction.isSwipingHorizontally)
                        .offset(x: dx, y: 0)
                        .rotationEffect(.degrees(Double(dx / 26)))
                        .animation(.interactiveSpring(response: 0.28, dampingFraction: 0.86), value: interaction.dragOffset)
                        .zIndex(1)
                        .simultaneousGesture(
                            DragGesture(minimumDistance: 10)
                                .onChanged { value in
                                    interaction.beginDrag(translation: value.translation)
                                }
                                .onEnded { _ in
                                    interaction.endDrag(cardWidth: geo.size.width, currentCard: currentModel)
                                }
                        )

                    // Arc reveal overlay (still sits above everything)
                    if progress > 0 {
                        SwipeArcOverlay(
                            side: side,
                            progress: progress,
                            color: side == .left ? Color.scoutAccentEnd : Color.scoutTextSecondary,
                            title: side == .right ? "NEXT TIME" : "MATCH"
                        )
                        .allowsHitTesting(false)
                        .ignoresSafeArea()
                        .transition(.opacity)
                        .zIndex(2)
                    }

                } else {
                    Text("No more players")
                        .font(.title.bold())
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.scoutBackground)
                }
            }
        }
        .onDisappear {
            interaction.cleanupTransientState()
        }
        .fullScreenCover(item: $interaction.matchPresentation) { matchPresentation in
                MatchView(
                    model: matchPresentation,
                    accent: Color.scoutAccentEnd,
                    onProposeTime: {},
                    onSendMessage: {}
                )
        }
    }
}
