
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

    @EnvironmentObject private var session: SessionStore
    @Environment(\.dismiss) private var dismiss

    @ObservedObject var vm: ProfileBuilderViewModel

    init(vm: ProfileBuilderViewModel) {
        self.vm = vm
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
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
                        playStyle: $vm.form.playStyle
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

                Divider()

                controls
            }
            .navigationTitle(vm.step.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
            .alert(vm.alertTitle, isPresented: $vm.isShowingAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(vm.alertMessage)
            }
        }
    }

    private var controls: some View {
        HStack(spacing: 12) {
            Button {
                vm.goBack()
            } label: {
                Text("Back")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .disabled(!vm.canGoBack)

            Button {
                Task {
                    if vm.step == .review {
                        await vm.saveProfile()
                        // If we didn't show an error alert, close the flow.
                        if !vm.isShowingAlert {
                            dismiss()
                        }
                    } else {
                        vm.goNextOrShowValidationError()
                    }
                }
            } label: {
                HStack(spacing: 8) {
                    if vm.isSaving {
                        ProgressView()
                    }
                    Text(vm.step == .review ? "Save" : "Next")
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(Color.scout)
            .disabled(vm.isSaving)
        }
        .padding(16)
        .background(.thinMaterial)
    }
}

// MARK: - Steps

private struct ActionShotStep: View {
    @Binding var image: UIImage?
    @Binding var item: PhotosPickerItem?

    var body: some View {
        let pickerTitle = image == nil ? "Choose Photo" : "Change Photo"

        VStack(spacing: 16) {
            Spacer(minLength: 0)

            ZStack {
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color.black.opacity(0.08))
                    .overlay {
                        RoundedRectangle(cornerRadius: 18)
                            .strokeBorder(Color.scout.opacity(0.35), lineWidth: 1)
                    }

                if let image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .overlay(alignment: .bottomLeading) {
                            Text("Action Shot")
                                .font(.headline)
                                .padding(10)
                                .background(.ultraThinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .padding(12)
                        }
                } else {
                    VStack(spacing: 10) {
                        Image(systemName: "figure.pickleball")
                            .font(.system(size: 40, weight: .semibold))
                            .foregroundStyle(Color.scout)
                        Text("Add an action shot")
                            .font(.headline)
                        Text("Required — this is the background photo on your swipe card.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(24)
                }
            }
            .frame(height: 360)
            .padding(.horizontal, 16)

            PhotosPicker(selection: $item, matching: .images) {
                Text(pickerTitle)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .tint(Color.scout)
            .padding(.horizontal, 16)

            Spacer(minLength: 0)
        }
        .padding(.vertical, 16)
    }
}

private struct HeadshotStep: View {
    @Binding var image: UIImage?
    @Binding var item: PhotosPickerItem?

    var body: some View {
        let pickerTitle = image == nil ? "Choose Photo" : "Change Photo"

        VStack(spacing: 16) {
            Spacer(minLength: 0)

            ZStack {
                Circle()
                    .fill(Color.black.opacity(0.08))
                    .overlay {
                        Circle()
                            .strokeBorder(Color.scout.opacity(0.35), lineWidth: 1)
                    }

                if let image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                } else {
                    VStack(spacing: 10) {
                        Image(systemName: "person.crop.circle")
                            .font(.system(size: 42, weight: .semibold))
                            .foregroundStyle(Color.scout)
                        Text("Add a headshot")
                            .font(.headline)
                        Text("Recommended — shown on your profile.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .multilineTextAlignment(.center)
                    .padding(18)
                }
            }
            .frame(width: 220, height: 220)

            PhotosPicker(selection: $item, matching: .images) {
                Text(pickerTitle)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .tint(Color.scout)
            .padding(.horizontal, 16)

            Spacer(minLength: 0)
        }
        .padding(.vertical, 16)
    }
}

private struct ClubsAndCourtsStep: View {
    @Binding var clubsText: String
    @Binding var homeCourt: String

    var body: some View {
        Form {
            Section {
                TextField("Home court (optional)", text: $homeCourt)
            } header: {
                Text("Home Court")
            } footer: {
                Text("This helps Scout prioritize players near your favorite court.")
            }

            Section {
                TextField("Club memberships (comma separated)", text: $clubsText)
                    .textInputAutocapitalization(.words)
            } header: {
                Text("Club Memberships")
            } footer: {
                Text("Example: Docks PB Club, Sanford Rec")
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.clear)
    }
}

private struct BackgroundStep: View {
    @Binding var background: ProfileBuilderViewModel.Background

    var body: some View {
        List {
            Section {
                ForEach(ProfileBuilderViewModel.Background.allCases, id: \.self) { option in
                    HStack {
                        Text(option.displayName)
                        Spacer()
                        if option == background {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(Color.scout)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        background = option
                    }
                }
            } footer: {
                Text("This helps Scout match you with compatible players.")
            }
        }
        .listStyle(.insetGrouped)
    }
}

private struct PlayStyleStep: View {
    @Binding var skill: Int
    @Binding var playStyle: ProfileBuilderViewModel.PlayStyle

    var body: some View {
        Form {
            Section {
                Picker("Skill", selection: $skill) {
                    ForEach(1...5, id: \.self) { value in
                        Text("\(value)").tag(value)
                    }
                }
                .pickerStyle(.segmented)
            } header: {
                Text("Skill")
            } footer: {
                Text("1 = Beginner, 5 = Advanced")
            }

            Section {
                ForEach(ProfileBuilderViewModel.PlayStyle.allCases, id: \.self) { style in
                    HStack {
                        Text(style.displayName)
                        Spacer()
                        if style == playStyle {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(Color.scout)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        playStyle = style
                    }
                }
            } header: {
                Text("Play Style")
            } footer: {
                Text("We’ll use this to improve your matches.")
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.clear)
    }
}

private struct BioStep: View {
    @Binding var bio: String

    var body: some View {
        Form {
            Section {
                TextEditor(text: $bio)
                    .frame(minHeight: 140)
            } header: {
                Text("Bio (optional)")
            } footer: {
                Text("A short bio helps people know what kind of match you’re looking for.")
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.clear)
    }
}

private struct ReviewStep: View {
    let form: ProfileBuilderViewModel.Form
    let actionShot: UIImage?
    let headshot: UIImage?

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 18)
                        .fill(Color.black.opacity(0.08))

                    if let actionShot {
                        Image(uiImage: actionShot)
                            .resizable()
                            .scaledToFill()
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                    } else {
                        Text("Missing action shot")
                            .foregroundStyle(.secondary)
                    }

                    VStack {
                        HStack {
                            Spacer()
                            if let headshot {
                                Image(uiImage: headshot)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 72, height: 72)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.white.opacity(0.8), lineWidth: 2))
                                    .padding(12)
                            }
                        }
                        Spacer()
                    }
                }
                .frame(height: 260)

                VStack(alignment: .leading, spacing: 10) {
                    summaryRow(title: "Home court", value: form.homeCourtName.isEmpty ? "—" : form.homeCourtName)
                    summaryRow(title: "Clubs", value: form.clubsText.isEmpty ? "—" : form.clubsText)
                    summaryRow(title: "Background", value: form.background.displayName)
                    summaryRow(title: "Skill", value: "\(form.skill)/5")
                    summaryRow(title: "Play style", value: form.playStyle.displayName)
                    summaryRow(title: "Bio", value: form.bio.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "—" : form.bio)
                }
                .padding(16)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal, 16)

                Text("Tap Save to finish.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 24)
            }
            .padding(.top, 16)
        }
    }

    private func summaryRow(title: String, value: String) -> some View {
        HStack(alignment: .top) {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(width: 92, alignment: .leading)
            Text(value)
                .font(.subheadline)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}


// MARK: - Preview

#Preview {
    let env = AppEnvironment.shared

    ProfileBuilderView(vm: env.makeProfileBuilderViewModel(userIDProvider: { nil }))
        .environmentObject(env.makeSessionStore())
}
