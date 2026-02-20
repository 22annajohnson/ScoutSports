//
//  PlayerSwipeScrollView.swift
//  Scout
//
//  Created by Anna on 2/19/26.
//

import SwiftUI

struct PlayerSwipeScrollView: View {
    let model: CardViewModel

    // Use your chosen palette token here
    private let accent = Color(.secondaryAccent)

    var body: some View {
        GeometryReader { geo in
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    ZStack {
                        PlayerBackgroundView(imageURL: model.heroImageURL, color: accent)

                        PlayerHeroHeaderView(
                            model: HeroHeaderViewModel(
                                imageURL: model.heroImageURL,
                                name: model.name,
                                score: 69,
                                accent: accent
                            )
                        )
                        .padding(.top, 50)
                    }
                    .frame(width: geo.size.width, height: geo.size.height - 100)

                    arrows
                        .padding(20)
                    
                    RatingsView(stats: model.stats)
                }
            }
            .ignoresSafeArea(.all)
            .background(accent.ignoresSafeArea())
            .onAppear {
                UIScrollView.appearance().bounces = false
            }
            .onDisappear {
                UIScrollView.appearance().bounces = true
            }
        }
    }
    
    private var arrows: some View {
        HStack(spacing: 0) {
            ForEach(1...3, id: \.self) { i in
                Image(systemName: "chevron.left")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.primaryText.opacity(1.0/Double(i)))
                    .padding(.top, 10)
            }
            
            
            overallScoreView
            
            ForEach(1...3, id: \.self) { i in
                Image(systemName: "chevron.right")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.primaryText.opacity(1.0/Double(3-i)))
                    .padding(.top, 10)
            }
            
        }
    }
    
    private var overallScoreView: some View {
        VStack {
            Text("Your Matchup Rating:")
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text("\(100)")
                    .font(.scoutScore)
                    .foregroundStyle(.primaryText)
            }
            .padding(.horizontal, 20)
        }
    }
}





#Preview {
    PlayerSwipeScrollView(model: randomMockCardViewModel())
}



//                    VStack(alignment: .leading, spacing: 18) {
//                        Text("Rankings").font(.scoutSectionHeader)
//
//                        Text("Win Rate: 72%")
//                            .font(.scoutBody)
//
//                        Text("Bio: “Here for good games and good vibes.”")
//                            .font(.scoutBody)
//
//                        Text("Availability")
//                            .font(.scoutSectionHeader)
//
//                        // Placeholder grid
//                        AvailabilityGridDemo(accent: accent)
//
//                        Text("Home Court")
//                            .font(.scoutSectionHeader)
//
//                        Text("Deering Oaks Courts • 3.2 mi")
//                            .font(.scoutBody)
//                            .foregroundStyle(.secondary)
//                        }
//                        .padding(20)
//                        .background(.ultraThinMaterial) // or Color(.systemBackground)
//                        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
//                        .padding(.top, -36) // pulls content up into the triangle a bit (nice continuity)
//                        .padding(.horizontal, 16)
//                        .padding(.bottom, 24)
