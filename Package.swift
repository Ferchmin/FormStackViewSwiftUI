// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FormStackView",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "FormStackView", targets: ["FormStackView"])
    ],
    dependencies: [],
    targets: [
        .target(name: "FormStackView",
                dependencies: [],
                path: "FormStackView/Sources")
    ]
)
