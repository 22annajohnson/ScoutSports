//
//  StarStatView.swift
//  Scout
//
//  Created by Anna on 2/19/26.
//

import SwiftUI

struct StarStatView: View {
    var starCount: Int
    var starType: StatType
    
    init(starCount: Int, starType: StatType) {
        self.starCount = starCount
        self.starType = starType
    }
    var body: some View {
        HStack {
            Text(getStatTypeString(starType).uppercased())
                .font(.scoutSectionSubheader)
                .foregroundStyle(Color.primaryText)
            Spacer()
            starImageView
        }
        .frame(width: 300)
        .padding()
    }
    
    private var starImageView: some View {

        HStack {
            if starCount > 0 {
                ForEach(1...starCount, id: \.self) { _ in
                    Image(systemName: "star.fill")
                    .foregroundStyle(Color.primaryText)                }
            }
            if starCount < 5 {
                ForEach(1...(5-starCount), id: \.self) { _ in
                    Image(systemName: "star")
                    .foregroundStyle(Color.primaryText)                }
            }
        }
    }
}

#Preview ("Vibe") {
    StarStatView(starCount: 3, starType: .vibe)
}

#Preview("Intensity") {
    StarStatView(starCount: 5, starType: .intensity)
}

#Preview("Skill Level") {
    StarStatView(starCount: 0, starType: .skill)
}
