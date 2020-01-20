# :rocket: rocksdb.swift

[![Build Status](https://travis-ci.com/Ybrin/rocksdb.swift.svg?branch=master)](https://travis-ci.com/Ybrin/rocksdb.swift)
[![codecov](https://codecov.io/gh/Ybrin/rocksdb.swift/branch/master/graph/badge.svg)](https://codecov.io/gh/Ybrin/rocksdb.swift)

This library provides Swift bindings for rocksdb as well as Swifty bindings.

## Compatibility

You can use this library with Swift Package Manager and Cocoapods on iOS, macOS, tvOS, watchOS and Linux.

## Installation

### CocoaPods

RocksDB is available through [CocoaPods](http://cocoapods.org/). To install it, simply add the following line to your Podfile:

```Ruby
pod 'rocksdb.swift'
```

### Swift Package Manager

RocksDB is compatible with Swift Package Manager (Swift 5 and above). Simply add it to the dependencies in your Package.swift.

```Swift
dependencies: [
    .package(url: "https://github.com/Ybrin/rocksdb.swift.git", from: "6.4.15")
]
```

And then add it to your target dependencies:

```Swift
targets: [
    .target(
        name: "MyProject",
        dependencies: ["RocksDB"]),
    .testTarget(
        name: "MyProjectTests",
        dependencies: ["MyProject"])
]
```

After the installation you can import RocksDB in your .swift files.

```Swift
import Web3
```

## Usage

For now, check out the tests for examples on how to use this wrapper. Contributions to add more examples are happily welcome.

## Versioning

Major and Minor Version numbers are kept in sync with the upstream rocksdb library. Patch version varies.

## License

rocksdb.swift is available under the MIT license. Copyright for rocksdb belongs to facebook.
