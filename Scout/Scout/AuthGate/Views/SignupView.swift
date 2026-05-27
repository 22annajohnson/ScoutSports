//
//  SignupView.swift
//  Scout
//
//  Created by Anna on 2/25/26.
//

import SwiftUI
import ScoutDesign

struct SignupView: View {
    @State private var vm: SignupViewModel
    @Environment(\.dismiss) private var dismiss

    init(vm: SignupViewModel) {
        _vm = State(initialValue: vm)
    }

    var body: some View {
        @Bindable var vm = vm

        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                Spacer().frame(height: 24)

                Text("Create your account")
                    .font(.largeTitle)
                    .bold()

                Text("Sign up to start matching and scheduling games.")
                    .foregroundStyle(.secondary)

                VStack(spacing: 12) {
                    TextField("Email", text: $vm.form.email)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                        .textFieldStyle(.roundedBorder)

                    SecureField("Password", text: $vm.form.password)
                        .textContentType(.newPassword)
                        .textFieldStyle(.roundedBorder)

                    SecureField("Confirm Password", text: $vm.form.confirmPassword)
                        .textContentType(.newPassword)
                        .textFieldStyle(.roundedBorder)
                }
                .padding(.top, 8)

                Button {
                    Task {
                        await vm.signUp()
                    }
                } label: {
                    HStack {
                        Spacer()
                        if vm.submitState.isWorking {
                            ProgressView()
                                .padding(.trailing, 6)
                        }
                        Text(vm.submitState.isWorking ? "Signing up…" : "Sign Up")
                            .bold()
                        Spacer()
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(vm.submitState.isWorking || !vm.form.canSubmit)
                .padding(.top, 4)

                HStack(spacing: 6) {
                    Text("Already have an account?")
                        .foregroundStyle(.secondary)

                    Button("Log in") {
                        dismiss()
                    }
                    .bold()
                }
                .padding(.top, 6)

                Spacer()
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .alert(item: $vm.alert) { item in
                Alert(
                    title: Text(item.title),
                    message: Text(item.message),
                    dismissButton: .cancel(Text("OK"))
                )
            }
        }
    }
}

//#Preview {
//    SignupView(vm: SignupViewModel(session: SessionStore()))
//}
