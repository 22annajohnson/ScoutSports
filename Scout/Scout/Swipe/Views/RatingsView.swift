//
//  RatingsView.swift
//  Scout
//
//  Created by Anna on 2/19/26.
//

import SwiftUI

struct RatingsView: View {
    @State var stats: [StatsViewModel]
    
    var body: some View {
        ZStack {
            Color.secondaryAccent
                .ignoresSafeArea(.all)
            
            VStack (alignment: .leading) {
                Text("Ratings")
                    .font(.scoutScreenTitle)
                    .foregroundStyle(Color.primaryText)
                
                VStack(alignment: .trailing) {
                    ForEach(stats) { stat in
                        StarStatView(starCount: stat.rating, starType: stat.statType)
                        Divider()
                            .frame(height: 2)
                            .overlay(Color.primaryText)
                    }
                }
            }
            .padding()
        }
        
    }
}

#Preview {
    RatingsView(stats: getRandomStats())
}
