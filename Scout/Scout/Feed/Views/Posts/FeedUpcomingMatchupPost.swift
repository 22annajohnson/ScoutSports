//
//  FeedUpcomingMatchupPost.swift
//  Scout
//
//  Created by Codex on 4/30/26.
//

import SwiftUI
import ScoutDesign

struct FeedUpcomingMatchupPost: View {
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
                                        .fill(Color.scoutGlassHighlightSoft.opacity(0.64))

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
            .fill(isSelected ? Color.scoutFeedSelectedFill : Color.scoutGlassFill.opacity(0.68))
    }

    private func teamStroke(isSelected: Bool) -> some View {
        RoundedRectangle(cornerRadius: ScoutLayout.Radius.lg, style: .continuous)
            .stroke(isSelected ? Color.scoutFeedSelectedStroke : Color.scoutFeedCardStroke, lineWidth: ScoutLayout.Stroke.hairline)
    }
}
