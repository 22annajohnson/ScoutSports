//
//  SwipeArcOverlay.swift
//  Scout
//
//  Created by Anna on 2/19/26.
//

import SwiftUI

struct SwipeArcOverlay: View {
    let side: SwipeArcShape.Side
    let progress: CGFloat       // 0...1
    let color: Color
    let title: String

    var body: some View {
        ZStack {
            SwipeArcShape(progress: progress, side: side)
                .fill(color.opacity(0.92))
                .overlay(
                    SwipeArcShape(progress: progress, side: side)
                        .stroke(Color.scoutOnImageStroke, lineWidth: 1)
                )

            // Text sits near the arc edge
            if progress > 0.08 {
                VStack(spacing: 6) {
                    Text(title)
                        .font(.system(size: 28, weight: .black, design: .rounded))
                    Text(progress >= 1 ? "Release" : "Keep swiping")
                        .font(.system(size: 13, weight: .semibold))
                        .opacity(0.85)
                }
                .foregroundStyle(.white)
                .padding(.horizontal, 20)
                .frame(maxWidth: .infinity, maxHeight: .infinity,
                       alignment: side == .left ? .leading : .trailing)
                .padding(side == .left ? .leading : .trailing, 14)
                .opacity(Double(min(progress * 1.2, 1)))
            }
        }
        .allowsHitTesting(false)
    }
}

#Preview {
    SwipeArcOverlay(side: .right, progress: 0.9, color: .black, title: "Match")
}
