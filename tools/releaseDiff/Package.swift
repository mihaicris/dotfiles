// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ReleaseDiff",
    platforms: [.macOS(.v13)],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.0"),
        .package(url: "https://github.com/JohnSundell/ShellOut.git", from: "2.3.0"),
        .package(url: "https://github.com/onevcat/Rainbow.git", from: "4.0.0")
    ],
    targets: [
        .executableTarget(
            name: "ReleaseDiff",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "Rainbow", package: "Rainbow"),
                .product(name: "ShellOut", package: "ShellOut"),
            ])
    ]
)
