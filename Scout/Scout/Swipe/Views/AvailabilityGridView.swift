//
//  AvailabilityGridView.swift
//  Scout
//
//  Created by Anna on 2/19/26.
//

import SwiftUI

struct AvailabilityGridDemo: View {
    let accent: Color

    let slots: [(String, Bool)] = [
        ("Mon 6–8", false),
        ("Tue 6–8", true),
        ("Wed 6–8", false),
        ("Thu 6–8", true),
        ("Fri 6–8", false),
        ("Sat AM", true),
        ("Sun AM", true),
    ]

    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 86))], spacing: 10) {
            ForEach(slots, id: \.0) { label, overlap in
                Text(label)
                    .font(.scoutPill)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(overlap ? accent : Color.gray.opacity(0.25))
                    .foregroundStyle(overlap ? .white : .primary)
                    .clipShape(Capsule())
            }
        }
    }
}

#Preview {
    AvailabilityGridDemo(accent: .blue)
}

