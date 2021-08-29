// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SJDatabaseService",
    platforms: [.iOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SJDatabaseService",
            targets: ["SJDatabaseService"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(name: "SJUtil", url: "https://github.com/SabrinaJiang14/SJUtil.git", .branch("main")),
        .package(name: "Realm", url: "https://github.com/realm/realm-cocoa.git", .upToNextMajor(from: "10.7.5"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        //dependencies: [.product(name: "RealmSwift", package: "Realm")]),
        .target(
            name: "SJDatabaseService",
            dependencies: ["SJUtil",
                           .product(name: "RealmSwift", package: "Realm")]),
        .testTarget(
            name: "SJDatabaseServiceTests",
            dependencies: ["SJDatabaseService"]),
    ]
)
