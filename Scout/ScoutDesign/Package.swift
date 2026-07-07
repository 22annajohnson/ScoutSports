// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "ScoutDesign",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "ScoutDesign",
            targets: ["ScoutDesign"]
        )
    ],
    targets: [
        .target(
            name: "ScoutDesign",
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "ScoutDesignTests",
            dependencies: ["ScoutDesign"]
        )
    ]
)
