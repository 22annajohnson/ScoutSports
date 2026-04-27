//
//  MatchView.swift
//  Scout
//
//  Created by Anna on 2/20/26.
//

import SwiftUI

struct MatchView: View {
    // MARK: - Inputs
    let model: Model

    // Accent color for the modal (use your brand color)
    let accent: Color

    // Actions
    var onProposeTime: () -> Void
    var onSendMessage: () -> Void

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [accent.opacity(0.35), Color.black.opacity(0.95)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 18) {
                Spacer(minLength: 10)

                // Header
                VStack(spacing: 10) {
                    Text("IT’S A MATCH!")
                        .font(.system(size: 34, weight: .black, design: .rounded))
                        .foregroundStyle(.white)

                    Text("You and \(model.matchedUserName) both swiped right.")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.85))
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 10)

                // Avatars
                HStack(spacing: 18) {
                    MatchAvatarView(
                        imageURL: model.currentUserImageURL,
                        fallbackInitials: initials(for: model.currentUserName),
                        ringColor: accent
                    )

                    Image(systemName: "figure.pickleball")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(10)
                        .background(
                            Circle().fill(accent.opacity(0.95))
                        )

                    MatchAvatarView(
                        imageURL: model.matchedUserImageURL,
                        fallbackInitials: initials(for: model.matchedUserName),
                        ringColor: accent
                    )
                }
                .padding(.top, 8)

                // Quick prompt
                VStack(spacing: 6) {
                    Text("Propose a time to play")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)

                    Text("Pickleball, tonight? Or lock in a time this week.")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 10)

                // Primary actions
                VStack(spacing: 12) {
                    Button {
                        onProposeTime()
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "calendar.badge.plus")
                                .font(.system(size: 16, weight: .bold))
                            Text("Propose Match Time")
                                .font(.system(size: 17, weight: .bold, design: .rounded))
                        }
                        .foregroundStyle(Color.contrastText)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 50)
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(accent.opacity(0.9))
                        )
                    }

                    Button {
                        onSendMessage()
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "bubble.left.and.bubble.right.fill")
                                .font(.system(size: 16, weight: .bold))
                            Text("Send a Message")
                                .font(.system(size: 17, weight: .bold, design: .rounded))
                        }
                        .foregroundStyle(.primaryText)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(Color.background)
                        )
                    }
                }
                .padding(.top, 6)

                // Secondary
                Button {
                    dismiss()
                } label: {
                    Text("Keep Swiping")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.85))
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                }

                Spacer(minLength: 18)
            }
            .padding(.horizontal, 22)

            // Close button
            VStack {
                HStack {
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(.white)
                            .padding(10)
                            .background(Circle().fill(Color.white.opacity(0.12)))
                    }
                    .padding(.top, 14)
                    .padding(.trailing, 14)
                }
                Spacer()
            }
        }
    }

    private func initials(for name: String) -> String {
        let parts = name
            .split(separator: " ")
            .map { String($0) }
            .filter { !$0.isEmpty }
        let first = parts.first?.first.map(String.init) ?? "?"
        let second = parts.dropFirst().first?.first.map(String.init)
        return (first + (second ?? "")).uppercased()
    }
}

extension MatchView {
    struct Model: Identifiable {
        let id = UUID()
        let currentUserName: String
        let matchedUserName: String
        let currentUserImageURL: URL?
        let matchedUserImageURL: URL?
    }
}

private struct MatchAvatarView: View {
    let imageURL: URL?
    let fallbackInitials: String
    let ringColor: Color

    var body: some View {
        ZStack {
            Circle()
                .fill(Color.white.opacity(0.12))

            if let imageURL {
                AsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .empty:
                        ProgressView()
                            .tint(.white)
                    case .failure:
                        Text(fallbackInitials)
                            .font(.system(size: 26, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                    @unknown default:
                        Text(fallbackInitials)
                            .font(.system(size: 26, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                    }
                }
            } else {
                Text(fallbackInitials)
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
            }
        }
        .frame(width: 112, height: 112)
        .clipShape(Circle())
        .overlay(
            Circle().stroke(ringColor.opacity(0.95), lineWidth: 4)
        )
        .shadow(color: .black.opacity(0.25), radius: 14, x: 0, y: 8)
    }
}

#Preview {
    MatchView(
        model: .init(
            currentUserName: "Anna",
            matchedUserName: "Noah",
            currentUserImageURL: URL(string: "https://picsum.photos/id/1011/300/300"),
            matchedUserImageURL: URL(string: "https://picsum.photos/id/1005/300/300")
        ),
        accent: Color.scout,
        onProposeTime: {},
        onSendMessage: {}
    )
}
