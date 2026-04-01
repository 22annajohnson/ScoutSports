//
//  SwipeDeckViewModel.swift
//  Scout
//
//  Created by Codex on 4/1/26.
//

import Foundation
import Observation

@MainActor
@Observable
final class SwipeDeckViewModel {
    struct AlertItem: Identifiable, Equatable {
        let id = UUID()
        let title: String
        let message: String
    }

    private let cardProvider: SwipeCardProviding
    private let session: SessionStore

    private(set) var cards: [CardViewModel] = []
    private(set) var isLoading = true
    var alert: AlertItem?

    private var hasLoadedCards = false

    init(cardProvider: SwipeCardProviding, session: SessionStore) {
        self.cardProvider = cardProvider
        self.session = session
    }

    func loadCardsIfNeeded() async {
        guard !hasLoadedCards else { return }
        hasLoadedCards = true
        await loadCards()
    }

    func signOut() async {
        do {
            try await session.signOut()
        } catch {
            alert = AlertItem(
                title: "Sign out failed",
                message: error.localizedDescription
            )
        }
    }

    private func loadCards() async {
        isLoading = true
        defer { isLoading = false }

        do {
            cards = try await cardProvider.fetchCards()
        } catch {
            cards = []
            alert = AlertItem(
                title: "Couldn’t load players",
                message: error.localizedDescription
            )
        }
    }
}
