//
//  FeedPostAccessoryViews.swift
//  Scout
//
//  Created by Codex on 4/30/26.
//

import SwiftUI
import ScoutDesign

struct FeedProfileChip: View {
    let profile: FeedProfileSnippet

    var body: some View {
        HStack(spacing: ScoutLayout.Spacing.sm) {
            FeedMiniAvatar(profile: profile, size: 36)

            VStack(alignment: .leading, spacing: 2) {
                Text(profile.name)
                    .font(.scoutLabel)
                    .foregroundStyle(Color.scoutTextPrimary)
                Text("Scout \(profile.score)")
                    .font(.scoutMicro)
                    .foregroundStyle(Color.scoutTextSecondary)
            }
        }
        .padding(.horizontal, ScoutLayout.Spacing.sm)
        .padding(.vertical, ScoutLayout.Spacing.sm)
        .background(Color.scoutGlassFill.opacity(0.9), in: RoundedRectangle(cornerRadius: ScoutLayout.Radius.md, style: .continuous))
    }
}

struct FeedMiniAvatar: View {
    let profile: FeedProfileSnippet
    let size: CGFloat

    var body: some View {
        FeedRemoteImage(url: profile.avatarURL, cornerRadius: ScoutLayout.Radius.md, height: size)
            .frame(width: size, height: size)
            .overlay(
                RoundedRectangle(cornerRadius: ScoutLayout.Radius.md, style: .continuous)
                    .stroke(Color.scoutSwipeOverlaySurface, lineWidth: 2)
            )
    }
}

struct FeedRemoteImage: View {
    let url: URL?
    let cornerRadius: CGFloat
    var squareBottomCorners: Bool = false
    let height: CGFloat

    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case let .success(image):
                image
                    .resizable()
                    .scaledToFill()
            default:
                LinearGradient(
                    colors: [Color.scoutSurfaceElevated, Color.scoutFeedImagePlaceholder],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .overlay {
                    Image(systemName: "photo.fill")
                        .font(.scoutTitleCompact)
                        .foregroundStyle(Color.scoutOnImageTextSoft.opacity(0.55))
                }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: height)
        .clipped()
        .modifier(FeedImageCornerMask(cornerRadius: cornerRadius, squareBottomCorners: squareBottomCorners))
    }
}

private struct FeedImageCornerMask: ViewModifier {
    let cornerRadius: CGFloat
    let squareBottomCorners: Bool

    func body(content: Content) -> some View {
        if squareBottomCorners {
            content.clipShape(
                UnevenRoundedRectangle(
                    cornerRadii: .init(
                        topLeading: cornerRadius,
                        bottomLeading: 0,
                        bottomTrailing: 0,
                        topTrailing: cornerRadius
                    ),
                    style: .continuous
                )
            )
        } else {
            content.clipShape(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            )
        }
    }
}

struct FeedPrimaryCTAButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.scoutCallout)
            .foregroundStyle(Color.scoutBackground)
            .padding(.horizontal, ScoutLayout.Spacing.md)
            .padding(.vertical, ScoutLayout.Spacing.sm)
            .background(Color.scoutOnImageTextPrimary, in: RoundedRectangle(cornerRadius: ScoutLayout.Radius.md, style: .continuous))
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(ScoutMotion.press, value: configuration.isPressed)
    }
}
