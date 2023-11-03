# SwiftOptimization

A Swift library to set optimization levels for members on a per-type basis.

<!-- # Badges -->

[![Github issues](https://img.shields.io/github/issues/p-x9/swift-optimization)](https://github.com/p-x9/swift-optimization/issues)
[![Github forks](https://img.shields.io/github/forks/p-x9/swift-optimization)](https://github.com/p-x9/swift-optimization/network/members)
[![Github stars](https://img.shields.io/github/stars/p-x9/swift-optimization)](https://github.com/p-x9/swift-optimization/stargazers)
[![Github top language](https://img.shields.io/github/languages/top/p-x9/swift-optimization)](https://github.com/p-x9/swift-optimization/)

## What is Optimization level

Swift programs are optimized at compile time.
There are multiple levels of this optimization.
For example, use the following:

```sh
swiftc -Onone main.swift
```

For Xcode projects, this can be set from the `Optimization Level` item in the `Build Settings` section.
[Enabling Optimizations](https://github.com/apple/swift/blob/3094e661f51c9190ba9da2c3ef60cff80e28fa8d/docs/OptimizationTips.rst#id13)

The above example shows how to specify the optimization level for the entire program.
A method for setting optimization levels on a per-function basis is also provided.
[@_optimize([none|size|speed])](https://github.com/apple/swift/blob/main/docs/ReferenceGuides/UnderscoredAttributes.md#_optimizenonesizespeed)
An example is shown below.

```swift
@_optimize(none)
func hello() {
    print("Hello")
}
```

This attribute can be added only to functions or computed properties.
There does not seem to be a method provided to set it on a type-by-type basis, such as class or struct.

The `@Optimize` macro provided in this library allows the optimization level to be set on a per-type basis.

## Usage

Simply add the @Optimize macro to the type declaration as follows.

```swift
@Optimize(.size)
struct Item {
    var _hello: String
    var hello: String {
        get { _hello }
        set { _hello = newValue }
    }
    func printHello() {
        print(hello)
    }
}
```

It will be expanded as follows.

```swift
struct Item {
    var _hello: String
    @_optimize(size)
    var hello: String {
        get { _hello }
        set { _hello = newValue }
    }
    @_optimize(size)
    func printHello() {
        print(hello)
    }
}
```

## License

SwiftOptimization is released under the MIT License. See [LICENSE](./LICENSE)
