//
//  FeedAchievementPost.swift
//  Scout
//
//  Created by Codex on 4/30/26.
//

import SwiftUI
import ScoutDesign

struct FeedAchievementPost: View {
    let post: FeedPreviewPost
    let symbol: String
    let progress: Int
    let next: Int

    var body: some View {
        FeedPostShell(post: post) {
            HStack(spacing: ScoutLayout.Spacing.lg) {
                ZStack {
                    RoundedRectangle(cornerRadius: ScoutLayout.Radius.lg, style: .continuous)
                        .fill(post.accent.gradient)

                    Text(symbol)
                        .font(.scoutNumberM)
                        .foregroundStyle(Color.scoutBackground)
                }
                .frame(width: 80, height: 80)
                .shadow(color: post.accent.colors.last?.opacity(0.24) ?? .clear, radius: 18, y: 10)

                VStack(alignment: .leading, spacing: ScoutLayout.Spacing.sm) {
                    Text("\(progress) / \(next) courts")
                        .font(.scoutBodyEmphasis)
                        .foregroundStyle(Color.scoutAchievementCream)
                        .lineLimit(1)
                        .minimumScaleFactor(0.85)

                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(Color.scoutGlassHighlightSoft.opacity(0.72))
                            Capsule()
                                .fill(post.accent.gradient)
                                .frame(width: geo.size.width * CGFloat(progress) / CGFloat(next))
                        }
                    }
                    .frame(height: 12)

                    Text("Next badge unlocks at \(next).")
                        .font(.scoutLabel)
                        .foregroundStyle(Color.scoutTextSecondary)
                }
            }
            .padding(ScoutLayout.Spacing.md)
            .background(
                LinearGradient(
                    colors: [Color.scoutGradientAmber.opacity(0.22), Color.scoutGradientTangerine.opacity(0.10)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                in: RoundedRectangle(cornerRadius: ScoutLayout.Radius.lg, style: .continuous)
            )
            .overlay(
                RoundedRectangle(cornerRadius: ScoutLayout.Radius.lg, style: .continuous)
                    .stroke(Color.scoutFeedCardStroke, lineWidth: ScoutLayout.Stroke.hairline)
            )
        }
    }
}
