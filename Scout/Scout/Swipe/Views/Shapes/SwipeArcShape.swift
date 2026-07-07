//
//  SwipeArcShape.swift
//  Scout
//
//  Created by Anna on 2/19/26.
//

import SwiftUI
import ScoutDesign

struct SwipeArcShape: Shape {
    enum Side { case left, right }

    var progress: CGFloat   // 0...1
    var side: Side

    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }

    func path(in rect: CGRect) -> Path {
        let p = max(0, min(progress, 1))

        let w = rect.width
        let h = rect.height
        let midY = rect.midY

        // How far the shape intrudes at full swipe
        let maxInset = w * 0.55
        let inset = maxInset * p

        // Blend factor: 0 = simple arc, 1 = bell curve
        // Keep it arc-y early, then transition to bell as you commit.
        func smoothstep(_ a: CGFloat, _ b: CGFloat, _ x: CGFloat) -> CGFloat {
            let t = max(0, min((x - a) / (b - a), 1))
            return t * t * (3 - 2 * t)
        }
        let t = smoothstep(0.12, 0.85, p)

        // Simple arc component: semi-ellipse (classic arc look)
        func arcProfile(y: CGFloat) -> CGFloat {
            let ny = (y - midY) / (h / 2) // [-1, 1]
            let v = max(0, 1 - ny * ny)
            return sqrt(v) // 0 at ends, 1 at center
        }

        // Bell curve component: Gaussian with wide shoulders (matches reference)
        func bellProfile(y: CGFloat) -> CGFloat {
            let ny = (y - midY) / (h / 2) // [-1, 1]
            let sigma: CGFloat = 0.55
            return exp(-(ny * ny) / (2 * sigma * sigma))
        }

        func profile(y: CGFloat) -> CGFloat {
            (1 - t) * arcProfile(y: y) + t * bellProfile(y: y)
        }

        // Sample the curve for a smooth outline
        let samples = 72
        var curvePoints: [CGPoint] = []
        curvePoints.reserveCapacity(samples + 1)

        for i in 0...samples {
            let yy = h * CGFloat(i) / CGFloat(samples)
            let amp = inset * profile(y: yy)
            let xx: CGFloat = (side == .left) ? amp : (w - amp)
            curvePoints.append(CGPoint(x: xx, y: yy))
        }

        var path = Path()

        if side == .left {
            // Fill from left edge to the curve
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: 0, y: h))
            // Go along the curve from bottom -> top
            for pt in curvePoints.reversed() {
                path.addLine(to: pt)
            }
            path.closeSubpath()
        } else {
            // Fill from right edge to the curve
            path.move(to: CGPoint(x: w, y: 0))
            path.addLine(to: CGPoint(x: w, y: h))
            // Go along the curve from bottom -> top
            for pt in curvePoints.reversed() {
                path.addLine(to: pt)
            }
            path.closeSubpath()
        }

        return path
    }
}
