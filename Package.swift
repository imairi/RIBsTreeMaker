// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "RIBsTreeMaker",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .executable(name: "RIBsTreeMaker", targets: ["RIBsTreeMaker"])
    ],
    dependencies: [
        .package(url: "https://github.com/jpsim/SourceKitten", from: "0.22.0"),
        .package(url: "https://github.com/kylef/PathKit", from: "1.0.1"),
        .package(url: "https://github.com/onevcat/Rainbow", from: "3.0.0")
    ],
    targets: [
        .target(
            name: "RIBsTreeMaker",
            dependencies: [
                .product(name: "SourceKittenFramework", package: "SourceKitten"),"PathKit", "Rainbow"]
        )
    ]
)
