// swift-tools-version:5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MangaDexLib",
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [
        .library(name: "MangaDexLib", targets: ["MangaDexLib"])
    ],
    targets: [
        .target(name: "MangaDexLib", path: "Sources"),
        .testTarget(name: "MangaDexLibTests", dependencies: ["MangaDexLib"])
    ]
)
