// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Recipes",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "Recipes",
            targets: ["Recipes"]),
    ],
    dependencies: [
        .package(path: "../Common"),
        .package(path: "../Network"),
        .package(path: "../Biometric"),
    ],
    targets: [
        .target(
            name: "Recipes",
            dependencies: [
                "Common",
                "Network",
                "Biometric"
            ],
            resources: [
                .process("Resources")
            ]
        ),
    ]
)
