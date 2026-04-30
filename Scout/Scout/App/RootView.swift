//
//  RootView.swift
//  Scout
//
//  Created by Anna on 2/25/26.
//

import SwiftUI

struct RootView: View {
    @Environment(\.appEnvironment) private var appEnvironment
    @Environment(SessionStore.self) private var session
    @AppStorage("scout_onboarded_user_id") private var onboardedUserId: String = ""

    var body: some View {
        Group {
            if session.isLoading {
                ProgressView()
            } else if session.userID == nil {
                LoginView(session: session)
            } else {
                let currentId = session.userID?.uuidString ?? ""

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
                    OnboardingView(
                        didCompleteOnboarding: didCompleteOnboarding,
                        vm: appEnvironment.makeOnboardingViewModel()
                    )
                } else {
                    ScoutHomeScreen(
                        swipeViewModel: appEnvironment.makeSwipeDeckViewModel(session: session),
                        feedViewModel: appEnvironment.makeFeedViewModel()
                    )
                        .environment(session)
                }
            }
        }
        .task {
            await session.loadInitialSessionIfNeeded()
        }
    }
}

#Preview {
    let appEnvironment = AppEnvironment.preview

    RootView()
        .environment(\.appEnvironment, appEnvironment)
        .environment(appEnvironment.makeSessionStore())
}
