// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "Jaeger",
    platforms: [
        .macOS(.v10_12), .iOS(.v13), .watchOS(.v6), .tvOS(.v13)
    ],
    products: [
        .library(
            name: "Jaeger",
            targets: ["Jaeger"]),
    ],
    dependencies: [

    ],
    targets: [
        .target(
            name: "Jaeger",
            dependencies: []
        ),
        .testTarget(
            name: "JaegerTests",
            dependencies: ["Jaeger"]
        ),
    ]
)
