//
//  SwipeCardTagCluster.swift
//  Scout
//
//  Created by Codex on 4/23/26.
//

import SwiftUI

struct SwipeCardTagCluster: View {
    let tags: [SwipeCardTagItem]

    var body: some View {
        LazyVGrid(
            columns: [GridItem(.adaptive(minimum: 118), spacing: ScoutSpacing.sm)],
            alignment: .leading,
            spacing: ScoutSpacing.sm
        ) {
            ForEach(tags) { tag in
                SwipeCardTag(item: tag)
            }
        }
    }
}

private struct SwipeCardTag: View {
    let item: SwipeCardTagItem

    var body: some View {
        Text(item.title)
            .font(.scoutPill)
            .foregroundStyle(foregroundColor)
            .lineLimit(1)
            .minimumScaleFactor(0.84)
            .frame(maxWidth: .infinity, minHeight: 36)
            .padding(.horizontal, ScoutSpacing.sm)
            .background(
                Capsule()
                    .fill(backgroundFill)
                    .background(.ultraThinMaterial, in: Capsule())
            )
            .overlay(
                Capsule()
                    .stroke(borderColor, lineWidth: ScoutStroke.hairline)
            )
    }

    private var foregroundColor: Color {
        switch item.style {
        case .neutral:
            return .white.opacity(0.92)
        case .accent, .info:
            return .white.opacity(0.94)
        }
    }

    private var backgroundFill: some ShapeStyle {
        switch item.style {
        case .neutral:
            return AnyShapeStyle(Color.black.opacity(0.20))
        case .accent:
            return AnyShapeStyle(
                LinearGradient(
                    colors: [
                        Color.scoutAccentStart.opacity(0.30),
                        Color.scoutAccentStart.opacity(0.16)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
        case .info:
            return AnyShapeStyle(
                LinearGradient(
                    colors: [
                        Color.scoutAccentEnd.opacity(0.24),
                        Color.scoutAccentEnd.opacity(0.12)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
        }
    }

    private var borderColor: Color {
        switch item.style {
        case .neutral:
            return Color.scoutAccentStart.opacity(0.18)
        case .accent:
            return Color.scoutAccentStart.opacity(0.34)
        case .info:
            return Color.scoutAccentEnd.opacity(0.30)
        }
    }
}

struct SwipeCardTagItem: Identifiable {
    enum Style {
        case neutral
        case accent
        case info
    }

    let id: String
    let title: String
    let style: Style

    init(title: String, style: Style = .neutral) {
        self.id = "\(style)-\(title)"
        self.title = title
        self.style = style
    }
}

#Preview("Swipe Card Tag Cluster") {
    ZStack {
        ScoutTheme.screenBackground.ignoresSafeArea()

        SwipeCardTagCluster(
            tags: [
                SwipeCardTagItem(title: "4.7 Competitive", style: .accent),
                SwipeCardTagItem(title: "Reliable", style: .info),
                SwipeCardTagItem(title: "Tue/Thu Nights"),
                SwipeCardTagItem(title: "Pickleball")
            ]
        )
        .padding()
    }
}
