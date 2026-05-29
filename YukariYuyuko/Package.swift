// swift-tools-version: 6.3

import PackageDescription

let package = Package(
    name: "YukariYuyuko",
    targets: [
        .executableTarget(
            name: "YukariYuyuko",
            path: "Source/YukariYuyuko"
        )
    ],
    swiftLanguageModes: [.v6]
)
