// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "FluxKit",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        // 顶层库，组合所有对外模块
        .library(
            name: "FluxKit",
            targets: ["FluxKit"]
        ),
        
        // 单独暴露的子库
        .library(
            name: "Placeholder",
            targets: ["Placeholder"]
        ),
    ],
    
    targets: [
        
        // 顶层库，组合子库
        .target(
            name: "FluxKit",
            dependencies: ["Placeholder"],
            path: "Sources/FluxKit/FluxKit" // 可以放一个空的模块文件夹，只做组合
        ),
        
        // 内部子库
        .target(
            name: "FluxNamespace",
            path: "Sources/FluxKit/Namespace"
        ),
        .target(
            name: "Placeholder",
            dependencies: ["FluxNamespace"], // 如果 Placeholder 依赖 FluxNamespace
            path: "Sources/FluxKit/Placeholder"
        )
    ]
)
