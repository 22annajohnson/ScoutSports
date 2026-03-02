//
//  PlayerHeroHeaderView.swift
//  Scout
//
//  Created by Anna on 2/19/26.
//

import SwiftUI

struct PlayerHeroHeaderView: View {
    
    let model: HeroHeaderViewModel

    var body: some View {
        ZStack (alignment: .topLeading) {
            VStack {
                HStack {
                    Spacer()
                    nameView
                        .padding(20)
                    
                }
                .frame(alignment: .top)
                
                Spacer()
                    .frame(maxHeight: .infinity)
                HStack {
                    Spacer()
                    iconView
                        .padding(20)
                }
            }
        }

    }
    
    private var nameView: some View {
        Text(model.name.uppercased())
            .font(.scoutHeroName)
            .foregroundStyle(.contrastText)
            .padding(.bottom, 10)
    }
    
    private var iconView: some View {
        Image(systemName: "tennis.racket")
            .font(Font.system(size: 75, weight: .light, design: .default))
            .foregroundStyle(Color.primaryText.opacity(1))
            .shadow(color: Color.vibe.opacity(0.3), radius: 5, x: 10, y: 10)
            
    }
}



#Preview ("Hero") {
    ZStack {
        PlayerHeroHeaderView(model: getRandomHeroHeaderViewModel())
            .background(.secondaryAccent)
    }
}

