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
                .target(name: "Yukari2SCaeKriMoYhEn7"), .target(name: "Arti")
            ],
            path: "Source/YukariYuyuko",
            swiftSettings: [
                .interoperabilityMode(.Cxx)
            ]
        ),
        .target(
            name: "Yukari2SCaeKriMoYhEn7", //YukariSakuraShizukuCaedeYuki/YuriMoZomeYoohuaEn 紫樱雫枫雪百合墨染幽华缘
            dependencies: [
                .target(name: "Arti")
            ],
            path: "Source/Yukari2SCaeKriMoYhEn7",
            swiftSettings: [
                .interoperabilityMode(.Cxx)
            ]
        ),
        .target(
            name: "Arti",
            path: "Source/Arti",
            publicHeadersPath: ".",
            cxxSettings: [

            ],
            linkerSettings: [
                .unsafeFlags(linkArti)
            ]
        )
    ],
    swiftLanguageModes: [.v6],
    cLanguageStandard: .c11,
    cxxLanguageStandard: .cxx17
)

/*
改为将头文件放入 Swift Package Manager 内部 /Arti 解决方案。
var libraryArti: [String] {
    return [
        "-I", "./relyonirai/Arti/include"
    ]
}
*/

var linkArti: [String] {
    return [
            "-L", "./Irai/Arti/lib",
            "-l","CoreArti",
    ]
}