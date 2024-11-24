// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Common",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "Common",
            targets: ["Common"]),
    ],
    dependencies: [
        .package(url: "https://github.com/SDWebImage/SDWebImageSwiftUI.git", from: "3.0.0"),
        .package(path: "../Extensions"),
    ],
    targets: [
        .target(
            name: "Common",
            dependencies: [
                "Extensions",
                .product(name: "SDWebImageSwiftUI", package: "SDWebImageSwiftUI")
            ]
        ),
    ]
)
