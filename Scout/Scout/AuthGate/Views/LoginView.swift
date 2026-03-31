//
//  LoginView.swift
//  Scout
//
//  Created by Anna on 2/25/26.
//

import SwiftUI


struct LoginView: View {
    private let session: SessionStore
    @StateObject private var vm: LoginViewModel
    @State private var showSignup: Bool = false

    init(session: SessionStore) {
        self.session = session
        _vm = StateObject(wrappedValue: LoginViewModel(session: session))
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                Spacer().frame(height: 24)

                Text("Welcome back")
                    .font(.largeTitle)
                    .bold()

                Text("Log in to keep swiping and set up games.")
                    .foregroundStyle(.secondary)

                VStack(spacing: 12) {
                    TextField("Email", text: $vm.email)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                        .textFieldStyle(.roundedBorder)

                    SecureField("Password", text: $vm.password)
                        .textContentType(.password)
                        .textFieldStyle(.roundedBorder)
                }
                .padding(.top, 8)

                Button {
                    Task {
                        await vm.login()
                    }
                } label: {
                    HStack {
                        Spacer()
                        if vm.submitState.isWorking {
                            ProgressView()
                                .padding(.trailing, 6)
                        }
                        Text(vm.submitState.isWorking ? "Logging in…" : "Log In")
                            .bold()
                        Spacer()
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(vm.submitState.isWorking || !vm.canSubmit)
                .padding(.top, 4)

                HStack(spacing: 6) {
                    Text("New to Scout?")
                        .foregroundStyle(.secondary)

                    Button("Sign up") {
                        showSignup = true
                    }
                    .bold()
                    .foregroundStyle(Color.scout)
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
            .navigationDestination(isPresented: $showSignup) {
                SignupView(vm: SignupViewModel(session: session))
            }
        }
    }
}

//#Preview {
//    LoginView(session: SessionStore())
//}
