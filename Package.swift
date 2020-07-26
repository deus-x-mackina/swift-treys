// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-treys",
    products: [
        .library(
            name: "SwiftTreys",
            targets: ["SwiftTreys"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SwiftTreys",
            dependencies: []),
        .testTarget(
            name: "SwiftTreysTests",
            dependencies: ["SwiftTreys"]),
    ]
)
