//
//  PublicProfileScreen.swift
//  Scout
//

import SwiftUI
import ScoutDesign

struct PublicProfileScreen: View {
    let vm: PublicProfileViewModel

    init(vm: PublicProfileViewModel) {
        self.vm = vm
    }

    var body: some View {
        @Bindable var vm = vm

        ScrollView {
            VStack(alignment: .leading, spacing: ScoutLayout.Spacing.xl) {
                ScoutPageHeader(
                    eyebrow: "Public Profile",
                    title: "Player preview",
                    subtitle: "This view uses only the public profile contract."
                )

                content(for: vm.state)
            }
            .padding(.horizontal, ScoutLayout.Spacing.lg)
            .padding(.top, ScoutLayout.Spacing.xl)
            .padding(.bottom, ScoutLayout.Spacing.xxl)
        }
        .background(ScoutTheme.screenBackground.ignoresSafeArea())
        .task {
            if case .idle = vm.state {
                await vm.load()
            }
        }
        .refreshable {
            await vm.load()
        }
    }

    @ViewBuilder
    private func content(for state: PublicProfileViewModel.State) -> some View {
        switch state {
        case .idle, .loading:
            ScoutStateCard(
                state: .loading,
                title: "Loading profile",
                message: "Scout is checking whether this profile is available to view."
            )
        case .incomplete(let message):
            ScoutStateCard(
                state: .empty,
                title: "Profile unavailable",
                message: message
            )
        case .error(let message):
            ScoutStateCard(
                state: .error,
                title: "Profile could not load",
                message: message,
                actionTitle: "Try again"
            ) {
                Task { await vm.load() }
            }
        case .loaded(let profile):
            loadedProfile(profile)
        }
    }

    private func loadedProfile(_ profile: PublicProfile) -> some View {
        VStack(alignment: .leading, spacing: ScoutLayout.Spacing.lg) {
            hero(profile)
            sportsSection(profile)
            aboutSection(profile)
        }
    }

    private func hero(_ profile: PublicProfile) -> some View {
        GlassCard {
            HStack(alignment: .center, spacing: ScoutLayout.Spacing.md) {
                ScoutAvatar(initials: profile.initials, size: 72)

                VStack(alignment: .leading, spacing: ScoutLayout.Spacing.xs) {
                    Text(profile.displayName ?? "Scout Player")
                        .font(.scoutTitle)
                        .foregroundStyle(Color.scoutTextPrimary)
                        .lineLimit(2)
                        .minimumScaleFactor(0.82)

                    if let username = profile.username, !username.isEmpty {
                        Text("@\(username)")
                            .font(.scoutBody)
                            .foregroundStyle(Color.scoutTextSecondary)
                    }
                }

                Spacer(minLength: 0)
            }
        }
    }

    private func sportsSection(_ profile: PublicProfile) -> some View {
        ScoutSection(
            eyebrow: "Sports",
            title: "How they play"
        ) {
            if profile.sports.isEmpty {
                ScoutStateCard(
                    state: .empty,
                    title: "No public sports yet",
                    message: "This player has not shared sports on their public profile."
                )
            } else {
                VStack(alignment: .leading, spacing: ScoutLayout.Spacing.sm) {
                    ForEach(profile.sports, id: \.sportSlug) { sport in
                        GlassCard {
                            HStack(spacing: ScoutLayout.Spacing.md) {
                                Image(systemName: sport.isPrimary ? "star.fill" : "figure.pickleball")
                                    .foregroundStyle(Color.scoutAccentStart)
                                    .frame(width: 28)

                                VStack(alignment: .leading, spacing: ScoutLayout.Spacing.xxs) {
                                    Text(sport.sportSlug.displayTitle)
                                        .font(.scoutBody)
                                        .foregroundStyle(Color.scoutTextPrimary)

                                    if let skill = sport.skillLevel {
                                        Text(skill.displayTitle)
                                            .font(.scoutCaption)
                                            .foregroundStyle(Color.scoutTextSecondary)
                                    }
                                }

                                Spacer(minLength: 0)

                                if sport.isPrimary {
                                    ScoutBadge(title: "Primary")
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    private func aboutSection(_ profile: PublicProfile) -> some View {
        ScoutSection(
            eyebrow: "About",
            title: "Public bio"
        ) {
            GlassCard {
                Text(profile.bio?.nonEmpty ?? "This player has not added a public bio yet.")
                    .font(.scoutBody)
                    .foregroundStyle(Color.scoutTextSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

private extension PublicProfile {
    var initials: String {
        let display = displayName ?? username ?? "Scout Player"
        let parts = display.split(separator: " ")
        let letters = parts.prefix(2).compactMap(\.first)
        return letters.isEmpty ? "SC" : String(letters).uppercased()
    }
}

private extension String {
    var nonEmpty: String? {
        let trimmed = trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }

    var displayTitle: String {
        replacingOccurrences(of: "_", with: " ")
            .split(separator: " ")
            .map { $0.prefix(1).uppercased() + $0.dropFirst() }
            .joined(separator: " ")
    }
}
