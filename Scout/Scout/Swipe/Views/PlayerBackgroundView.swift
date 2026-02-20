//
//  PlayerBackgroundView.swift
//  Scout
//
//  Created by Anna on 2/19/26.
//

import SwiftUI

struct PlayerBackgroundView: View {
    let imageURL: URL
    let color: Color
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottomLeading) {

                AsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: geo.size.width, height: geo.size.height)
                            .clipped()
                            .saturation(0)

                    case .empty:
                        ZStack {
                            Color.blue.opacity(0.2)
                            ProgressView()
                        }
                        .frame(width: geo.size.width, height: geo.size.height)

                    case .failure:
                        ZStack {
                            Color.red.opacity(0.2)
                            Text("Image failed to load")
                        }
                        .frame(width: geo.size.width, height: geo.size.height)

                    @unknown default:
                        Color.gray.opacity(0.2)
                            .frame(width: geo.size.width, height: geo.size.height)
                    }
                }

                LinearGradient(
                    colors: [.black.opacity(0.45), .clear, color.opacity(0.45)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(width: geo.size.width, height: geo.size.height)

                BottomTriangle()
                    .fill(color)
                    .frame(height: 300)
                    .frame(maxWidth: .infinity)
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .clipped()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview ("Background") {
    PlayerBackgroundView(imageURL: getRandomHeroHeaderViewModel().imageURL, color: Color.accent)
}
