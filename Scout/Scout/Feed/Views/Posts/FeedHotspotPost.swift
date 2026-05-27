//
//  FeedHotspotPost.swift
//  Scout
//
//  Created by Codex on 4/30/26.
//

import SwiftUI
import ScoutDesign

struct FeedHotspotPost: View {
    let post: FeedPreviewPost
    let pills: [String]

    var body: some View {
        FeedPostShell(post: post) {
            VStack(alignment: .leading, spacing: ScoutLayout.Spacing.md) {
                ZStack {
                    RoundedRectangle(cornerRadius: ScoutLayout.Radius.lg, style: .continuous)
                        .fill(
                            RadialGradient(
                                colors: [Color.scoutAccentStart.opacity(0.32), Color.clear],
                                center: UnitPoint(x: 0.72, y: 0.28),
                                startRadius: 12,
                                endRadius: 120
                            )
                        )
                        .background(
                            Color.scoutScrimStrong.opacity(0.9),
                            in: RoundedRectangle(cornerRadius: ScoutLayout.Radius.lg, style: .continuous)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: ScoutLayout.Radius.lg, style: .continuous)
                                .stroke(Color.scoutFeedCardStroke, lineWidth: ScoutLayout.Stroke.hairline)
                        )

                    RoundedRectangle(cornerRadius: ScoutLayout.Radius.md, style: .continuous)
                        .fill(Color.scoutGlassFill.opacity(0.68))
                        .padding(ScoutLayout.Spacing.md)

                    hotspotDots
                        .padding(.horizontal, 34)
                        .padding(.vertical, 28)
                }
                .frame(height: 148)

                HStack(spacing: ScoutLayout.Spacing.sm) {
                    ForEach(pills, id: \.self) { pill in
                        Text(pill)
                            .font(.scoutMicro)
                            .foregroundStyle(Color.scoutTextPrimary.opacity(0.78))
                            .padding(.horizontal, ScoutLayout.Spacing.md)
                            .padding(.vertical, ScoutLayout.Spacing.sm)
                            .background(Color.scoutGlassFill.opacity(0.96), in: Capsule())
                    }
                }
            }
        }
    }

    private var hotspotDots: some View {
        GeometryReader { geo in
            ZStack {
                hotspotDot(color: Color.scoutAccentStart, size: 34)
                    .position(x: geo.size.width * 0.22, y: geo.size.height * 0.46)
                hotspotDot(color: Color.scoutGradientViolet.opacity(0.82), size: 26)
                    .position(x: geo.size.width * 0.55, y: geo.size.height * 0.22)
                hotspotDot(color: Color.scoutSuccess, size: 40)
                    .position(x: geo.size.width * 0.82, y: geo.size.height * 0.72)
            }
        }
    }

    private func hotspotDot(color: Color, size: CGFloat) -> some View {
        ZStack {
            Circle()
                .fill(color.opacity(0.30))
                .frame(width: size, height: size)
            Circle()
                .fill(color)
                .frame(width: size * 0.46, height: size * 0.46)
        }
    }
}
