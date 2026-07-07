//
//  TriangleView.swift
//  Scout
//
//  Created by Anna on 2/19/26.
//

import SwiftUI
import ScoutDesign

struct BottomTriangle: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()

        // Points
        let bottomLeft = CGPoint(x: rect.minX, y: rect.maxY)
        let bottomRight = CGPoint(x: rect.maxX, y: rect.maxY)
        let topRight = CGPoint(x: rect.maxX, y: rect.minY)

        // Tune this to adjust how "inward" the hypotenuse curves.
        // Higher values push the curve deeper into the triangle.
        let curveDepth: CGFloat = 0.6 // try 0.20 - 0.40

        // Build a control point that bows the hypotenuse inward toward the interior
        // (toward bottomRight). We take the midpoint of the hypotenuse and offset it
        // along the perpendicular direction toward bottomRight.
        let start = topRight
        let end = bottomLeft
        let mid = CGPoint(x: (start.x + end.x) / 2, y: (start.y + end.y) / 2)

        // Vector along the hypotenuse
        let vx = end.x - start.x
        let vy = end.y - start.y

        // A perpendicular vector
        var px = -vy
        var py = vx

        // Normalize perpendicular
        let plen = max(sqrt(px * px + py * py), 0.0001)
        px /= plen
        py /= plen

        // Choose the perpendicular direction that points toward bottomRight (interior)
        let toInteriorX = bottomRight.x - mid.x
        let toInteriorY = bottomRight.y - mid.y
        let dot = px * toInteriorX + py * toInteriorY
        if dot < 0 {
            px *= -1
            py *= -1
        }

        // Offset distance in points
        let offset = min(rect.width, rect.height) * curveDepth
        let control = CGPoint(x: mid.x + px * offset, y: mid.y + py * offset)

        p.move(to: bottomLeft)
        p.addLine(to: bottomRight)
        p.addLine(to: topRight)
        p.addQuadCurve(to: bottomLeft, control: control)
        p.closeSubpath()
        return p
    }
}

#Preview {
    ZStack {
        BottomTriangle()
            .fill(.blue.opacity(0.7))
        BottomTriangle()
            .stroke(.white, lineWidth: 2)
    }
    .frame(width: 300, height: 180)
    .padding()
}
