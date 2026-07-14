//
//  OwnerProfileScreen.swift
//  Scout
//

import SwiftUI
import ScoutDesign

struct OwnerProfileScreen: View {
    let vm: OwnerProfileViewModel
    var onEditProfile: () -> Void
    var onPreviewPublicProfile: () -> Void

    init(
        vm: OwnerProfileViewModel,
        onEditProfile: @escaping () -> Void = {},
        onPreviewPublicProfile: @escaping () -> Void = {}
    ) {
        self.vm = vm
        self.onEditProfile = onEditProfile
        self.onPreviewPublicProfile = onPreviewPublicProfile
    }

    var body: some View {
        @Bindable var vm = vm

        ScrollView {
            VStack(alignment: .leading, spacing: ScoutLayout.Spacing.xl) {
                ScoutPageHeader(
                    eyebrow: "Profile",
                    title: "Your player card",
                    subtitle: "Keep your profile ready so nearby players know when and how you like to play."
                ) {
                    ScoutIconButton(
                        systemImage: "arrow.clockwise",
                        accessibilityLabel: "Refresh profile"
                    ) {
                        Task { await vm.load(forceRefresh: true) }
                    }
                }

                content(for: vm.state)
            }
            .padding(.horizontal, ScoutLayout.Spacing.lg)
            .padding(.top, ScoutLayout.Spacing.xl)
            .padding(.bottom, ScoutChrome.bottomBarReservedHeight)
        }
        .background(ScoutTheme.screenBackground.ignoresSafeArea())
        .task {
            if case .idle = vm.state {
                await vm.load()
            }
        }
        .refreshable {
            await vm.load(forceRefresh: true)
        }
    }

    @ViewBuilder
    private func content(for state: OwnerProfileViewModel.State) -> some View {
        switch state {
        case .idle, .loading:
            ScoutStateCard(
                state: .loading,
                title: "Loading your profile",
                message: "Scout is getting your latest player details."
            )
        case .incomplete(let message):
            incompleteCard(message: message)
        case .error(let message):
            ScoutStateCard(
                state: .error,
                title: "Profile could not load",
                message: message,
                actionTitle: "Try again"
            ) {
                Task { await vm.load(forceRefresh: true) }
            }
        case .loaded(let profile):
            loadedProfile(profile)
        }
    }

    private func incompleteCard(message: String) -> some View {
        ScoutStateCard(
            state: .empty,
            title: "Finish your profile",
            message: message,
            actionTitle: "Edit Profile",
            action: onEditProfile
        )
    }

    private func loadedProfile(_ profile: OwnerEditableProfile) -> some View {
        VStack(alignment: .leading, spacing: ScoutLayout.Spacing.lg) {
            profileHero(profile)
            actionRow
            readinessSection(profile)
            sportsSection(profile)
            aboutSection(profile)
            availabilitySection(profile)
            visibilitySection(profile)
        }
    }

    private func profileHero(_ profile: OwnerEditableProfile) -> some View {
        GlassCard {
            VStack(alignment: .leading, spacing: ScoutLayout.Spacing.lg) {
                HStack(alignment: .center, spacing: ScoutLayout.Spacing.md) {
                    ScoutAvatar(initials: profile.initials, size: 72)

                    VStack(alignment: .leading, spacing: ScoutLayout.Spacing.xs) {
                        Text(profile.displayName)
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

                if let bio = profile.bio, !bio.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    Text(bio)
                        .font(.scoutBody)
                        .foregroundStyle(Color.scoutTextSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                HStack(spacing: ScoutLayout.Spacing.sm) {
                    ScoutStatPill(
                        title: "Status",
                        value: profile.accountStatus.displayTitle,
                        systemImage: "checkmark.seal.fill"
                    )

                    ScoutStatPill(
                        title: "Ready",
                        value: profile.completionState.displayTitle,
                        systemImage: "sparkles"
                    )
                }
                .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private var actionRow: some View {
        HStack(spacing: ScoutLayout.Spacing.md) {
            ScoutButton(action: onEditProfile) {
                Label("Edit Profile", systemImage: "pencil")
                    .frame(maxWidth: .infinity)
            }

            ScoutButton(variant: .secondary, action: onPreviewPublicProfile) {
                Label("Public Preview", systemImage: "person.crop.circle")
                    .frame(maxWidth: .infinity)
            }
        }
    }

    private func readinessSection(_ profile: OwnerEditableProfile) -> some View {
        ScoutSection(
            eyebrow: "Readiness",
            title: profile.completionState.displayTitle,
            subtitle: profile.completionState.guidance
        ) {
            GlassCard {
                VStack(alignment: .leading, spacing: ScoutLayout.Spacing.md) {
                    readinessRow(
                        title: "Identity",
                        value: profile.displayName.isEmpty ? "Needs display name" : "Looks good",
                        systemImage: "person.text.rectangle"
                    )

                    readinessRow(
                        title: "Sports",
                        value: profile.sports.isEmpty ? "Add at least one sport" : "\(profile.sports.count) listed",
                        systemImage: "figure.pickleball"
                    )

                    readinessRow(
                        title: "Availability",
                        value: profile.availabilitySummary,
                        systemImage: "calendar"
                    )
                }
            }
        }
    }

    private func readinessRow(title: String, value: String, systemImage: String) -> some View {
        HStack(spacing: ScoutLayout.Spacing.md) {
            Image(systemName: systemImage)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Color.scoutAccentStart)
                .frame(width: 28)

            VStack(alignment: .leading, spacing: ScoutLayout.Spacing.xxs) {
                Text(title)
                    .font(.scoutCaption)
                    .foregroundStyle(Color.scoutTextSecondary)

                Text(value)
                    .font(.scoutBody)
                    .foregroundStyle(Color.scoutTextPrimary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 0)
        }
    }

    private func sportsSection(_ profile: OwnerEditableProfile) -> some View {
        ScoutSection(
            eyebrow: "Sports",
            title: "How you play",
            subtitle: profile.primarySport.map { "Primary sport: \($0.displayTitle)" }
        ) {
            FlowLayout(spacing: ScoutLayout.Spacing.sm) {
                ForEach(profile.sports, id: \.self) { sport in
                    ScoutBadge(title: sportBadgeTitle(sport, profile: profile))
                }
            }
        }
    }

    private func aboutSection(_ profile: OwnerEditableProfile) -> some View {
        ScoutSection(
            eyebrow: "About",
            title: "Player details"
        ) {
            GlassCard {
                VStack(alignment: .leading, spacing: ScoutLayout.Spacing.md) {
                    detailRow(title: "Home area", value: profile.homeArea ?? "Not set")
                    detailRow(title: "Travel radius", value: profile.travelRadiusSummary)
                    detailRow(title: "Play intent", value: profile.playIntent?.displayTitle ?? "Not set")
                    detailRow(title: "Play style", value: profile.preferredPlayStyle?.displayTitle ?? "Not set")
                }
            }
        }
    }

    private func availabilitySection(_ profile: OwnerEditableProfile) -> some View {
        ScoutSection(
            eyebrow: "Availability",
            title: "When you can play"
        ) {
            GlassCard {
                VStack(alignment: .leading, spacing: ScoutLayout.Spacing.md) {
                    detailRow(title: "Preferred days", value: profile.preferredDaysSummary)
                    detailRow(title: "Time windows", value: profile.preferredTimeWindowsSummary)
                }
            }
        }
    }

    private func visibilitySection(_ profile: OwnerEditableProfile) -> some View {
        ScoutSection(
            eyebrow: "Privacy",
            title: "Profile visibility"
        ) {
            GlassCard {
                VStack(alignment: .leading, spacing: ScoutLayout.Spacing.md) {
                    detailRow(title: "Visibility", value: profile.profileVisibility.displayTitle)
                    detailRow(title: "Discoverable", value: profile.isDiscoverable ? "Yes" : "No")
                    detailRow(title: "Location", value: profile.locationPrecision.displayTitle)
                }
            }
        }
    }

    private func detailRow(title: String, value: String) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: ScoutLayout.Spacing.md) {
            Text(title)
                .font(.scoutCaption)
                .foregroundStyle(Color.scoutTextSecondary)
                .frame(width: 116, alignment: .leading)

            Text(value)
                .font(.scoutBody)
                .foregroundStyle(Color.scoutTextPrimary)
                .fixedSize(horizontal: false, vertical: true)

            Spacer(minLength: 0)
        }
    }

    private func sportBadgeTitle(_ sport: String, profile: OwnerEditableProfile) -> String {
        let base = sport.displayTitle
        let skill = profile.skillLevelBySport[sport].map { "Skill \($0)" }
        let primary = sport == profile.primarySport ? "Primary" : nil
        return [base, skill, primary].compactMap { $0 }.joined(separator: " - ")
    }
}

private struct FlowLayout: Layout {
    var spacing: CGFloat

    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) -> CGSize {
        let rows = rows(for: subviews, maxWidth: proposal.width ?? 0)
        return CGSize(width: proposal.width ?? rows.width, height: rows.height)
    }

    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) {
        var origin = bounds.origin
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if origin.x > bounds.minX, origin.x + size.width > bounds.maxX {
                origin.x = bounds.minX
                origin.y += rowHeight + spacing
                rowHeight = 0
            }

            subview.place(at: origin, proposal: ProposedViewSize(size))
            origin.x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
    }

    private func rows(for subviews: Subviews, maxWidth: CGFloat) -> CGSize {
        var width: CGFloat = 0
        var height: CGFloat = 0
        var rowWidth: CGFloat = 0
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if rowWidth > 0, rowWidth + spacing + size.width > maxWidth {
                width = max(width, rowWidth)
                height += rowHeight + spacing
                rowWidth = 0
                rowHeight = 0
            }

            rowWidth += rowWidth > 0 ? spacing + size.width : size.width
            rowHeight = max(rowHeight, size.height)
        }

        width = max(width, rowWidth)
        height += rowHeight
        return CGSize(width: width, height: height)
    }
}

private extension OwnerEditableProfile {
    var initials: String {
        let parts = displayName.split(separator: " ")
        let letters = parts.prefix(2).compactMap(\.first)
        return letters.isEmpty ? "SC" : String(letters).uppercased()
    }

    var availabilitySummary: String {
        if preferredDays.isEmpty, preferredTimeWindows.isEmpty {
            return "Add availability"
        }

        return "\(preferredDays.count) days, \(preferredTimeWindows.count) windows"
    }

    var preferredDaysSummary: String {
        guard !preferredDays.isEmpty else { return "Not set" }
        return preferredDays.map(\.displayTitle).joined(separator: ", ")
    }

    var preferredTimeWindowsSummary: String {
        guard !preferredTimeWindows.isEmpty else { return "Not set" }
        return preferredTimeWindows.map(\.displayTitle).joined(separator: ", ")
    }

    var travelRadiusSummary: String {
        guard let travelRadiusMiles else { return "Not set" }
        return "\(travelRadiusMiles) miles"
    }
}

private extension ProfileCompletionState {
    var displayTitle: String {
        switch self {
        case .accountCreated:
            return "Setup needed"
        case .basicIdentity:
            return "Identity added"
        case .discoveryReady:
            return "Discovery ready"
        case .eventReady:
            return "Event ready"
        case .fullyComplete:
            return "Complete"
        }
    }

    var guidance: String {
        switch self {
        case .accountCreated:
            return "Add profile basics before players can understand your fit."
        case .basicIdentity:
            return "Add sports and availability to make your profile match-ready."
        case .discoveryReady:
            return "Your profile has enough detail for player discovery."
        case .eventReady:
            return "Your profile is ready for events and player discovery."
        case .fullyComplete:
            return "Your profile has the key details Scout needs."
        }
    }
}

private extension ProfileAccountStatus {
    var displayTitle: String {
        switch self {
        case .active:
            return "Active"
        case .restricted:
            return "Restricted"
        case .disabled:
            return "Disabled"
        case .deleted:
            return "Deleted"
        }
    }
}

private extension ProfilePlayIntent {
    var displayTitle: String {
        switch self {
        case .casual:
            return "Casual"
        case .competitive:
            return "Competitive"
        case .flexible:
            return "Flexible"
        }
    }
}

private extension PreferredProfilePlayStyle {
    var displayTitle: String {
        switch self {
        case .singles:
            return "Singles"
        case .doubles:
            return "Doubles"
        case .mixed:
            return "Mixed"
        case .open:
            return "Open"
        }
    }
}

private extension ProfileVisibility {
    var displayTitle: String {
        switch self {
        case .publicProfile:
            return "Public"
        case .authenticated:
            return "Signed-in players"
        case .privateProfile:
            return "Private"
        }
    }
}

private extension ProfileLocationPrecision {
    var displayTitle: String {
        switch self {
        case .hidden:
            return "Hidden"
        case .coarse:
            return "Approximate"
        }
    }
}

private extension ProfileWeekday {
    var displayTitle: String {
        rawValue.prefix(1).uppercased() + rawValue.dropFirst()
    }
}

private extension ProfileTimeWindow {
    var displayTitle: String {
        rawValue.prefix(1).uppercased() + rawValue.dropFirst()
    }
}

private extension String {
    var displayTitle: String {
        replacingOccurrences(of: "_", with: " ")
            .split(separator: " ")
            .map { $0.prefix(1).uppercased() + $0.dropFirst() }
            .joined(separator: " ")
    }
}

#Preview("Loaded") {
    OwnerProfileScreen(vm: OwnerProfileViewModel(repository: PreviewOwnerProfileRepository(state: .loaded)))
}

#Preview("Incomplete") {
    OwnerProfileScreen(vm: OwnerProfileViewModel(repository: PreviewOwnerProfileRepository(state: .incomplete)))
}

private final class PreviewOwnerProfileRepository: OwnerEditableProfileProviding {
    enum State {
        case loaded
        case incomplete
    }

    private let state: State

    init(state: State) {
        self.state = state
    }

    func currentEditableProfile(forceRefresh: Bool) async throws -> OwnerEditableProfile {
        switch state {
        case .loaded:
            return OwnerEditableProfile.preview(completionState: .discoveryReady)
        case .incomplete:
            return OwnerEditableProfile.preview(displayName: "", completionState: .accountCreated)
        }
    }

    func updateIdentity(_ command: ProfileIdentityUpdateCommand) async throws -> OwnerEditableProfile {
        OwnerEditableProfile.preview(completionState: .discoveryReady)
    }

    func updateSports(_ command: ProfileSportsUpdateCommand) async throws -> OwnerEditableProfile {
        OwnerEditableProfile.preview(completionState: .discoveryReady)
    }

    func updateAvailability(_ command: ProfileAvailabilityUpdateCommand) async throws -> OwnerEditableProfile {
        OwnerEditableProfile.preview(completionState: .discoveryReady)
    }

    func updatePrivacy(_ command: ProfilePrivacyUpdateCommand) async throws -> OwnerEditableProfile {
        OwnerEditableProfile.preview(completionState: .discoveryReady)
    }
}

private extension OwnerEditableProfile {
    static func preview(
        displayName: String = "Maya Johnson",
        completionState: ProfileCompletionState
    ) -> OwnerEditableProfile {
        OwnerEditableProfile(
            id: "preview-profile",
            displayName: displayName,
            username: "maya_rallies",
            profilePhotoPath: nil,
            actionPhotoPath: nil,
            bio: "Doubles player looking for early morning games and steady rallies.",
            sports: ["pickleball", "tennis"],
            primarySport: "pickleball",
            skillLevelBySport: ["pickleball": 4, "tennis": 3],
            preferredDays: [.monday, .wednesday, .saturday],
            preferredTimeWindows: [.morning, .flexible],
            playIntent: .competitive,
            homeArea: "East Austin",
            travelRadiusMiles: 12,
            preferredPlayStyle: .doubles,
            profileVisibility: .publicProfile,
            isDiscoverable: true,
            locationPrecision: .coarse,
            completionState: completionState,
            accountStatus: .active,
            createdAt: Date(timeIntervalSince1970: 0),
            lastActiveAt: nil
        )
    }
}
