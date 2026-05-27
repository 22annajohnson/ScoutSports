//
//  FeedRivalryPost.swift
//  Scout
//
//  Created by Codex on 4/30/26.
//

import SwiftUI

struct FeedRivalryPost: View {
    let post: FeedPreviewPost
    let records: [FeedPreviewPost.RivalryRecord]

    var body: some View {
        FeedPostShell(post: post) {
            HStack(spacing: ScoutLayout.Spacing.md) {
                ForEach(records) { record in
                    VStack(spacing: ScoutLayout.Spacing.sm) {
                        FeedMiniAvatar(profile: record.player, size: 56)
                        Text(record.record)
                            .font(.scoutTitleCompact)
                            .foregroundStyle(Color.scoutTextPrimary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, ScoutLayout.Spacing.md)
                    .background(Color.scoutGlassFill.opacity(0.8), in: RoundedRectangle(cornerRadius: ScoutLayout.Radius.lg, style: .continuous))
                }
            }
        }
    }
}
