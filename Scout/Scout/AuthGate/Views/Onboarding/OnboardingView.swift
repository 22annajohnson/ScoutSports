//
//  OnboardingView.swift
//  Scout
//
//  Created by Anna on 2/25/26.
//

import SwiftUI
import CoreLocation
import PhotosUI

// MARK: - View

struct OnboardingView: View {
    @Binding var didCompleteOnboarding: Bool

    @State private var vm: OnboardingViewModel

    init(didCompleteOnboarding: Binding<Bool>, vm: OnboardingViewModel) {
        _didCompleteOnboarding = didCompleteOnboarding
        _vm = State(initialValue: vm)
    }

    var body: some View {
        @Bindable var vm = vm

        ScoutFormPageShell {
            header
        } content: {
            ZStack {
                switch vm.step {
                case .nameAge:
                    nameAgeStep
                        .transition(.opacity)
                case .location:
                    locationStep
                        .transition(.opacity)
                case .sport:
                    sportStep
                        .transition(.opacity)
                case .photos:
                    photosStep
                        .transition(.opacity)
                }
            }
            .animation(.default, value: vm.step)
        } footer: {
            footer
        }
        .tint(Color.scout)
        .alert(item: $vm.alert) { item in
            Alert(
                title: Text(item.title),
                message: Text(item.message),
                dismissButton: .cancel(Text("OK"))
            )
        }
        .task(id: vm.photoItems) {
            await vm.handlePhotoItemsChanged(vm.photoItems)
        }
    }

    // MARK: - Header / Footer

    private var header: some View {
        VStack(alignment: .leading, spacing: ScoutSpacing.md) {
            ScoutPageHeader(
                eyebrow: "Onboarding",
                title: headerTitle,
                subtitle: headerSubtitle
            ) {
                GlassChip(title: "\(vm.step.index + 1)/\(OnboardingViewModel.Step.allCases.count)")
            }

            progressBar
        }
    }

    private var footer: some View {
        ScoutFooterBar {
            Button("Back") {
                vm.goBack()
            }
            .buttonStyle(ScoutSecondaryGlassButtonStyle())
            .disabled(!vm.canGoBack)

            Button {
                if vm.step == .photos {
                    Task {
                        if await vm.finish() {
                            didCompleteOnboarding = true
                        }
                    }
                } else {
                    vm.goNext()
                }
            }
            label: {
                if vm.step == .photos && vm.isSaving {
                    ProgressView()
                        .tint(Color.scoutTextOnAccent)
                        .frame(minWidth: 72)
                } else {
                    Text(vm.step == .photos ? "Finish" : "Next")
                }
            }
            .buttonStyle(ScoutPrimaryButtonStyle())
            .disabled(!vm.canAdvance || vm.isSaving)
        }
    }

    // MARK: - Steps

    private var nameAgeStep: some View {
        GlassCard {
            ScoutSection(
                eyebrow: "Profile Basics",
                title: "Tell us about you",
                subtitle: "This helps other people feel confident swiping and setting up a game."
            ) {
                VStack(spacing: ScoutSpacing.md) {
                    field(title: "Name") {
                        TextField("Your first name", text: $vm.form.name)
                            .textContentType(.name)
                    }

                    field(title: "Age") {
                        TextField("How old are you?", text: $vm.form.ageText)
                            .keyboardType(.numberPad)
                            .textContentType(.none)
                    }
                }
            }
        }
    }

    private var locationStep: some View {
        VStack(spacing: ScoutSpacing.lg) {
            GlassCard {
                ScoutSection(
                    eyebrow: "Nearby Matches",
                    title: "Enable location",
                    subtitle: "Scout uses your location to show people nearby and help plan games in the right area. We only use it while you’re using the app."
                ) {
                    LocationStatusRow(status: vm.location.status)
                }
            }

            GlassCard {
                ScoutSection(title: "Permission") {
                    VStack(alignment: .leading, spacing: ScoutSpacing.md) {
                        Button {
                            vm.requestLocation()
                        } label: {
                            Text(vm.locationButtonTitle)
                        }
                        .buttonStyle(ScoutPrimaryButtonStyle())
                        .disabled(vm.isLocationAuthorized)

                        Button("Not now") {
                            vm.skipLocation()
                        }
                        .buttonStyle(ScoutSecondaryGlassButtonStyle())
                    }
                }
            }
        }
    }

    private var sportStep: some View {
        GlassCard {
            ScoutSection(
                eyebrow: "Sport",
                title: "Choose a sport",
                subtitle: "We’re starting with pickleball. More sports are coming soon."
            ) {
                VStack(spacing: ScoutSpacing.md) {
                    SportCard(
                        title: "Pickleball",
                        subtitle: "Available now",
                        isSelected: vm.form.selectedSport == .pickleball,
                        isEnabled: true
                    ) {
                        vm.selectSport(.pickleball)
                    }

                    SportCard(
                        title: "Tennis",
                        subtitle: "Coming soon",
                        isSelected: vm.form.selectedSport == .tennis,
                        isEnabled: false
                    ) {
                        // disabled
                    }
                }
            }
        }
    }

    private var photosStep: some View {
        VStack(spacing: ScoutSpacing.lg) {
            GlassCard {
                ScoutSection(
                    eyebrow: "Photos",
                    title: "Add a few photos",
                    subtitle: "Profiles with photos get more matches. Pick up to 3 for now."
                ) {
                    VStack(spacing: ScoutSpacing.md) {
                        Button {
                            // handled by PhotosPicker label below
                        } label: {
                            EmptyView()
                        }
                        .hidden()

                        PhotosPicker(
                            selection: $vm.photoItems,
                            maxSelectionCount: 3,
                            matching: .images
                        ) {
                            HStack {
                                Image(systemName: "photo.on.rectangle.angled")
                                Text("Choose photos")
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(ScoutPrimaryButtonStyle())
                    }
                }
            }

            GlassCard {
                ScoutSection(title: "Selected Photos", subtitle: vm.photos.isEmpty ? "No photos selected yet." : "Your first photo will do the most work on your profile.") {
                    if vm.photos.isEmpty {
                        HStack(spacing: ScoutSpacing.sm) {
                            Image(systemName: "photo")
                                .font(.system(size: 22, weight: .semibold))
                                .foregroundStyle(Color.scoutTextSecondary)

                            Text("No photos selected yet.")
                                .font(.scoutBody)
                                .foregroundStyle(Color.scoutTextSecondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, ScoutSpacing.sm)
                    } else {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: ScoutSpacing.md) {
                                ForEach(Array(vm.photos.enumerated()), id: \.offset) { index, img in
                                    photoPreview(image: img, index: index)
                                }
                            }
                            .padding(.vertical, ScoutSpacing.xs)
                        }
                    }
                }
            }
        }
    }

    private var progressBar: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.scoutSurfaceElevated)

                Capsule()
                    .fill(ScoutTheme.accentGradient)
                    .frame(width: max(44, geo.size.width * progress))
            }
        }
        .frame(height: 10)
        .overlay {
            Capsule()
                .stroke(Color.scoutGlassStroke, lineWidth: ScoutStroke.hairline)
        }
    }

    private var progress: CGFloat {
        CGFloat(vm.step.index + 1) / CGFloat(OnboardingViewModel.Step.allCases.count)
    }

    private var headerTitle: String {
        switch vm.step {
        case .nameAge:
            return "Start your Scout profile"
        case .location:
            return "See matches nearby"
        case .sport:
            return "Choose your sport"
        case .photos:
            return "Make your profile pop"
        }
    }

    private var headerSubtitle: String {
        switch vm.step {
        case .nameAge:
            return "A quick setup so your first matches feel intentional and trustworthy."
        case .location:
            return "Location helps us put the right people and courts in front of you."
        case .sport:
            return "We’re starting focused, then expanding from there."
        case .photos:
            return "A few strong photos dramatically improve first impressions."
        }
    }

    private func field<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: ScoutSpacing.xs) {
            Text(title.uppercased())
                .font(.scoutLabelCaps)
                .tracking(2.5)
                .foregroundStyle(Color.scoutTextSecondary)

            content()
                .font(.scoutBody)
                .foregroundStyle(Color.scoutTextPrimary)
                .padding(.horizontal, ScoutSpacing.md)
                .padding(.vertical, ScoutSpacing.md)
                .background(
                    RoundedRectangle(cornerRadius: ScoutRadius.md, style: .continuous)
                        .fill(Color.scoutSurfaceElevated)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: ScoutRadius.md, style: .continuous)
                        .stroke(Color.scoutGlassStroke, lineWidth: ScoutStroke.hairline)
                )
        }
    }

    private func photoPreview(image: UIImage, index: Int) -> some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFill()
            .frame(width: 116, height: 150)
            .clipShape(RoundedRectangle(cornerRadius: ScoutRadius.md, style: .continuous))
            .overlay(alignment: .bottomLeading) {
                GlassChip(title: index == 0 ? "Primary" : "Photo \(index + 1)")
                    .padding(ScoutSpacing.sm)
            }
            .overlay(
                RoundedRectangle(cornerRadius: ScoutRadius.md, style: .continuous)
                    .stroke(Color.scoutGlassStroke, lineWidth: ScoutStroke.hairline)
            )
    }
}


#Preview {
    let appEnvironment = AppEnvironment.preview

    OnboardingView(
        didCompleteOnboarding: .constant(false),
        vm: appEnvironment.makeOnboardingViewModel()
    )
}
