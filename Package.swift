// swift-tools-version: 5.9

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "SwiftOptimization",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6),
        .macCatalyst(.v13)
    ],
    products: [
        .library(
            name: "SwiftOptimization",
            targets: ["SwiftOptimization"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-syntax.git", from: "509.0.0"),
    ],
    targets: [
        .target(
            name: "SwiftOptimization",
            dependencies: [
                "SwiftOptimizationMacros",
                "SwiftOptimizationSupport"
            ]
        ),
        .macro(
            name: "SwiftOptimizationMacros",
            dependencies: [
                "SwiftOptimizationSupport",
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),
        .target(name: "SwiftOptimizationSupport"),
        .testTarget(
            name: "SwiftOptimizationTests",
            dependencies: [
                "SwiftOptimization",
                "SwiftOptimizationMacros",
                "SwiftOptimizationSupport",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        ),
    ]
)
