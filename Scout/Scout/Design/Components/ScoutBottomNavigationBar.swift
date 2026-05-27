//
//  ScoutBottomNavigationBar.swift
//  Scout
//
//  Created by Codex on 4/29/26.
//

import SwiftUI
import ScoutDesign

struct ScoutBottomNavigationBar: View {
    let selectedTab: ScoutHomeTab
    let navigationStyle: ScoutHomeNavigationStyle
    let visibility: ScoutHomeNavigationVisibility
    let chromeMode: ScoutHomeChromeMode
    let onSelect: (ScoutHomeTab) -> Void
    let onToggleMenu: () -> Void

    private var isBubble: Bool {
        navigationStyle == .bubble
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                if isBubble {
                    bubbleContent
                        .transition(.opacity.combined(with: .scale(scale: 0.92)))
                } else {
                    barContent
                        .transition(.opacity.combined(with: .scale(scale: 0.98)))
                }
            }
            .frame(width: containerWidth(availableWidth: geo.size.width), height: containerHeight)
            .background(glassBackground(shape: containerShape))
            .overlay(glassStroke(shape: containerShape))
            .shadow(color: Color.scoutShadowStrong.opacity(0.88), radius: 20, y: 10)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: isBubble ? .bottomTrailing : .bottom)
            .offset(y: visibility == .hidden ? 120 : (chromeMode == .condensed && navigationStyle == .bar ? 8 : 0))
            .opacity(visibility == .hidden ? 0 : 1)
        }
        .frame(height: containerHeight)
    }

    private var bubbleContent: some View {
        Button(action: onToggleMenu) {
            Image(systemName: "line.3.horizontal")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(Color.scoutTextPrimary)
                .frame(width: 58, height: 58)
        }
        .buttonStyle(ScoutBottomNavigationButtonStyle())
    }

    private var barContent: some View {
        HStack(spacing: ScoutLayout.Spacing.sm) {
            ForEach(ScoutHomeTab.allCases, id: \.self) { tab in
                button(for: tab)
            }

            if selectedTab == .swipe {
                Button(action: onToggleMenu) {
                    Image(systemName: "xmark")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(Color.scoutTextPrimary)
                        .frame(width: 42, height: 42)
                        .background(Color.scoutGlassFill.opacity(0.68), in: Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.scoutGlassStroke.opacity(0.9), lineWidth: ScoutLayout.Stroke.hairline)
                        )
                }
                .buttonStyle(ScoutBottomNavigationButtonStyle())
            }
        }
        .padding(.horizontal, ScoutLayout.Spacing.sm)
        .padding(.vertical, chromeMode == .expanded ? ScoutLayout.Spacing.sm : ScoutLayout.Spacing.xs)
    }

    private func button(for tab: ScoutHomeTab) -> some View {
        let isSelected = selectedTab == tab

        return Button {
            onSelect(tab)
        } label: {
            HStack(spacing: chromeMode == .expanded ? ScoutLayout.Spacing.xs : 0) {
                Image(systemName: tab.systemImage)
                    .font(.system(size: 16, weight: .bold))

                if chromeMode == .expanded {
                    Text(tab.title)
                        .font(.scoutCallout)
                        .transition(.opacity.combined(with: .scale(scale: 0.96)))
                }
            }
            .foregroundStyle(isSelected ? Color.scoutTextOnAccent : Color.scoutTextPrimary)
            .frame(maxWidth: .infinity)
            .frame(height: chromeMode == .expanded ? 52 : 42)
            .background(buttonBackground(isSelected: isSelected))
            .overlay(buttonStroke(isSelected: isSelected))
        }
        .buttonStyle(ScoutBottomNavigationButtonStyle())
    }

    @ViewBuilder
    private func buttonBackground(isSelected: Bool) -> some View {
        if isSelected {
            Capsule()
                .fill(ScoutTheme.accentGradient)
        } else {
            Capsule()
                .fill(Color.scoutGlassFill.opacity(0.68))
        }
    }

    private func buttonStroke(isSelected: Bool) -> some View {
        Capsule()
            .stroke(
                isSelected ? Color.scoutGlassHighlightSoft : Color.scoutGlassStroke.opacity(0.9),
                lineWidth: ScoutLayout.Stroke.hairline
            )
    }

    private func glassBackground<S: InsettableShape>(shape: S) -> some View {
        shape
            .fill(Color.scoutGlassFill.opacity(0.95))
            .background(.ultraThinMaterial, in: shape)
            .overlay {
                shape
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.scoutGlassHighlightSoft,
                                Color.scoutGlassFill.opacity(0.45),
                                Color.scoutAccentStart.opacity(0.10)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            .overlay {
                shape
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.scoutAccentEnd.opacity(0.18),
                                Color.clear
                            ],
                            center: .topTrailing,
                            startRadius: 6,
                            endRadius: 110
                        )
                    )
            }
    }

    private func glassStroke<S: InsettableShape>(shape: S) -> some View {
        shape
            .stroke(
                LinearGradient(
                    colors: [
                        Color.scoutGlassHighlightStrong,
                        Color.scoutGlassStroke,
                        Color.scoutAccentStart.opacity(0.16)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                lineWidth: ScoutLayout.Stroke.hairline
            )
    }

    private func containerWidth(availableWidth: CGFloat) -> CGFloat {
        isBubble ? 58 : min(availableWidth, 420)
    }

    private var containerHeight: CGFloat {
        isBubble ? 58 : (chromeMode == .expanded ? ScoutChrome.bottomBarExpandedHeight : ScoutChrome.bottomBarCondensedHeight)
    }

    private var containerShape: RoundedRectangle {
        RoundedRectangle(
            cornerRadius: isBubble ? 29 : containerHeight / 2,
            style: .continuous
        )
    }
}

private struct ScoutBottomNavigationButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scoutInteractiveScale(isPressed: configuration.isPressed, pressedScale: 0.97)
            .brightness(configuration.isPressed ? -0.03 : 0)
            .animation(ScoutMotion.press, value: configuration.isPressed)
    }
}

#Preview {
    ZStack {
        ScoutTheme.screenBackground.ignoresSafeArea()

        ScoutBottomNavigationBar(
            selectedTab: .feed,
            navigationStyle: .bar,
            visibility: .shown,
            chromeMode: .expanded,
            onSelect: { _ in },
            onToggleMenu: {}
        )
        .padding()
    }
}
