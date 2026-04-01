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

    init(vm: SwipeDeckViewModel) {
        _vm = State(initialValue: vm)
    }

    var body: some View {
        Group {
            if vm.isLoading {
                ProgressView()
            } else {
                SwipeDeckView(vm: vm)
                    .environment(session)
            }
        }
        .task {
            await vm.loadCardsIfNeeded()
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
