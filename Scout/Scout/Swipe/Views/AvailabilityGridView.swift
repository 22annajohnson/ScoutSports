//
//  AvailabilityGridView.swift
//  Scout
//
//  Created by Anna on 2/19/26.
//

import SwiftUI
import ScoutDesign

struct AvailabilityGridDemo: View {
    let accent: Color

    let slots: [AvailabilitySlot] = [
        .init(label: "Mon 6–8", state: .unavailable),
        .init(label: "Tue 6–8", state: .overlap),
        .init(label: "Wed 6–8", state: .unavailable),
        .init(label: "Thu 6–8", state: .overlap),
        .init(label: "Fri 6–8", state: .unavailable),
        .init(label: "Sat AM", state: .overlap),
        .init(label: "Sun AM", state: .overlap),
    ]

    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 86))], spacing: 10) {
            ForEach(slots) { slot in
                Text(slot.label)
                    .font(.scoutPill)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(slot.state == .overlap ? accent : Color.scoutSwipeOverlayTrack.opacity(0.25))
                    .foregroundStyle(slot.state == .overlap ? Color.scoutOnImageTextPrimary : Color.scoutTextPrimary)
                    .clipShape(Capsule())
            }
        }
    }
}

struct AvailabilitySlot: Identifiable {
    enum State {
        case unavailable
        case overlap
    }

    let id: String
    let label: String
    let state: State

    init(label: String, state: State) {
        self.id = label
        self.label = label
        self.state = state
    }
}

#Preview {
    AvailabilityGridDemo(accent: .blue)
}
