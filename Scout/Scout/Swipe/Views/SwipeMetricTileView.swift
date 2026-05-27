//
//  SwipeMetricTileView.swift
//  Scout
//
//  Created by Codex on 4/27/26.
//

import SwiftUI
import ScoutDesign

struct SwipeMetricTileView: View {
    enum LayoutStyle {
        case compactSquare
        case featureBand
    }

    let tile: SwipeHighlightTile
    var style: LayoutStyle = .compactSquare

    var body: some View {
        VStack(alignment: .leading, spacing: metricSpacing) {
            Text(tile.title.uppercased())
                .font(labelFont)
                .tracking(labelTracking)
                .foregroundStyle(Color.scoutTextSecondary)
                .lineLimit(1)
                .minimumScaleFactor(0.7)

            Text(tile.value)
                .font(.scoutNumberL)
                .foregroundStyle(Color.scoutOnImageTextPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.72)

            GeometryReader { geo in
                Capsule()
                    .fill(Color.scoutSwipeOverlayTrack)
                    .overlay(alignment: .leading) {
                        Capsule()
                            .fill(ScoutTheme.accentGradient)
                            .frame(width: geo.size.width * tile.progress)
                    }
            }
            .frame(height: 4)
        }
        .padding(tilePadding)
        .frame(maxWidth: .infinity, minHeight: minimumHeight, alignment: .leading)
        .modifier(SwipeMetricTileLayout(style: style))
        .background(
            RoundedRectangle(cornerRadius: ScoutLayout.Radius.lg, style: .continuous)
                .fill(Color.scoutSwipeOverlaySurface)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: ScoutLayout.Radius.lg, style: .continuous))
        )
        .overlay(
            RoundedRectangle(cornerRadius: ScoutLayout.Radius.lg, style: .continuous)
                .stroke(Color.scoutSwipeOverlayStroke, lineWidth: ScoutLayout.Stroke.hairline)
        )
    }

    private var metricSpacing: CGFloat {
        switch style {
        case .compactSquare:
            return ScoutLayout.Spacing.md
        case .featureBand:
            return ScoutLayout.Spacing.lg
        }
    }

    private var tilePadding: CGFloat {
        switch style {
        case .compactSquare:
            return ScoutLayout.Spacing.md
        case .featureBand:
            return ScoutLayout.Spacing.lg
        }
    }

    private var minimumHeight: CGFloat {
        switch style {
        case .compactSquare:
            return 0
        case .featureBand:
            return 158
        }
    }

    private var labelFont: Font {
        switch style {
        case .compactSquare:
            return .scoutMicro
        case .featureBand:
            return .scoutLabelCaps
        }
    }

    private var labelTracking: CGFloat {
        switch style {
        case .compactSquare:
            return 3
        case .featureBand:
            return 4.5
        }
    }
}

private struct SwipeMetricTileLayout: ViewModifier {
    let style: SwipeMetricTileView.LayoutStyle

    func body(content: Content) -> some View {
        switch style {
        case .compactSquare:
            content.aspectRatio(1, contentMode: .fit)
        case .featureBand:
            content
        }
    }
}
