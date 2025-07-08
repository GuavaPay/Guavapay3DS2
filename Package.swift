// swift-tools-version:5.3
//The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Guavapay3DS2",
    defaultLocalization: "en",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "Guavapay3DS2",
            targets: ["Guavapay3DS2"]
        ),
        .library(
            name: "SwiftGuavapay3DS2",
            targets: ["SwiftGuavapay3DS2"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Guavapay3DS2",
            path: "Guavapay3DS2/Guavapay3DS2",
            exclude: ["Info.plist", "include/Guavapay3DS2-Prefix.pch"],
            resources: [
                .process("Resources"),
                .process("PrivacyInfo.xcprivacy")
            ],
            cSettings: [
                .headerSearchPath("."),
                .headerSearchPath("Extensions")
            ]
        ),
        .target(
            name: "SwiftGuavapay3DS2",
            dependencies: ["Guavapay3DS2"],
            path: "Guavapay3DS2/SwiftGuavapay3DS2"
        )
    ]
)
