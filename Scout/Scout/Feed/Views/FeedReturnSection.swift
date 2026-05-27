//
//  FeedReturnSection.swift
//  Scout
//
//  Created by Codex on 4/30/26.
//

import SwiftUI
import ScoutDesign

struct FeedReturnSection: View {
    let signals: [FeedReturnSignal]

    var body: some View {
        ScoutSection(
            eyebrow: "Return Loop",
            title: "What changed since you checked in",
            subtitle: "Quick reasons to keep the feed moving."
        ) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: ScoutLayout.Spacing.md) {
                    ForEach(signals) { signal in
                        FeedReturnSignalCard(signal: signal)
                    }
                }
            }
        }
    }
}

private struct FeedReturnSignalCard: View {
    let signal: FeedReturnSignal

    var body: some View {
        ScoutSignalCard(
            eyebrow: signal.eyebrow,
            value: signal.value,
            detail: signal.detail
        )
    }
}
