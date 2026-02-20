//
//  HeroHeaderViewModel'.swift
//  Scout
//
//  Created by Anna on 2/19/26.
//

import SwiftUI

struct HeroHeaderViewModel: Identifiable {
    var id: UUID = UUID()
    var imageURL: URL
    var name: String
    var score: Int
    var accent: Color
}

func getRandomHeroHeaderViewModel() -> HeroHeaderViewModel {
    HeroHeaderViewModel(
        imageURL: URL(string: "https://picsum.photos/400/600")!,
        name: getRandomName(),
        score: Int.random(in: 0...100),
        accent: Color.secondaryAccent
    )
}
