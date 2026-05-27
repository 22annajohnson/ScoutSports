//
//  FeedPostShell.swift
//  Scout
//
//  Created by Codex on 4/30/26.
//

import SwiftUI

struct FeedPostShell<Content: View>: View {
    let post: FeedPreviewPost
    let content: Content

    init(post: FeedPreviewPost, @ViewBuilder content: () -> Content) {
        self.post = post
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: ScoutLayout.Spacing.md) {
            header
            content
            footer
        }
        .padding(ScoutLayout.Spacing.lg)
        .background(cardBackground)
        .overlay(cardStroke)
        .clipShape(RoundedRectangle(cornerRadius: ScoutLayout.Radius.xl, style: .continuous))
        .shadow(color: Color.scoutShadowStrong, radius: 26, y: 16)
    }

    private var header: some View {
        HStack(alignment: .top, spacing: ScoutLayout.Spacing.md) {
            VStack(alignment: .leading, spacing: ScoutLayout.Spacing.xs) {
                HStack(spacing: ScoutLayout.Spacing.xs) {
                    Text(post.typeTitle)
                        .font(.scoutMicro)
                        .foregroundStyle(Color.scoutTextOnAccent)
                        .padding(.horizontal, ScoutLayout.Spacing.md)
                        .padding(.vertical, ScoutLayout.Spacing.xs)
                        .background(post.accent.gradient, in: Capsule())

                    if post.isSponsored {
                        Text("AD")
                            .font(.scoutMicro)
                            .foregroundStyle(Color.scoutTextSecondary)
                            .padding(.horizontal, ScoutLayout.Spacing.sm)
                            .padding(.vertical, ScoutLayout.Spacing.xs)
                            .background(Color.scoutGlassFill.opacity(0.8), in: Capsule())
                    }
                }

                Text(post.eyebrow)
                    .font(.scoutLabel)
                    .foregroundStyle(Color.scoutTextSecondary.opacity(0.8))

                Text(post.title)
                    .font(.system(size: 28, weight: .black, design: .rounded))
                    .foregroundStyle(Color.scoutTextPrimary)
                    .lineSpacing(1)

                Text(post.description)
                    .font(.scoutBody)
                    .foregroundStyle(Color.scoutTextSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Button(action: {}) {
                Text("•••")
                    .font(.scoutCallout)
                    .foregroundStyle(Color.scoutTextPrimary.opacity(0.72))
                    .frame(width: 44, height: 44)
                    .background(Color.scoutGlassFill.opacity(0.68), in: RoundedRectangle(cornerRadius: ScoutLayout.Radius.md, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: ScoutLayout.Radius.md, style: .continuous)
                            .stroke(Color.scoutFeedCardStroke, lineWidth: ScoutLayout.Stroke.hairline)
                    )
            }
            .buttonStyle(.plain)
        }
    }

    private var footer: some View {
        HStack {
            HStack(spacing: ScoutLayout.Spacing.xs) {
                reactionPill(title: "24", systemImage: "flame.fill")
                reactionPill(title: "8", systemImage: "hands.clap.fill")
            }

            Spacer()

            Text(post.tag)
                .font(.scoutMicro)
                .foregroundStyle(Color.scoutTextSecondary)
        }
        .padding(.top, ScoutLayout.Spacing.sm)
        .overlay(alignment: .top) {
            Rectangle()
                .fill(Color.scoutFeedCardStroke)
                .frame(height: 1)
        }
    }

    private func reactionPill(title: String, systemImage: String) -> some View {
        HStack(spacing: ScoutLayout.Spacing.xs) {
            Image(systemName: systemImage)
            Text(title)
        }
        .font(.scoutMicro)
        .foregroundStyle(Color.scoutTextPrimary)
        .padding(.horizontal, ScoutLayout.Spacing.sm)
        .padding(.vertical, ScoutLayout.Spacing.sm)
        .background(Color.scoutGlassFill.opacity(0.8), in: Capsule())
    }

    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: ScoutLayout.Radius.xl, style: .continuous)
            .fill(Color.scoutFeedCardFill)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: ScoutLayout.Radius.xl, style: .continuous))
            .overlay(alignment: .top) {
                Rectangle()
                    .fill(post.accent.gradient)
                    .frame(height: 4)
            }
    }

    private var cardStroke: some View {
        RoundedRectangle(cornerRadius: ScoutLayout.Radius.xl, style: .continuous)
            .stroke(Color.scoutFeedCardStroke, lineWidth: ScoutLayout.Stroke.hairline)
    }
}
