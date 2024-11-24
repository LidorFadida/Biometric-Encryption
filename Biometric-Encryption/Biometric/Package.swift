// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Biometric",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "Biometric",
            targets: ["Biometric"]),
    ],
    dependencies: [
        .package(path: "../Network"),
    ],
    targets: [
        .target(
            name: "Biometric",
            dependencies: [
                "Network"
            ],
            swiftSettings: [
                .unsafeFlags(["-Xfrontend", "-disable-actor-data-race-checks"])
            ]
        ),
    ]
)
