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
            ZStack {
                AsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: geo.size.width, height: geo.size.height)
                            .clipped()
                            .saturation(0.82)
                            .overlay {
                                LinearGradient(
                                    colors: [
                                        Color.black.opacity(0.10),
                                        Color.clear,
                                        Color.black.opacity(0.34)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            }

                    case .empty:
                        ZStack {
                            ScoutTheme.screenBackground
                            ProgressView()
                        }
                        .frame(width: geo.size.width, height: geo.size.height)

                    case .failure:
                        ZStack {
                            ScoutTheme.screenBackground
                            Text("Image failed to load")
                                .font(.scoutBody)
                                .foregroundStyle(Color.scoutTextSecondary)
                        }
                        .frame(width: geo.size.width, height: geo.size.height)

                    @unknown default:
                        ScoutTheme.screenBackground
                            .frame(width: geo.size.width, height: geo.size.height)
                    }
                }

                LinearGradient(
                    colors: [
                        Color.black.opacity(0.18),
                        Color.clear,
                        color.opacity(0.30)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(width: geo.size.width, height: geo.size.height)
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .clipped()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(ScoutTheme.screenBackground)
        .ignoresSafeArea()
    }
}

#Preview ("Background") {
    PlayerBackgroundView(imageURL: getRandomHeroHeaderViewModel().imageURL, color: Color.scoutAccentStart)
}
