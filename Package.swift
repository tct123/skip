// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "skip",
    defaultLocalization: "en",
    platforms: [.iOS(.v15), .macOS(.v12), .tvOS(.v15), .watchOS(.v8), .macCatalyst(.v15)],
    products: [
        .plugin(name: "skip", targets: ["SkipCommandPlugIn"]),
        .plugin(name: "preflight", targets: ["SkipPreflightPlugIn"]),
        .plugin(name: "transpile", targets: ["SkipTranspilePlugIn"]),
        .library(name: "SkipDriver", targets: ["SkipDriver"])
    ],
    dependencies: [
    ],
    targets: [
        .target(name: "SkipDriver", dependencies: ["skiptool"]),
        .testTarget(name: "SkipDriverTests", dependencies: ["SkipDriver"]),

        .plugin(name: "SkipPreflightPlugIn", capability: .buildTool(), dependencies: ["skiptool"]),
        .plugin(name: "SkipTranspilePlugIn", capability: .buildTool(), dependencies: ["skiptool"]),

        .plugin(name: "SkipCommandPlugIn",
            capability: .command(
                intent: .custom(verb: "skip",  description: "Skip Info"),
                permissions: [
                    .writeToPackageDirectory(reason: "Skip needs to have access to the project folder to create and update generated source files."),
                ]),
            dependencies: ["skiptool"]),
    ]
)

import class Foundation.ProcessInfo
if let localPath = ProcessInfo.processInfo.environment["SKIPLOCAL"] {
    // build against the local relative packages in the peer folders by running: SKIPLOCAL=.. xed Skip.xcworkspace
    package.dependencies += [.package(path: localPath + "/SkipSource")]
    package.targets += [.executableTarget(name: "skiptool", dependencies: [.product(name: "SkipBuild", package: "SkipSource")], path: "Sources/SkipTool", sources: ["skiptool.swift"])]
} else {
    // default to using the latest binary skiptool release
    package.targets += [.binaryTarget(name: "skiptool", url: "https://github.com/skiptools/skip/releases/download/0.3.0/skiptool.artifactbundle.zip", checksum: "6ea18fa14d19e1e2d18e7b72766e566bb195323aca9806521297abb5b22024e4")]
}
