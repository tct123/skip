// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "skip",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
        .tvOS(.v16),
        .watchOS(.v9),
        .macCatalyst(.v16),
    ],
    products: [
        .executable(name: "skip", targets: ["skip"]),
        .plugin(name: "skipstone", targets: ["skipstone"]),
        .library(name: "SkipDrive", targets: ["SkipDrive"]),
        .library(name: "SkipTest", targets: ["SkipTest"]),
    ],
    targets: [
        .plugin(name: "skipstone", capability: .buildTool(), dependencies: ["skip"], path: "Plugins/SkipPlugin"),
        .target(name: "SkipDrive", dependencies: ["skipstone", .target(name: "skip")]),
        .target(name: "SkipTest", dependencies: [.target(name: "SkipDrive", condition: .when(platforms: [.macOS]))]),
        .testTarget(name: "SkipTestTests", dependencies: ["SkipTest"]),
        .testTarget(name: "SkipDriveTests", dependencies: ["SkipDrive"]),
        .binaryTarget(name: "skip", url: "https://source.skip.tools/skip/releases/download/0.7.42/skip.zip", checksum: "c1d958f63e28f6c55fc05b2ddff82dbe11cbaaff54ba66f1da98ba4dbdadbf0d")
    ]
)

import Foundation
if (ProcessInfo.processInfo.environment["PWD"]?.hasSuffix("skipstone") == true || ProcessInfo.processInfo.environment["SKIPLOCAL"] != nil) {
    package.dependencies = package.dependencies.dropLast() + [.package(path: "../skipstone")]
    package.targets = package.targets.dropLast() + [.executableTarget(name: "skip", dependencies: [.product(name: "SkipBuild", package: "skipstone")])]
}
