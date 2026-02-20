//
//  ContentView.swift
//  Scout
//
//  Created by Anna on 2/19/26.
//

import SwiftUI

struct ContentView: View {
    @State var model: CardViewModel
    var body: some View {
        VStack {
//            RatingsView(stats: model.stats)
            PlayerSwipeScrollView(model: model)
        }
    }
}

#Preview {
    ContentView(model: randomMockCardViewModel())
}
