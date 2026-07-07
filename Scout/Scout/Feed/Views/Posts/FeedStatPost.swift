//
//  FeedStatPost.swift
//  Scout
//
//  Created by Codex on 4/30/26.
//

import SwiftUI
import ScoutDesign

struct FeedStatPost: View {
    let post: FeedPreviewPost
    let metrics: [FeedPreviewPost.Metric]

    var body: some View {
        FeedPostShell(post: post) {
            HStack(spacing: ScoutLayout.Spacing.sm) {
                ForEach(metrics) { metric in
                    VStack(spacing: ScoutLayout.Spacing.xs) {
                        Text(metric.value)
                            .font(.scoutNumberM)
                            .foregroundStyle(Color.scoutTextPrimary)
                        Text(metric.label)
                            .font(.scoutMicro)
                            .foregroundStyle(Color.scoutTextSecondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, ScoutLayout.Spacing.md)
                    .background(Color.scoutGlassFill.opacity(0.8), in: RoundedRectangle(cornerRadius: ScoutLayout.Radius.md, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: ScoutLayout.Radius.md, style: .continuous)
                            .stroke(Color.scoutFeedCardStroke, lineWidth: ScoutLayout.Stroke.hairline)
                    )
                }
            }
        }
    }
}
