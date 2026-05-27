//
//  FeedImagePost.swift
//  Scout
//
//  Created by Codex on 4/30/26.
//

import SwiftUI

struct FeedImagePost: View {
    let post: FeedPreviewPost
    let imageURL: URL?
    let statLabel: String
    let ctaTitle: String?
    let relevanceLabel: String

    var body: some View {
        FeedPostShell(post: post) {
            VStack(spacing: 0) {
                FeedRemoteImage(
                    url: imageURL,
                    cornerRadius: 28,
                    squareBottomCorners: true,
                    height: 224
                )
                .overlay(alignment: .bottom) {
                    LinearGradient(
                        colors: [
                            Color.clear,
                            Color.scoutImageOverlayTop,
                            Color.scoutImageOverlayBottom.opacity(0.76)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 56)
                }

                HStack(alignment: .center, spacing: ScoutLayout.Spacing.md) {
                    VStack(alignment: .leading, spacing: ScoutLayout.Spacing.xxs) {
                        Text(relevanceLabel.uppercased())
                            .font(.system(size: 10, weight: .bold, design: .default))
                            .tracking(2.2)
                            .foregroundStyle(Color.scoutTextSecondary)

                        Text(statLabel)
                            .font(.scoutBodyEmphasis)
                            .foregroundStyle(Color.scoutTextPrimary)
                    }

                    Spacer()

                    Button(ctaTitle ?? "View") {}
                        .buttonStyle(FeedPrimaryCTAButtonStyle())
                }
                .padding(.horizontal, ScoutLayout.Spacing.lg)
                .padding(.vertical, ScoutLayout.Spacing.md)
                .background(
                    LinearGradient(
                        colors: [
                            Color.scoutGlassFill.opacity(0.36),
                            Color.scoutScrimSoft
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            }
            .background(
                Color.scoutScrimSoft,
                in: RoundedRectangle(cornerRadius: 28, style: .continuous)
            )
            .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        }
    }
}
