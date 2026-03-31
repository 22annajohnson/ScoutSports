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

    @StateObject private var vm: OnboardingViewModel

    init(didCompleteOnboarding: Binding<Bool>) {
        _didCompleteOnboarding = didCompleteOnboarding
        _vm = StateObject(wrappedValue: OnboardingViewModel())
    }

    var body: some View {
        VStack(spacing: 0) {
            header

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

            footer
        }
        .tint(Color.scout)
        .background(Color(.systemBackground))
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
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Welcome to Scout")
                    .font(.title2)
                    .bold()

                Spacer()

                Text("\(vm.step.index + 1)/\(OnboardingViewModel.Step.allCases.count)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            ProgressView(value: Double(vm.step.index + 1), total: Double(OnboardingViewModel.Step.allCases.count))
        }
        .padding()
        .padding(.top, 8)
    }

    private var footer: some View {
        HStack(spacing: 12) {
            Button("Back") {
                vm.goBack()
            }
            .buttonStyle(.bordered)
            .disabled(!vm.canGoBack)

            Spacer()

            Button(vm.step == .photos ? "Finish" : "Next") {
                if vm.step == .photos {
                    vm.finish()
                    didCompleteOnboarding = true
                } else {
                    vm.goNext()
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(!vm.canAdvance)
        }
        .padding()
    }

    // MARK: - Steps

    private var nameAgeStep: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Tell us about you")
                .font(.largeTitle)
                .bold()

            Text("This helps other people feel confident swiping and setting up a game.")
                .foregroundStyle(.secondary)

            VStack(spacing: 12) {
                TextField("Name", text: $vm.form.name)
                    .textContentType(.name)
                    .textFieldStyle(.roundedBorder)

                TextField("Age", text: $vm.form.ageText)
                    .keyboardType(.numberPad)
                    .textContentType(.none)
                    .textFieldStyle(.roundedBorder)
            }
            .padding(.top, 8)

            Spacer()
        }
        .padding()
    }

    private var locationStep: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Enable location")
                .font(.largeTitle)
                .bold()

            Text("Scout uses your location to show people nearby and to help you plan games in the right area. We only use it while you’re using the app.")
                .foregroundStyle(.secondary)

            VStack(alignment: .leading, spacing: 12) {
                LocationStatusRow(status: vm.location.status)

                Button {
                    vm.requestLocation()
                } label: {
                    Text(vm.locationButtonTitle)
                        .bold()
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(vm.isLocationAuthorized)

                Button("Not now") {
                    vm.skipLocation()
                }
                .buttonStyle(.bordered)
            }
            .padding(.top, 8)

            Spacer()
        }
        .padding()
    }

    private var sportStep: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Choose a sport")
                .font(.largeTitle)
                .bold()

            Text("We’re starting with pickleball. More sports coming soon.")
                .foregroundStyle(.secondary)

            HStack(spacing: 12) {
                SportCard(
                    title: "Pickleball",
                    subtitle: nil,
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
            .padding(.top, 8)

            Spacer()
        }
        .padding()
    }

    private var photosStep: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Add a few photos")
                .font(.largeTitle)
                .bold()

            Text("Profiles with photos get more matches. Pick up to 3 for now.")
                .foregroundStyle(.secondary)

            PhotosPicker(
                selection: $vm.photoItems,
                maxSelectionCount: 3,
                matching: .images
            ) {
                Text("Choose photos")
                    .bold()
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding(.top, 8)
            
            

            if vm.photos.isEmpty {
                Text("No photos selected yet.")
                    .foregroundStyle(.secondary)
                    .padding(.top, 4)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(Array(vm.photos.enumerated()), id: \.offset) { _, img in
                            Image(uiImage: img)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 96, height: 128)
                                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .stroke(Color(.separator), lineWidth: 1)
                                )
                        }
                    }
                    .padding(.vertical, 8)
                }
            }

            Spacer()
        }
        .padding()
    }
}


#Preview {
    OnboardingView(didCompleteOnboarding: .constant(false))
}
