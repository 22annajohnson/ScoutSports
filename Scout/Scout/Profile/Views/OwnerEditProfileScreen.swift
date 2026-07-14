//
//  OwnerEditProfileScreen.swift
//  Scout
//

import SwiftUI
import ScoutDesign

struct OwnerEditProfileScreen: View {
    @Environment(\.dismiss) private var dismiss

    @Bindable var vm: OwnerEditProfileViewModel
    var onSaved: () -> Void

    init(vm: OwnerEditProfileViewModel, onSaved: @escaping () -> Void = {}) {
        self.vm = vm
        self.onSaved = onSaved
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: ScoutLayout.Spacing.lg) {
                    ScoutPageHeader(
                        eyebrow: "Edit Profile",
                        title: "Update your player details",
                        subtitle: "These fields shape your owner profile and the safe public summary other players can see."
                    )

                    if let message = vm.validationMessage {
                        ScoutStateCard(
                            state: .error,
                            title: "Check your profile",
                            message: message
                        )
                    }

                    if case .error(let message) = vm.saveState {
                        ScoutStateCard(
                            state: .error,
                            title: "Save failed",
                            message: message
                        )
                    }

                    identitySection
                    sportsSection
                    availabilitySection
                    privacySection
                }
                .padding(.horizontal, ScoutLayout.Spacing.lg)
                .padding(.top, ScoutLayout.Spacing.xl)
                .padding(.bottom, ScoutLayout.Spacing.xxl)
            }
            .background(ScoutTheme.screenBackground.ignoresSafeArea())
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button(vm.isSaving ? "Saving" : "Save") {
                        Task { await save() }
                    }
                    .disabled(vm.isSaving)
                }
            }
            .onChange(of: vm.saveState) { _, state in
                if case .saved = state {
                    onSaved()
                    dismiss()
                }
            }
        }
    }

    private var identitySection: some View {
        ScoutSection(eyebrow: "Identity", title: "How players recognize you") {
            GlassCard {
                VStack(alignment: .leading, spacing: ScoutLayout.Spacing.md) {
                    TextField("Display name", text: $vm.form.displayName)
                        .textInputAutocapitalization(.words)
                        .textFieldStyle(.roundedBorder)

                    TextField("Username", text: $vm.form.username)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .textFieldStyle(.roundedBorder)

                    TextField("Bio", text: $vm.form.bio, axis: .vertical)
                        .lineLimit(3...6)
                        .textFieldStyle(.roundedBorder)
                }
            }
        }
    }

    private var sportsSection: some View {
        ScoutSection(
            eyebrow: "Sports",
            title: "What you play",
            subtitle: "Use comma-separated sport slugs for now, such as pickleball, tennis."
        ) {
            GlassCard {
                VStack(alignment: .leading, spacing: ScoutLayout.Spacing.md) {
                    TextField("Sports", text: $vm.form.sportsText)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .textFieldStyle(.roundedBorder)

                    TextField("Primary sport", text: $vm.form.primarySport)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .textFieldStyle(.roundedBorder)

                    Stepper(value: $vm.form.primarySkillLevel, in: 1...5) {
                        Text("Primary skill: \(vm.form.primarySkillLevel)")
                            .font(.scoutBody)
                            .foregroundStyle(Color.scoutTextPrimary)
                    }
                }
            }
        }
    }

    private var availabilitySection: some View {
        ScoutSection(eyebrow: "Availability", title: "When and where you play") {
            GlassCard {
                VStack(alignment: .leading, spacing: ScoutLayout.Spacing.md) {
                    TextField("Home area", text: $vm.form.homeArea)
                        .textInputAutocapitalization(.words)
                        .textFieldStyle(.roundedBorder)

                    TextField("Travel radius miles", text: $vm.form.travelRadiusText)
                        .keyboardType(.numberPad)
                        .textFieldStyle(.roundedBorder)

                    picker("Play intent", selection: $vm.form.playIntent) {
                        Text("Not set").tag(nil as ProfilePlayIntent?)
                        ForEach(ProfilePlayIntent.allCases, id: \.self) { intent in
                            Text(intent.editDisplayTitle).tag(Optional(intent))
                        }
                    }

                    picker("Play style", selection: $vm.form.preferredPlayStyle) {
                        Text("Not set").tag(nil as PreferredProfilePlayStyle?)
                        ForEach(PreferredProfilePlayStyle.allCases, id: \.self) { style in
                            Text(style.editDisplayTitle).tag(Optional(style))
                        }
                    }

                    toggleGrid(title: "Preferred days") {
                        ForEach(ProfileWeekday.allCases, id: \.self) { day in
                            Toggle(day.editDisplayTitle, isOn: dayBinding(day))
                        }
                    }

                    toggleGrid(title: "Time windows") {
                        ForEach(ProfileTimeWindow.allCases, id: \.self) { window in
                            Toggle(window.editDisplayTitle, isOn: timeWindowBinding(window))
                        }
                    }
                }
            }
        }
    }

    private var privacySection: some View {
        ScoutSection(eyebrow: "Privacy", title: "Profile visibility") {
            GlassCard {
                VStack(alignment: .leading, spacing: ScoutLayout.Spacing.md) {
                    picker("Visibility", selection: $vm.form.profileVisibility) {
                        ForEach(ProfileVisibility.allCases, id: \.self) { visibility in
                            Text(visibility.editDisplayTitle).tag(visibility)
                        }
                    }

                    Toggle("Discoverable", isOn: $vm.form.isDiscoverable)

                    picker("Location precision", selection: $vm.form.locationPrecision) {
                        ForEach(ProfileLocationPrecision.allCases, id: \.self) { precision in
                            Text(precision.editDisplayTitle).tag(precision)
                        }
                    }
                }
            }
        }
    }

    private func save() async {
        await vm.save()
    }

    private func dayBinding(_ day: ProfileWeekday) -> Binding<Bool> {
        Binding {
            vm.form.preferredDays.contains(day)
        } set: { _ in
            vm.toggleDay(day)
        }
    }

    private func timeWindowBinding(_ window: ProfileTimeWindow) -> Binding<Bool> {
        Binding {
            vm.form.preferredTimeWindows.contains(window)
        } set: { _ in
            vm.toggleTimeWindow(window)
        }
    }

    private func picker<Selection: Hashable, Content: View>(
        _ title: String,
        selection: Binding<Selection>,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: ScoutLayout.Spacing.xs) {
            Text(title)
                .font(.scoutCaption)
                .foregroundStyle(Color.scoutTextSecondary)

            Picker(title, selection: selection, content: content)
                .pickerStyle(.menu)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private func toggleGrid<Content: View>(
        title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: ScoutLayout.Spacing.xs) {
            Text(title)
                .font(.scoutCaption)
                .foregroundStyle(Color.scoutTextSecondary)

            VStack(alignment: .leading, spacing: ScoutLayout.Spacing.xs, content: content)
                .toggleStyle(.switch)
        }
    }
}

private extension ProfilePlayIntent {
    var editDisplayTitle: String {
        rawValue.prefix(1).uppercased() + rawValue.dropFirst()
    }
}

private extension PreferredProfilePlayStyle {
    var editDisplayTitle: String {
        rawValue.prefix(1).uppercased() + rawValue.dropFirst()
    }
}

private extension ProfileVisibility {
    var editDisplayTitle: String {
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
    var editDisplayTitle: String {
        switch self {
        case .hidden:
            return "Hidden"
        case .coarse:
            return "Approximate"
        }
    }
}

private extension ProfileWeekday {
    var editDisplayTitle: String {
        rawValue.prefix(1).uppercased() + rawValue.dropFirst()
    }
}

private extension ProfileTimeWindow {
    var editDisplayTitle: String {
        rawValue.prefix(1).uppercased() + rawValue.dropFirst()
    }
}
