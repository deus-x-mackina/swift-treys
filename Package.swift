// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "swift-treys",
  products: [
    .library(
      name: "SwiftTreys",
      targets: ["SwiftTreys"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-algorithms.git", .upToNextMinor(from: "0.0.4")),
  ],
  targets: [
    .target(
      name: "SwiftTreys",
      dependencies: [
        .product(name: "Algorithms", package: "swift-algorithms"),
      ]
    ),
    .testTarget(
      name: "SwiftTreysTests",
      dependencies: [
        "SwiftTreys",
        .product(name: "Algorithms", package: "swift-algorithms"),
      ]
    ),
  ]
)
