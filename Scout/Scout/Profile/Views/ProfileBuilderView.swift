
//
//  ProfileBuilderView.swift
//  Scout
//
//  Created by Anna on 3/2/26.
//

import SwiftUI
import PhotosUI

// MARK: - Profile Builder View

struct ProfileBuilderView: View {

    @Environment(SessionStore.self) private var session
    @Environment(\.dismiss) private var dismiss

    let vm: ProfileBuilderViewModel

    init(vm: ProfileBuilderViewModel) {
        self.vm = vm
    }

    var body: some View {
        @Bindable var vm = vm

        NavigationStack {
            VStack(spacing: 0) {
                header(for: vm.step)

                TabView(selection: $vm.step) {
                    ActionShotStep(
                        image: $vm.actionShotImage,
                        item: $vm.actionShotItem
                    )
                    .tag(ProfileBuilderViewModel.Step.actionShot)

                    HeadshotStep(
                        image: $vm.headshotImage,
                        item: $vm.headshotItem
                    )
                    .tag(ProfileBuilderViewModel.Step.headshot)

                    ClubsAndCourtsStep(
                        clubsText: $vm.form.clubsText,
                        homeCourt: $vm.form.homeCourtName
                    )
                    .tag(ProfileBuilderViewModel.Step.clubsAndCourts)

                    BackgroundStep(background: $vm.form.background)
                        .tag(ProfileBuilderViewModel.Step.background)

                    PlayStyleStep(
                        skill: $vm.form.skill,
                        playStyle: $vm.form.playStyle,
                        competitivenessRating: $vm.form.competitivenessRating,
                        friendlinessRating: $vm.form.friendlinessRating,
                        socialVibeRating: $vm.form.socialVibeRating,
                        preferredMatchIntensity: $vm.form.preferredMatchIntensity
                    )
                    .tag(ProfileBuilderViewModel.Step.playStyle)

                    BioStep(bio: $vm.form.bio)
                        .tag(ProfileBuilderViewModel.Step.bio)

                    ReviewStep(
                        form: vm.form,
                        actionShot: vm.actionShotImage,
                        headshot: vm.headshotImage
                    )
                    .tag(ProfileBuilderViewModel.Step.review)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut, value: vm.step)
                .task(id: vm.actionShotItem) {
                    await vm.loadActionShotIfNeeded()
                }
                .task(id: vm.headshotItem) {
                    await vm.loadHeadshotIfNeeded()
                }

                controls
            }
            .background(ScoutTheme.screenBackground.ignoresSafeArea())
            .alert(vm.alertTitle, isPresented: $vm.isShowingAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(vm.alertMessage)
            }
        }
    }

    private func header(for step: ProfileBuilderViewModel.Step) -> some View {
        VStack(alignment: .leading, spacing: ScoutSpacing.md) {
            ScoutPageHeader(
                eyebrow: "Profile Builder",
                title: headerTitle(for: step),
                subtitle: headerSubtitle(for: step)
            ) {
                Button {
                    dismiss()
                } label: {
                    GlassChip(title: "Close")
                }
                .buttonStyle(.plain)
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.scoutSurfaceElevated)

                    Capsule()
                        .fill(ScoutTheme.accentGradient)
                        .frame(width: max(44, geo.size.width * progress(for: step)))
                }
            }
            .frame(height: 10)
            .overlay {
                Capsule()
                    .stroke(Color.scoutGlassStroke, lineWidth: ScoutStroke.hairline)
            }
        }
        .padding(.horizontal, ScoutSpacing.xl)
        .padding(.top, ScoutSpacing.xl)
        .padding(.bottom, ScoutSpacing.lg)
    }

    private func headerTitle(for step: ProfileBuilderViewModel.Step) -> String {
        switch step {
        case .actionShot:
            return "Lead with your action shot"
        case .headshot:
            return "Add a clear headshot"
        case .clubsAndCourts:
            return "Share your home base"
        case .background:
            return "Pick your background"
        case .playStyle:
            return "Show how you play"
        case .bio:
            return "Write a short bio"
        case .review:
            return "Review your profile"
        }
    }

    private func headerSubtitle(for step: ProfileBuilderViewModel.Step) -> String {
        switch step {
        case .actionShot:
            return "This becomes the hero image on your swipe card, so make it feel active and authentic."
        case .headshot:
            return "A recognizable face helps people trust the match before they ever message you."
        case .clubsAndCourts:
            return "A little local context helps Scout surface nearby, realistic matches."
        case .background:
            return "Give people a quick sense of where your game comes from."
        case .playStyle:
            return "These choices shape first impressions and future compatibility."
        case .bio:
            return "A short description helps you feel like a person, not just a card."
        case .review:
            return "Take one last pass before saving your updated profile."
        }
    }

    private func progress(for step: ProfileBuilderViewModel.Step) -> CGFloat {
        CGFloat(step.rawValue + 1) / CGFloat(ProfileBuilderViewModel.Step.allCases.count)
    }

    private var controls: some View {
        ScoutFooterBar {
            Button {
                vm.goBack()
            } label: {
                Text("Back")
            }
            .buttonStyle(ScoutSecondaryGlassButtonStyle())
            .disabled(!vm.canGoBack)

            Button {
                Task {
                    if vm.step == .review {
                        await vm.saveProfile()
                        if !vm.isShowingAlert {
                            dismiss()
                        }
                    } else {
                        vm.goNextOrShowValidationError()
                    }
                }
            } label: {
                HStack(spacing: ScoutSpacing.xs) {
                    if vm.isSaving {
                        ProgressView()
                            .tint(Color.scoutTextOnAccent)
                    }
                    Text(vm.step == .review ? "Save" : "Next")
                }
            }
            .buttonStyle(ScoutPrimaryButtonStyle())
            .disabled(vm.isSaving)
        }
    }
}

// MARK: - Steps

private struct ActionShotStep: View {
    @Binding var image: UIImage?
    @Binding var item: PhotosPickerItem?

    var body: some View {
        let pickerTitle = image == nil ? "Choose Photo" : "Change Photo"

        GeometryReader { geo in
            let mediaHeight = boundedMediaHeight(for: geo.size.height)

            ScrollView(showsIndicators: false) {
                VStack(spacing: ScoutSpacing.lg) {
                    GlassCard {
                        ScoutSection(
                            eyebrow: "Hero Media",
                            title: "Action shot",
                            subtitle: "Required. This is the image people will feel first when your card appears."
                        ) {
                            VStack(spacing: ScoutSpacing.md) {
                                BuilderPhotoFrame(title: "Action Shot", systemImage: "figure.pickleball", image: image, isCircular: false)
                                    .frame(height: mediaHeight)

                                PhotosPicker(selection: $item, matching: .images) {
                                    HStack {
                                        Image(systemName: "photo.on.rectangle.angled")
                                        Text(pickerTitle)
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(ScoutPrimaryButtonStyle())
                            }
                        }
                    }
                }
                .frame(minHeight: geo.size.height, alignment: .top)
                .padding(.horizontal, ScoutSpacing.xl)
                .padding(.bottom, ScoutSpacing.xl)
            }
        }
    }

    private func boundedMediaHeight(for availableHeight: CGFloat) -> CGFloat {
        let reservedHeight: CGFloat = image == nil ? 200 : 230
        let minHeight: CGFloat = image == nil ? 220 : 240
        let maxHeight: CGFloat = image == nil ? 292 : 320

        return min(maxHeight, max(minHeight, availableHeight - reservedHeight))
    }
}

private struct HeadshotStep: View {
    @Binding var image: UIImage?
    @Binding var item: PhotosPickerItem?

    var body: some View {
        let pickerTitle = image == nil ? "Choose Photo" : "Change Photo"

        ScrollView(showsIndicators: false) {
            VStack(spacing: ScoutSpacing.lg) {
                GlassCard {
                    ScoutSection(
                        eyebrow: "Profile Photo",
                        title: "Headshot",
                        subtitle: "Optional, but strongly recommended for trust and recognition."
                    ) {
                        VStack(spacing: ScoutSpacing.md) {
                            BuilderPhotoFrame(title: "Headshot", systemImage: "person.crop.circle", image: image, isCircular: true)
                                .frame(width: 220, height: 220)
                                .frame(maxWidth: .infinity)

                            PhotosPicker(selection: $item, matching: .images) {
                                HStack {
                                    Image(systemName: "camera.viewfinder")
                                    Text(pickerTitle)
                                }
                                .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(ScoutPrimaryButtonStyle())
                        }
                    }
                }
            }
            .padding(.horizontal, ScoutSpacing.xl)
            .padding(.bottom, ScoutSpacing.xl)
        }
    }
}

private struct ClubsAndCourtsStep: View {
    @Binding var clubsText: String
    @Binding var homeCourt: String

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: ScoutSpacing.lg) {
                GlassCard {
                    ScoutSection(
                        eyebrow: "Home Base",
                        title: "Clubs and courts",
                        subtitle: "This helps Scout prioritize players near your regular scene."
                    ) {
                        VStack(spacing: ScoutSpacing.md) {
                            BuilderField(title: "Home Court", prompt: "Home court (optional)", text: $homeCourt)

                            BuilderField(title: "Club Memberships", prompt: "Club memberships (comma separated)", text: $clubsText)
                                .textInputAutocapitalization(.words)
                        }
                    }
                }

                GlassCard {
                    ScoutSection(title: "Example") {
                        Text("Docks PB Club, Sanford Rec")
                            .font(.scoutBody)
                            .foregroundStyle(Color.scoutTextSecondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            .padding(.horizontal, ScoutSpacing.xl)
            .padding(.bottom, ScoutSpacing.xl)
        }
    }
}

private struct BackgroundStep: View {
    @Binding var background: ProfileBuilderViewModel.Background

    var body: some View {
        ScrollView(showsIndicators: false) {
            GlassCard {
                ScoutSection(
                    eyebrow: "Experience",
                    title: "Pick your background",
                    subtitle: "This gives people quick context for where your game comes from."
                ) {
                    VStack(spacing: ScoutSpacing.sm) {
                ForEach(ProfileBuilderViewModel.Background.allCases, id: \.self) { option in
                            Button {
                                background = option
                            } label: {
                                ScoutSelectionRow(
                                    title: option.displayName,
                                    subtitle: option == .professional ? "High-level competitive background" : nil,
                                    isSelected: option == background
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .padding(.horizontal, ScoutSpacing.xl)
            .padding(.bottom, ScoutSpacing.xl)
        }
    }
}

private struct PlayStyleStep: View {
    @Binding var skill: Int
    @Binding var playStyle: ProfileBuilderViewModel.PlayStyle
    @Binding var competitivenessRating: Int
    @Binding var friendlinessRating: Int
    @Binding var socialVibeRating: Int
    @Binding var preferredMatchIntensity: ProfileBuilderViewModel.MatchIntensity

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: ScoutSpacing.lg) {
                GlassCard {
                    ScoutSection(
                        eyebrow: "Skill",
                        title: "Current level",
                        subtitle: "1 = Beginner, 5 = Advanced"
                    ) {
                        BuilderSegmentedPicker(selection: $skill, values: Array(1...5))
                    }
                }

                GlassCard {
                    ScoutSection(
                        eyebrow: "Style",
                        title: "How you like to play",
                        subtitle: "We’ll use this to improve the quality of your matches."
                    ) {
                        VStack(spacing: ScoutSpacing.sm) {
                            ForEach(ProfileBuilderViewModel.PlayStyle.allCases, id: \.self) { style in
                                Button {
                                    playStyle = style
                                } label: {
                                    ScoutSelectionRow(
                                        title: style.displayName,
                                        subtitle: style == .competitive ? "Clear intent and stronger games" : nil,
                                        isSelected: style == playStyle
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }

                GlassCard {
                    ScoutSection(
                        eyebrow: "Match Style",
                        title: "How you show up",
                        subtitle: "These are your self-reported starting points."
                    ) {
                        VStack(spacing: ScoutSpacing.md) {
                            ratingRow(title: "Competitiveness", value: $competitivenessRating)
                            ratingRow(title: "Friendliness", value: $friendlinessRating)
                            ratingRow(title: "Social vibe", value: $socialVibeRating)
                        }
                    }
                }

                GlassCard {
                    ScoutSection(
                        eyebrow: "Intensity",
                        title: "Preferred match intensity",
                        subtitle: "Tell Scout whether you want a casual run, a balanced game, or a more competitive match."
                    ) {
                        Picker("Preferred Intensity", selection: $preferredMatchIntensity) {
                            ForEach(ProfileBuilderViewModel.MatchIntensity.allCases, id: \.self) { intensity in
                                Text(intensity.displayName).tag(intensity)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                }
            }
            .padding(.horizontal, ScoutSpacing.xl)
            .padding(.bottom, ScoutSpacing.xl)
        }
    }

    private func ratingRow(title: String, value: Binding<Int>) -> some View {
        VStack(alignment: .leading, spacing: ScoutSpacing.sm) {
            Text(title)
                .font(.scoutBodyEmphasis)
                .foregroundStyle(Color.scoutTextPrimary)

            BuilderSegmentedPicker(selection: value, values: Array(1...5))
        }
        .padding(ScoutSpacing.md)
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

private struct BuilderSegmentedPicker<Value: Hashable & CustomStringConvertible>: View {
    @Binding var selection: Value
    let values: [Value]

    var body: some View {
        Picker("", selection: $selection) {
            ForEach(values, id: \.self) { value in
                Text(value.description).tag(value)
            }
        }
        .pickerStyle(.segmented)
    }
}

private struct BioStep: View {
    @Binding var bio: String

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: ScoutSpacing.lg) {
                GlassCard {
                    ScoutSection(
                        eyebrow: "Bio",
                        title: "Say a little more",
                        subtitle: "A short bio helps people know what kind of match you’re looking for."
                    ) {
                        TextEditor(text: $bio)
                            .font(.scoutBody)
                            .foregroundStyle(Color.scoutTextPrimary)
                            .frame(minHeight: 180)
                            .padding(ScoutSpacing.sm)
                            .scrollContentBackground(.hidden)
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
            }
            .padding(.horizontal, ScoutSpacing.xl)
            .padding(.bottom, ScoutSpacing.xl)
        }
    }
}

private struct ReviewStep: View {
    let form: ProfileBuilderViewModel.Form
    let actionShot: UIImage?
    let headshot: UIImage?

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: ScoutSpacing.lg) {
                GlassCard(padding: ScoutSpacing.md) {
                    ZStack(alignment: .topTrailing) {
                        Group {
                            if let actionShot {
                                Image(uiImage: actionShot)
                                    .resizable()
                                    .scaledToFill()
                            } else {
                                Rectangle()
                                    .fill(Color.scoutSurfaceElevated)
                                    .overlay {
                                        Text("Missing action shot")
                                            .font(.scoutBody)
                                            .foregroundStyle(Color.scoutTextSecondary)
                                    }
                            }
                        }
                        .frame(height: 280)
                        .clipShape(RoundedRectangle(cornerRadius: ScoutRadius.lg, style: .continuous))

                        if let headshot {
                            Image(uiImage: headshot)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 82, height: 82)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white.opacity(0.8), lineWidth: 2))
                                .padding(ScoutSpacing.md)
                        }
                    }
                }

                GlassCard {
                    ScoutSection(
                        eyebrow: "Review",
                        title: "Your profile snapshot",
                        subtitle: "This should feel close to what someone will see when deciding to play with you."
                    ) {
                        VStack(alignment: .leading, spacing: ScoutSpacing.md) {
                            summaryRow(title: "Home court", value: form.homeCourtName.isEmpty ? "—" : form.homeCourtName)
                            summaryRow(title: "Clubs", value: form.clubsText.isEmpty ? "—" : form.clubsText)
                            summaryRow(title: "Background", value: form.background.displayName)
                            summaryRow(title: "Skill", value: "\(form.skill)/5")
                            summaryRow(title: "Play style", value: form.playStyle.displayName)
                            summaryRow(title: "Competitive", value: "\(form.competitivenessRating)/5")
                            summaryRow(title: "Friendly", value: "\(form.friendlinessRating)/5")
                            summaryRow(title: "Vibe", value: "\(form.socialVibeRating)/5")
                            summaryRow(title: "Intensity", value: form.preferredMatchIntensity.displayName)
                            summaryRow(title: "Bio", value: form.bio.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "—" : form.bio)
                        }
                    }
                }

                Text("Tap Save to finish.")
                    .font(.scoutCaption)
                    .foregroundStyle(Color.scoutTextSecondary)
                    .padding(.bottom, ScoutSpacing.xl)
            }
            .padding(.horizontal, ScoutSpacing.xl)
        }
    }

    private func summaryRow(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: ScoutSpacing.xxs) {
            Text(title.uppercased())
                .font(.scoutMicro)
                .tracking(2)
                .foregroundStyle(Color.scoutTextSecondary)

            Text(value)
                .font(.scoutBody)
                .foregroundStyle(Color.scoutTextPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(ScoutSpacing.md)
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

private struct BuilderField: View {
    let title: String
    let prompt: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: ScoutSpacing.xs) {
            Text(title.uppercased())
                .font(.scoutLabelCaps)
                .tracking(2.5)
                .foregroundStyle(Color.scoutTextSecondary)

            TextField(prompt, text: $text)
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
}

private struct BuilderPhotoFrame: View {
    let title: String
    let systemImage: String
    let image: UIImage?
    let isCircular: Bool

    var body: some View {
        if isCircular {
            circularBody
        } else {
            roundedBody
        }
    }

    private var circularBody: some View {
        ZStack {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
            } else {
                Circle()
                    .fill(Color.scoutSurfaceElevated)
                    .overlay {
                        placeholder
                    }
            }
        }
        .overlay(alignment: .bottomLeading) {
            GlassChip(title: title)
                .padding(ScoutSpacing.md)
        }
        .overlay {
            Circle()
                .stroke(Color.scoutGlassStroke, lineWidth: ScoutStroke.hairline)
        }
    }

    private var roundedBody: some View {
        ZStack {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .clipShape(RoundedRectangle(cornerRadius: ScoutRadius.lg, style: .continuous))
            } else {
                RoundedRectangle(cornerRadius: ScoutRadius.lg, style: .continuous)
                    .fill(Color.scoutSurfaceElevated)
                    .overlay {
                        placeholder
                    }
            }
        }
        .overlay(alignment: .bottomLeading) {
            GlassChip(title: title)
                .padding(ScoutSpacing.md)
        }
        .overlay {
            RoundedRectangle(cornerRadius: ScoutRadius.lg, style: .continuous)
                .stroke(Color.scoutGlassStroke, lineWidth: ScoutStroke.hairline)
        }
    }

    private var placeholder: some View {
        VStack(spacing: ScoutSpacing.sm) {
            Image(systemName: systemImage)
                .font(.system(size: 40, weight: .semibold))
                .foregroundStyle(Color.scoutAccentStart)
            Text(title)
                .font(.scoutSectionTitle)
                .foregroundStyle(Color.scoutTextPrimary)
        }
        .multilineTextAlignment(.center)
        .padding(ScoutSpacing.xl)
    }
}


// MARK: - Preview

#Preview {
    let env = AppEnvironment.preview

    ProfileBuilderView(vm: env.makeProfileBuilderViewModel(userIDProvider: { nil }))
        .environment(\.appEnvironment, env)
        .environment(env.makeSessionStore())
}
