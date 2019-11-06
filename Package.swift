// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MaterialKit",
    platforms: [.iOS(.v8)],
    products: [
        .library(
            name: "MaterialKit",
            targets: ["MaterialKit"]),
    ],
    targets: [
        .target(
            name: "MaterialKit",
            dependencies: [],
            path: "Source"),
    ],
    swiftLanguageVersions: [.v4, .v4_2, .v5]
)
