//
//  FeedInnerCircleSection.swift
//  Scout
//
//  Created by Codex on 4/30/26.
//

import SwiftUI
import ScoutDesign

struct FeedInnerCircleSection: View {
    let profiles: [FeedProfileSnippet]
    let posts: [FeedPreviewPost]
    let selectedSport: FeedSportFilter
    let selectedLocation: FeedLocationFilter

    var body: some View {
        GlassCard {
            ScoutSection(
                eyebrow: "Inner Circle",
                title: "Friends moving right now",
                subtitle: "Filtered for \(selectedSport.title) in \(selectedLocation.title)."
            ) {
                VStack(alignment: .leading, spacing: ScoutLayout.Spacing.md) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: ScoutLayout.Spacing.sm) {
                            ForEach(profiles) { profile in
                                FeedProfileChip(profile: profile)
                            }
                        }
                    }

                    VStack(spacing: ScoutLayout.Spacing.sm) {
                        ForEach(posts) { post in
                            FeedInnerCircleActivityRow(post: post)
                        }
                    }
                }
            }
        }
    }
}

private struct FeedInnerCircleActivityRow: View {
    let post: FeedPreviewPost

    var body: some View {
        HStack(alignment: .top, spacing: ScoutLayout.Spacing.md) {
            leadingContent

            VStack(alignment: .leading, spacing: ScoutLayout.Spacing.xs) {
                Text(post.typeTitle)
                    .font(.scoutLabelCaps)
                    .tracking(ScoutLayout.Tracking.micro)
                    .foregroundStyle(Color.scoutTextSecondary)

                Text(post.title)
                    .font(.scoutBodyEmphasis)
                    .foregroundStyle(Color.scoutTextPrimary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.9)

                activityDetail

                if !supportingPills.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: ScoutLayout.Spacing.xs) {
                            ForEach(supportingPills, id: \.self) { pill in
                                Text(pill)
                                    .font(.scoutMicro)
                                    .foregroundStyle(Color.scoutTextPrimary.opacity(0.82))
                                    .padding(.horizontal, ScoutLayout.Spacing.sm)
                                    .padding(.vertical, ScoutLayout.Spacing.xs)
                                    .background(Color.scoutGlassFill.opacity(0.86), in: Capsule())
                            }
                        }
                    }
                }
            }

            Spacer(minLength: 0)
        }
        .padding(ScoutLayout.Spacing.md)
        .background(
            Color.scoutGlassFill.opacity(0.82),
            in: RoundedRectangle(cornerRadius: ScoutLayout.Radius.lg, style: .continuous)
        )
        .overlay(
            RoundedRectangle(cornerRadius: ScoutLayout.Radius.lg, style: .continuous)
                .stroke(Color.scoutFeedCardStroke, lineWidth: ScoutLayout.Stroke.hairline)
        )
    }

    @ViewBuilder
    private var leadingContent: some View {
        switch post.kind {
        case let .upcomingMatchup(teams, _):
            HStack(spacing: -8) {
                ForEach(Array(teams.flatMap(\.members).prefix(3))) { member in
                    FeedMiniAvatar(profile: member, size: 38)
                }
            }
            .padding(.top, 2)

        case let .matchUpdate(winner, loser, _):
            VStack(spacing: -6) {
                FeedMiniAvatar(profile: winner, size: 34)
                FeedMiniAvatar(profile: loser, size: 34)
            }
            .padding(.top, 2)

        case let .rivalry(records):
            HStack(spacing: -8) {
                ForEach(records.prefix(2)) { record in
                    FeedMiniAvatar(profile: record.player, size: 36)
                }
            }
            .padding(.top, 2)

        default:
            Circle()
                .fill(post.accent.gradient)
                .frame(width: 12, height: 12)
                .padding(.top, 8)
        }
    }

    @ViewBuilder
    private var activityDetail: some View {
        switch post.kind {
        case let .upcomingMatchup(teams, _):
            let topOdds = teams.map(\.odds).max() ?? 0
            Text("\(post.eyebrow) • \(topOdds)% edge right now")
                .font(.scoutCaption)
                .foregroundStyle(Color.scoutTextSecondary)

        case let .matchUpdate(winner, loser, score):
            Text("\(winner.name) closed out \(loser.name) • \(score)")
                .font(.scoutCaption)
                .foregroundStyle(Color.scoutTextSecondary)

        case let .achievement(_, progress, next):
            Text("\(progress) courts logged • \(max(next - progress, 0)) until the next badge")
                .font(.scoutCaption)
                .foregroundStyle(Color.scoutTextSecondary)

        case let .stat(metrics):
            Text(metrics.prefix(2).map { "\($0.label) \($0.value)" }.joined(separator: " • "))
                .font(.scoutCaption)
                .foregroundStyle(Color.scoutTextSecondary)

        case let .rivalry(records):
            Text(records.map(\.record).joined(separator: " • "))
                .font(.scoutCaption)
                .foregroundStyle(Color.scoutTextSecondary)

        case let .hotspot(pills):
            Text(pills.prefix(2).joined(separator: " • "))
                .font(.scoutCaption)
                .foregroundStyle(Color.scoutTextSecondary)

        case let .image(_, statLabel, _, relevanceLabel):
            let venue = post.venueName ?? relevanceLabel
            Text("\(venue) • \(statLabel)")
                .font(.scoutCaption)
                .foregroundStyle(Color.scoutTextSecondary)
        }
    }

    private var supportingPills: [String] {
        switch post.kind {
        case let .upcomingMatchup(teams, _):
            return teams.prefix(2).map(\.name)
        case let .matchUpdate(_, _, score):
            return [score, post.tag]
        case let .achievement(_, progress, next):
            return ["\(progress) / \(next)", post.tag]
        case let .stat(metrics):
            return metrics.map { "\($0.value) \($0.label)" }
        case let .rivalry(records):
            return records.map(\.record)
        case let .hotspot(pills):
            return pills
        case let .image(_, statLabel, _, _):
            return [statLabel, post.tag]
        }
    }
}
