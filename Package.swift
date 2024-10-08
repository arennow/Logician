// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import CompilerPluginSupport
import PackageDescription

let package = Package(name: "Logician",
					  platforms: [.macOS(.v11), .iOS(.v14)],
					  products: [
					  	// Products define the executables and libraries a package produces, making them visible to other packages.
					  	.library(name: "Logician",
								   targets: ["Logician"]),
					  	.executable(name: "LogicianClient",
									  targets: ["LogicianClient"]),
					  ],
					  dependencies: [
					  	// Depend on the Swift 5.9 release of SwiftSyntax
					  	.package(url: "https://github.com/swiftlang/swift-syntax.git", from: "509.0.0"),
					  ],
					  targets: [
					  	// Targets are the basic building blocks of a package, defining a module or a test suite.
					  	// Targets can depend on other targets in this package and products from dependencies.
					  	// Macro implementation that performs the source transformation of a macro.
					  	.macro(name: "LogicianMacros",
								 dependencies: [
								 	.product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
								 	.product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
								 ]),

					  	// Library that exposes a macro as part of its API, which is used in client programs.
					  	.target(name: "Logician", dependencies: ["LogicianMacros"]),

					  	// A client of the library, which is able to use the macro in its own code.
					  	.executableTarget(name: "LogicianClient", dependencies: ["Logician"]),
					  ])
