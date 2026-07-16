// swift-tools-version: 5.9

import PackageDescription

let package = Package(
  name: "IposgoSDK",
  platforms: [
    .iOS(.v16),
  ],
  products: [
    .library(name: "IposgoSDK", targets: ["IposgoSDK"]),
  ],
  targets: [
    .binaryTarget(
      name: "IposgoSDK",
      path: "IceCream/IposgoSDK.xcframework"
    ),
  ]
)
