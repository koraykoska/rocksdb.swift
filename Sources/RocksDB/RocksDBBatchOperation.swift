//
//  RocksDBBatchOperation.swift
//  RocksDB
//
//  Created by Koray Koska on 29.11.19.
//

import Foundation

public enum RocksDBBatchOperation<T: RocksDBValueConvertible> {

    /// A delete operation for the given key
    case delete(key: String)

    /// A put operation for the given key and value
    case put(key: String, value: T)
}
