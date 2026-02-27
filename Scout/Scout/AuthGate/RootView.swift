//
//  RootView.swift
//  Scout
//
//  Created by Anna on 2/25/26.
//

import SwiftUI
internal import Auth

struct RootView: View {
    @EnvironmentObject var session: SessionStore
    @AppStorage("scout_onboarded_user_id") private var onboardedUserId: String = ""

    var body: some View {
        Group {
            if session.isLoading {
                ProgressView()
            } else if session.user == nil {
                LoginView(session: session)
            } else {
                let currentId = session.user?.id.uuidString ?? ""

                let didCompleteOnboarding = Binding<Bool>(
                    get: { onboardedUserId == currentId && !currentId.isEmpty },
                    set: { newValue in
                        if newValue {
                            onboardedUserId = currentId
                        } else {
                            if onboardedUserId == currentId {
                                onboardedUserId = ""
                            }
                        }
                    }
                )

                if !didCompleteOnboarding.wrappedValue {
                    OnboardingView(didCompleteOnboarding: didCompleteOnboarding)
                } else {
                    SwipeDeckView(models: getMockCardViewModels())
                        .environmentObject(session)
                }
            }
        }
    }
}
//
//#Preview {
//  RootView()
//    .environmentObject(SessionStore())
//}
