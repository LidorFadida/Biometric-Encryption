// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RecipeApplication",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "RecipeApplication",
            targets: ["RecipeApplication"]),
    ],
    dependencies: [
        .package(path: ".../Recipes")
    ],
    targets: [
        .target(
            name: "RecipeApplication",
            dependencies: [
                "Recipes"
            ],
            swiftSettings: [
                .unsafeFlags(["-Xfrontend", "-disable-actor-data-race-checks"])
            ]
        ),
    ]
)
