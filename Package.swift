// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "skip",
    products: [
        .plugin(name: "skip", targets: ["SkipCommandPlugIn"])
    ],
    targets: [
        .plugin(name: "SkipBuildPlugIn",
            capability: .buildTool(), 
            dependencies: ["skiptool"]),
        .plugin(name: "SkipCommandPlugIn",
            capability: .command(
                intent: .custom(verb: "skip", 
                description: "Run Skip transpiler"),
                permissions: [
                    .writeToPackageDirectory(reason: "skip creates source files"),
                    //.allowNetworkConnections(scope: .all(ports: []), reason: "skip uses gradle to download dependendies from the network"), // awaiting Swift 5.9
                ]),
            dependencies: ["skiptool"]),
//        .executableTarget(name: "SkipCLI", plugins: ["skiptool"]),
//        .testTarget(name: "SkipCLITests", dependencies: ["SkipCLI"]),
    ]
)

package.targets += [.binaryTarget(name: "skiptool", url: "https://github.com/skipsource/skip/releases/download/0.0.24/skiptool.artifactbundle.zip", checksum: "3c61e026c178d4172007a36b3ca14459fe7c156f3cddd49dfa3c3b585eb070c7")]

