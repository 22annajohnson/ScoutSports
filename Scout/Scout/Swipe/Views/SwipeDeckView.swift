//
//  SwipeDeckView.swift
//  Scout
//
//  Created by Anna on 2/19/26.
//

import SwiftUI

struct SwipeDeckView: View {
    let vm: SwipeDeckViewModel

    @State private var index = 0
    @State private var drag: CGSize = .zero
    @State private var isSwipingHorizontally = false
    @State private var isDismissing = false
    @State private var showMatch = false
    @State private var matchedModel: CardViewModel? = nil
    @State private var showProfileBuilder = false
    @State private var dismissalTask: Task<Void, Never>?
    @Environment(\.appEnvironment) private var appEnvironment
    @Environment(SessionStore.self) private var session

    private let threshold: CGFloat = 140
    
    private var models: [CardViewModel] { vm.cards }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                if index < models.count {
                    let dx = drag.width
                    let progress = min(abs(dx) / threshold, 1)
                    let side: SwipeArcShape.Side = dx < 0 ? .right : .left

                    // NEXT card underneath (full-screen, becomes clear as progress -> 1)
                    if index + 1 < models.count {
                        // Ease so it stays blurrier early and clears as you commit
                        let eased = pow(progress, 0.9)
                        let blurRadius = max(0, 18 * (1 - eased))
                        let dimOpacity = 0.10 * (1 - eased)

                        PlayerSwipeScrollView(model: models[index + 1])
                            .id(index + 1)
                            .scrollDisabled(true)
                            .blur(radius: blurRadius)
                            .overlay(Color.black.opacity(dimOpacity).allowsHitTesting(false))
                            .animation(.easeOut(duration: 0.12), value: progress)
                            .zIndex(0)
                    }

                    // CURRENT card on top
                    PlayerSwipeScrollView(
                        model: models[index],
                        onPass: { triggerDockSwipe(.pass, geo: geo) },
                        onBoost: { triggerDockSwipe(.like, geo: geo) },
                        onLike: { triggerDockSwipe(.like, geo: geo) }
                    )
                        .id(index)
                        .scrollDisabled(isSwipingHorizontally)
                        .offset(x: dx, y: 0)
                        .rotationEffect(.degrees(Double(dx / 26)))
                        .animation(.interactiveSpring(response: 0.28, dampingFraction: 0.86), value: drag)
                        .zIndex(1)
                        .simultaneousGesture(
                            DragGesture(minimumDistance: 10)
                                .onChanged { value in
                                    guard !isDismissing else { return }

                                    let dx = value.translation.width
                                    let dy = value.translation.height

                                    // Only treat it as a swipe if it is clearly horizontal.
                                    // Otherwise, let the inner ScrollView handle vertical scrolling.
                                    if abs(dx) > abs(dy) {
                                        isSwipingHorizontally = true
                                        drag = CGSize(width: dx, height: 0)
                                    }
                                }
                                .onEnded { _ in
                                    guard !isDismissing else { return }

                                    if isSwipingHorizontally {
                                        finishSwipe(dx: drag.width, geo: geo)
                                    }

                                    // Reset the horizontal swipe mode after the gesture ends.
                                    isSwipingHorizontally = false
                                }
                        )

                    // Arc reveal overlay (still sits above everything)
                    if progress > 0 {
                        SwipeArcOverlay(
                            side: side,
                            progress: progress,
                            color: side == .left ? Color.scout : Color.gray,
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
                        .background(Color(.systemBackground))
                }
            }
        }
        .onDisappear {
            dismissalTask?.cancel()
            dismissalTask = nil
            drag = .zero
            isSwipingHorizontally = false
            isDismissing = false
        }
        .overlay(alignment: .topLeading) {
            #if DEBUG
            VStack(alignment: .leading, spacing: 10) {
                Button {
                    Task { await vm.signOut() }
                } label: {
                    Label("Sign out", systemImage: "rectangle.portrait.and.arrow.right")
                        .font(.subheadline.weight(.semibold))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                }

                Button {
                    showProfileBuilder = true
                } label: {
                    Label("Edit Profile", systemImage: "person.crop.circle")
                        .font(.subheadline.weight(.semibold))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                }
            }
            .padding(.top, 16)
            .padding(.leading, 16)
            #endif
        }
        .fullScreenCover(isPresented: $showMatch) {
            if let matchedModel {
                MatchView(
                    currentUserName: "You",
                    matchedUserName: matchedModel.name,
                    currentUserImageURL: nil,
                    matchedUserImageURL: matchedModel.heroImageURL,
                    accent: Color.scout,
                    onProposeTime: {},
                    onSendMessage: {}
                )
            }
        }
        .fullScreenCover(isPresented: $showProfileBuilder) {
            ProfileBuilderView(
                vm: appEnvironment.makeProfileBuilderViewModel(
                    userIDProvider: { session.userID }
                )
            )
                .environment(session)
        }
    }

    private enum DockSwipeAction {
        case pass
        case like
    }

    @MainActor
    private func triggerDockSwipe(_ action: DockSwipeAction, geo: GeometryProxy) {
        guard !isDismissing, index < models.count else { return }

        let swipeDistance = threshold + 1
        let dx: CGFloat = action == .like ? swipeDistance : -swipeDistance
        finishSwipe(dx: dx, geo: geo)
    }

    @MainActor
    private func finishSwipe(dx: CGFloat, geo: GeometryProxy) {
        let shouldDismiss = abs(dx) > threshold
        let direction: CGFloat = dx >= 0 ? 1 : -1
        let isRightSwipe = dx > 0
        let isMutualLike = isRightSwipe && index < models.count && models[index].didLike

        if shouldDismiss {
            isDismissing = true
            isSwipingHorizontally = true

            // Animate card off-screen
            withAnimation(.easeInOut(duration: 0.22)) {
                drag = CGSize(width: direction * (geo.size.width + 160), height: 0)
            }

            dismissalTask?.cancel()
            dismissalTask = Task {
                try? await Task.sleep(for: .milliseconds(230))
                guard !Task.isCancelled else { return }

                // Swap & reset with animations disabled to avoid flashing the previous card
                var transaction = Transaction()
                transaction.disablesAnimations = true

                if isMutualLike {
                    matchedModel = models[index]
                    showMatch = true
                }

                withTransaction(transaction) {
                    drag = .zero
                    isSwipingHorizontally = false
                    isDismissing = false
                    index += 1
                }
            }
        } else {
            // Snap back with a nice spring
            withAnimation(.spring(response: 0.35, dampingFraction: 0.86)) {
                drag = .zero
            }
        }
    }
}
