//
//  RocksDBValueConvertible.swift
//  RocksDB
//
//  Created by Koray Koska on 18.11.19.
//

import Foundation

public protocol RocksDBValueInitializable {

    /// Initializes this instance from the raw data from RocksDB.
    ///
    /// - parameter data: The data from RocksDB.
    ///
    /// - throws: `RocksDB.Error.dataNotConvertible` iff the given data is invalid to represent this type.
    init(data: Data) throws
}

public protocol RocksDBValueRepresentable {

    /// Prepares this instance to be saved in RocksDB.
    /// Returns this instance encoded to raw Data.
    ///
    /// - throws: `RocksDB.Error.dataNotConvertible` iff this instance cannot be encoded to raw Data.
    func makeData() throws -> Data
}

public typealias RocksDBValueConvertible = RocksDBValueInitializable & RocksDBValueRepresentable

extension String: RocksDBValueConvertible {

    public init(data: Data) throws {
        if let string = String(data: data, encoding: .utf8) {
            self = string
        } else {
            throw RocksDB.Error.dataNotConvertible
        }
    }

    public func makeData() throws -> Data {
        if let data = data(using: .utf8) {
            return data
        } else {
            throw RocksDB.Error.dataNotConvertible
        }
    }
}

