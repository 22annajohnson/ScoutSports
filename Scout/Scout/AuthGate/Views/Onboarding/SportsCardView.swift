//
//  SportsCardView.swift
//  Scout
//
//  Created by Anna on 2/26/26.
//

import SwiftUI
// MARK: - Sport Card

struct SportCard: View {
    let title: String
    let subtitle: String?
    let isSelected: Bool
    let isEnabled: Bool
    let onTap: () -> Void

    var body: some View {
        Button {
            if isEnabled { onTap() }
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color(.secondarySystemBackground))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(isSelected ? Color.scout : Color(.separator), lineWidth: isSelected ? 2 : 1)
                    )

                VStack(spacing: 8) {
                    Text(title)
                        .font(.title3)
                        .bold()

                    if let subtitle {
                        Text(subtitle)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding()

                if !isEnabled {
                    VStack {
                        Spacer()
                        Text("Coming soon")
                            .font(.caption)
                            .bold()
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(
                                Capsule().fill(Color(.systemBackground).opacity(0.9))
                            )
                            .overlay(
                                Capsule().stroke(Color(.separator), lineWidth: 1)
                            )
                            .padding(.bottom, 10)
                    }
                }
            }
            .frame(height: 160)
            .opacity(isEnabled ? 1.0 : 0.7)
        }
        .buttonStyle(.plain)
    }
}
