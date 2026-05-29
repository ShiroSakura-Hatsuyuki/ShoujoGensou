// swift-tools-version: 6.3

import PackageDescription

let package = Package(
    name: "YukariYuyuko",
    products:[
        .executable(
            name:"YukariYuyuko",targets:["YukariYuyuko"]
        )
    ],
    targets: [
        .executableTarget(
            name: "YukariYuyuko",
            dependencies: [
                .target(name: "Yukari2SCaeKriMoYhEn7")

            ],
            path: "Source/YukariYuyuko",
            swiftSettings: [
                .interoperabilityMode(.Cxx)
            ]
        ),
        .target(
            name: "Yukari2SCaeKriMoYhEn7", //YukariSakuraShizukuCaedeYuki/YuriMoZomeYoohuaEn 紫樱雫枫雪百合墨染幽华缘
            dependencies: [

            ],
            path: "Source/Yukari2SCaeKriMoYhEn7",
            swiftSettings: [
                .interoperabilityMode(.Cxx)
            ]
        ),
    ],


    swiftLanguageModes: [.v6]
)
