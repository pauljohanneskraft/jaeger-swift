// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "Jaeger",
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
