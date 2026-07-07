//
//  FeedMatchUpdatePost.swift
//  Scout
//
//  Created by Codex on 4/30/26.
//

import SwiftUI
import ScoutDesign

struct FeedMatchUpdatePost: View {
    let post: FeedPreviewPost
    let winner: FeedProfileSnippet
    let loser: FeedProfileSnippet
    let score: String

    var body: some View {
        FeedPostShell(post: post) {
            VStack(spacing: ScoutLayout.Spacing.md) {
                HStack {
                    FeedProfileChip(profile: winner)
                    Spacer()
                    Text("def.")
                        .font(.scoutMicro)
                        .foregroundStyle(Color.scoutBackground)
                        .padding(.horizontal, ScoutLayout.Spacing.sm)
                        .padding(.vertical, ScoutLayout.Spacing.sm)
                        .background(Color.scoutOnImageTextPrimary, in: RoundedRectangle(cornerRadius: ScoutLayout.Radius.md, style: .continuous))
                    Spacer()
                    FeedProfileChip(profile: loser)
                }

                Text(score)
                    .font(.system(size: 30, weight: .black, design: .rounded))
                    .foregroundStyle(Color.scoutTextPrimary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, ScoutLayout.Spacing.lg)
                    .background(Color.scoutScrimStrong.opacity(0.86), in: RoundedRectangle(cornerRadius: ScoutLayout.Radius.lg, style: .continuous))
            }
            .padding(ScoutLayout.Spacing.md)
            .background(
                LinearGradient(
                    colors: [Color.scoutGlassHighlightSoft.opacity(0.58), Color.scoutGlassFill.opacity(0.45)],
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
