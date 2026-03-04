// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Browse",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "Browse",
            targets: ["Browse"]
        )
    ],
    targets: [
        .target(
            name: "Browse",
            dependencies: []
        )
    ]
)
