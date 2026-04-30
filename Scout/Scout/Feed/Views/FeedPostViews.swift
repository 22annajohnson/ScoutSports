//
//  FeedPostViews.swift
//  Scout
//
//  Created by Codex on 4/29/26.
//

import SwiftUI

struct FeedPostCard: View {
    let post: FeedPreviewPost

    var body: some View {
        switch post.kind {
        case let .upcomingMatchup(teams, featuredPlayers):
            FeedUpcomingMatchupPost(post: post, teams: teams, featuredPlayers: featuredPlayers)
        case let .image(imageURL, statLabel, ctaTitle, relevanceLabel):
            FeedImagePost(post: post, imageURL: imageURL, statLabel: statLabel, ctaTitle: ctaTitle, relevanceLabel: relevanceLabel)
        case let .matchUpdate(winner, loser, score):
            FeedMatchUpdatePost(post: post, winner: winner, loser: loser, score: score)
        case let .achievement(symbol, progress, next):
            FeedAchievementPost(post: post, symbol: symbol, progress: progress, next: next)
        case let .stat(metrics):
            FeedStatPost(post: post, metrics: metrics)
        case let .rivalry(records):
            FeedRivalryPost(post: post, records: records)
        case let .hotspot(pills):
            FeedHotspotPost(post: post, pills: pills)
        }
    }
}

private struct FeedPostShell<Content: View>: View {
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
        .shadow(color: Color.black.opacity(0.28), radius: 26, y: 16)
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
                            .background(Color.white.opacity(0.05), in: Capsule())
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
                    .background(Color.white.opacity(0.04), in: RoundedRectangle(cornerRadius: ScoutLayout.Radius.md, style: .continuous))
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
        .background(Color.white.opacity(0.05), in: Capsule())
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

private struct FeedUpcomingMatchupPost: View {
    @State private var selectedTeamID: FeedPreviewPost.Team.ID?

    let post: FeedPreviewPost
    let teams: [FeedPreviewPost.Team]
    let featuredPlayers: [FeedProfileSnippet]

    var body: some View {
        FeedPostShell(post: post) {
            VStack(spacing: ScoutLayout.Spacing.sm) {
                ForEach(teams) { team in
                    Button {
                        selectedTeamID = team.id
                    } label: {
                        VStack(alignment: .leading, spacing: ScoutLayout.Spacing.sm) {
                            HStack {
                                HStack(spacing: -10) {
                                    ForEach(team.members) { member in
                                        FeedMiniAvatar(profile: member, size: 46)
                                    }
                                }

                                Spacer()

                                Text("\(team.odds)%")
                                    .font(.scoutTitleCompact)
                                    .foregroundStyle(Color.scoutTextPrimary)
                            }

                            Text(team.name)
                                .font(.scoutBodyEmphasis)
                                .foregroundStyle(Color.scoutTextPrimary)

                            GeometryReader { geo in
                                ZStack(alignment: .leading) {
                                    Capsule()
                                        .fill(Color.white.opacity(0.09))

                                    Capsule()
                                        .fill(post.accent.gradient)
                                        .frame(width: geo.size.width * CGFloat(team.odds) / 100)
                                }
                            }
                            .frame(height: 8)
                        }
                        .padding(ScoutLayout.Spacing.md)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(teamBackground(isSelected: selectedTeamID == team.id))
                        .overlay(teamStroke(isSelected: selectedTeamID == team.id))
                    }
                    .buttonStyle(.plain)
                }
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: ScoutLayout.Spacing.sm) {
                    ForEach(featuredPlayers) { player in
                        FeedProfileChip(profile: player)
                    }
                }
                .padding(.top, ScoutLayout.Spacing.xs)
            }
        }
    }

    private func teamBackground(isSelected: Bool) -> some View {
        RoundedRectangle(cornerRadius: ScoutLayout.Radius.lg, style: .continuous)
            .fill(isSelected ? Color.scoutFeedSelectedFill : Color.white.opacity(0.04))
    }

    private func teamStroke(isSelected: Bool) -> some View {
        RoundedRectangle(cornerRadius: ScoutLayout.Radius.lg, style: .continuous)
            .stroke(isSelected ? Color.scoutFeedSelectedStroke : Color.scoutFeedCardStroke, lineWidth: ScoutLayout.Stroke.hairline)
    }
}

private struct FeedImagePost: View {
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
                                Color.black.opacity(0.12),
                                Color.black.opacity(0.26)
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
                            Color.white.opacity(0.02),
                            Color.black.opacity(0.14)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            }
            .background(
                Color.black.opacity(0.14),
                in: RoundedRectangle(cornerRadius: 28, style: .continuous)
            )
            .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        }
    }
}

private struct FeedMatchUpdatePost: View {
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
                        .foregroundStyle(Color.black)
                        .padding(.horizontal, ScoutLayout.Spacing.sm)
                        .padding(.vertical, ScoutLayout.Spacing.sm)
                        .background(Color.white, in: RoundedRectangle(cornerRadius: ScoutLayout.Radius.md, style: .continuous))
                    Spacer()
                    FeedProfileChip(profile: loser)
                }

                Text(score)
                    .font(.system(size: 30, weight: .black, design: .rounded))
                    .foregroundStyle(Color.scoutTextPrimary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, ScoutLayout.Spacing.lg)
                    .background(Color.black.opacity(0.24), in: RoundedRectangle(cornerRadius: ScoutLayout.Radius.lg, style: .continuous))
            }
            .padding(ScoutLayout.Spacing.md)
            .background(
                LinearGradient(
                    colors: [Color.white.opacity(0.08), Color.white.opacity(0.03)],
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

private struct FeedAchievementPost: View {
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
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.scoutBackground)
                }
                .frame(width: 80, height: 80)
                .shadow(color: post.accent.colors.last?.opacity(0.24) ?? .clear, radius: 18, y: 10)

                VStack(alignment: .leading, spacing: ScoutLayout.Spacing.sm) {
                    Text("\(progress) / \(next) courts")
                        .font(.scoutBodyEmphasis)
                        .foregroundStyle(Color(red: 1.0, green: 0.94, blue: 0.78))

                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(Color.white.opacity(0.1))
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
                    colors: [Color(red: 1.0, green: 0.76, blue: 0.24).opacity(0.22), Color(red: 1.0, green: 0.45, blue: 0.18).opacity(0.10)],
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

private struct FeedStatPost: View {
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
                    .background(Color.white.opacity(0.05), in: RoundedRectangle(cornerRadius: ScoutLayout.Radius.md, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: ScoutLayout.Radius.md, style: .continuous)
                            .stroke(Color.scoutFeedCardStroke, lineWidth: ScoutLayout.Stroke.hairline)
                    )
                }
            }
        }
    }
}

private struct FeedRivalryPost: View {
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
                    .background(Color.white.opacity(0.05), in: RoundedRectangle(cornerRadius: ScoutLayout.Radius.lg, style: .continuous))
                }
            }
        }
    }
}

private struct FeedHotspotPost: View {
    let post: FeedPreviewPost
    let pills: [String]

    var body: some View {
        FeedPostShell(post: post) {
            VStack(alignment: .leading, spacing: ScoutLayout.Spacing.md) {
                ZStack {
                    RoundedRectangle(cornerRadius: ScoutLayout.Radius.lg, style: .continuous)
                        .fill(
                            RadialGradient(
                                colors: [Color.scoutAccentStart.opacity(0.32), Color.clear],
                                center: UnitPoint(x: 0.72, y: 0.28),
                                startRadius: 12,
                                endRadius: 120
                            )
                        )
                        .background(
                            Color.black.opacity(0.25),
                            in: RoundedRectangle(cornerRadius: ScoutLayout.Radius.lg, style: .continuous)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: ScoutLayout.Radius.lg, style: .continuous)
                                .stroke(Color.scoutFeedCardStroke, lineWidth: ScoutLayout.Stroke.hairline)
                        )

                    RoundedRectangle(cornerRadius: ScoutLayout.Radius.md, style: .continuous)
                        .fill(Color.white.opacity(0.04))
                        .padding(ScoutLayout.Spacing.md)

                    hotspotDots
                        .padding(.horizontal, 34)
                        .padding(.vertical, 28)
                }
                .frame(height: 148)

                HStack(spacing: ScoutLayout.Spacing.sm) {
                    ForEach(pills, id: \.self) { pill in
                        Text(pill)
                            .font(.scoutMicro)
                            .foregroundStyle(Color.scoutTextPrimary.opacity(0.78))
                            .padding(.horizontal, ScoutLayout.Spacing.md)
                            .padding(.vertical, ScoutLayout.Spacing.sm)
                            .background(Color.white.opacity(0.08), in: Capsule())
                    }
                }
            }
        }
    }

    private var hotspotDots: some View {
        GeometryReader { geo in
            ZStack {
                hotspotDot(color: Color.scoutAccentStart, size: 34)
                    .position(x: geo.size.width * 0.22, y: geo.size.height * 0.46)
                hotspotDot(color: Color(red: 0.78, green: 0.62, blue: 1.0), size: 26)
                    .position(x: geo.size.width * 0.55, y: geo.size.height * 0.22)
                hotspotDot(color: Color.scoutSuccess, size: 40)
                    .position(x: geo.size.width * 0.82, y: geo.size.height * 0.72)
            }
        }
    }

    private func hotspotDot(color: Color, size: CGFloat) -> some View {
        ZStack {
            Circle()
                .fill(color.opacity(0.30))
                .frame(width: size, height: size)
            Circle()
                .fill(color)
                .frame(width: size * 0.46, height: size * 0.46)
        }
    }
}

private struct FeedProfileChip: View {
    let profile: FeedProfileSnippet

    var body: some View {
        HStack(spacing: ScoutLayout.Spacing.sm) {
            FeedMiniAvatar(profile: profile, size: 36)

            VStack(alignment: .leading, spacing: 2) {
                Text(profile.name)
                    .font(.scoutLabel)
                    .foregroundStyle(Color.scoutTextPrimary)
                Text("Scout \(profile.score)")
                    .font(.system(size: 11, weight: .medium, design: .default))
                    .foregroundStyle(Color.scoutTextSecondary)
            }
        }
        .padding(.horizontal, ScoutLayout.Spacing.sm)
        .padding(.vertical, ScoutLayout.Spacing.sm)
        .background(Color.white.opacity(0.06), in: RoundedRectangle(cornerRadius: ScoutLayout.Radius.md, style: .continuous))
    }
}

private struct FeedMiniAvatar: View {
    let profile: FeedProfileSnippet
    let size: CGFloat

    var body: some View {
        FeedRemoteImage(url: profile.avatarURL, cornerRadius: ScoutLayout.Radius.md, height: size)
            .frame(width: size, height: size)
            .overlay(
                RoundedRectangle(cornerRadius: ScoutLayout.Radius.md, style: .continuous)
                    .stroke(Color(red: 0.09, green: 0.09, blue: 0.14), lineWidth: 2)
            )
    }
}

private struct FeedRemoteImage: View {
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
                        .font(.system(size: 26, weight: .bold))
                        .foregroundStyle(Color.white.opacity(0.45))
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

private struct FeedPrimaryCTAButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.scoutCallout)
            .foregroundStyle(Color.black)
            .padding(.horizontal, ScoutLayout.Spacing.md)
            .padding(.vertical, ScoutLayout.Spacing.sm)
            .background(Color.white, in: RoundedRectangle(cornerRadius: ScoutLayout.Radius.md, style: .continuous))
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(ScoutMotion.press, value: configuration.isPressed)
    }
}
