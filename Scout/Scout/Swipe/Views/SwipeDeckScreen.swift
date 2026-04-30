//
//  SwipeDeckScreen.swift
//  Scout
//
//  Created by Codex on 4/1/26.
//

import SwiftUI

struct SwipeDeckScreen: View {
    @Environment(\.appEnvironment) private var appEnvironment
    @Environment(SessionStore.self) private var session
    @State private var vm: SwipeDeckViewModel
    let bottomContentInset: CGFloat
    let onScrollOffsetChange: (CGFloat) -> Void

    init(
        vm: SwipeDeckViewModel,
        bottomContentInset: CGFloat = 0,
        onScrollOffsetChange: @escaping (CGFloat) -> Void = { _ in }
    ) {
        _vm = State(initialValue: vm)
        self.bottomContentInset = bottomContentInset
        self.onScrollOffsetChange = onScrollOffsetChange
    }

    var body: some View {
        Group {
            if vm.isLoading {
                ProgressView()
            } else {
                SwipeDeckView(
                    vm: vm,
                    bottomContentInset: bottomContentInset,
                    onScrollOffsetChange: onScrollOffsetChange
                )
                    .environment(session)
            }
        }
        .task {
            await vm.loadCardsIfNeeded()
        }
        .onDisappear {
            onScrollOffsetChange(0)
        }
        .alert(item: $vm.alert) { item in
            Alert(
                title: Text(item.title),
                message: Text(item.message),
                dismissButton: .cancel(Text("OK"))
            )
        }
    }
}
