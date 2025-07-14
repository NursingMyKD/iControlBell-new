// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "iControlBell",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .executable(name: "iControlBell", targets: ["iControlBell"])
    ],
    targets: [
        .executableTarget(
            name: "iControlBell",
            path: "iControlBell"
        )
    ]
)
