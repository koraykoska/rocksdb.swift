import Foundation
import librocksdb
#if os(Linux)
import Glibc
#else
import Darwin
#endif

public final class RocksDB {

    // MARK: - Errors

    public enum Error: Swift.Error {

        case openFailed(message: String)

        case putFailed(message: String)

        case getFailed(message: String)

        case dataNotConvertible
    }

    // MARK: - Properties

    public let path: URL

    private let dbOptions: OpaquePointer!
    private let writeOptions: OpaquePointer!
    private let readOptions: OpaquePointer!
    private let db: OpaquePointer!

    private var errorPointer: UnsafeMutablePointer<UnsafeMutablePointer<Int8>?> = UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>.allocate(capacity: 1)

    // MARK: - Initialization

    /// Initializes an instance of RocksDB to interact with the given database file.
    /// Creates the database file if it does not exist.
    ///
    /// - parameter path: The url to the database file on the filesystem.
    ///
    /// - throws: If the database file cannot be opened (`RocksDB.Error.openFailed(message:)`)
    public init(path: URL) throws {
        self.path = path

        self.dbOptions = rocksdb_options_create()
        let cpus = sysconf(_SC_NPROCESSORS_ONLN)

        // Optimize rocksdb
        rocksdb_options_increase_parallelism(dbOptions, Int32(cpus))
        rocksdb_options_optimize_level_style_compaction(dbOptions, 0)

        // create the DB if it's not already present
        rocksdb_options_set_create_if_missing(dbOptions, 1)

        // create writeoptions
        self.writeOptions = rocksdb_writeoptions_create()
        // create readoptions
        self.readOptions = rocksdb_readoptions_create()

        // open DB
        self.db = rocksdb_open(dbOptions, path.path, errorPointer)

        try throwIfError(err: errorPointer, throwable: Error.openFailed)
    }

    deinit {
        rocksdb_writeoptions_destroy(writeOptions)
        rocksdb_readoptions_destroy(readOptions)
        rocksdb_options_destroy(dbOptions)
        rocksdb_close(db)

        free(errorPointer)
    }

    // MARK: - Helper functions

    /// Throws the given throwable Error if the given error pointer contains an error message.
    /// Passes the error message to the throwable function.
    ///
    /// - parameter err: The error to check.
    /// - parameter throwable: The throwable function which takes the error message and returns an Error which will be thrown.
    private func throwIfError(err: UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>, throwable: (_ str: String) -> Swift.Error) throws {
        if let pointee = err.pointee {
            let message = String(cString: pointee)

            // free and set error pointee to nil to be reusable later
            free(pointee)
            err.pointee = nil

            throw throwable(message)
        }
    }

    // MARK: - Library functions

    /// Puts the given value into this database for the given key.
    /// Overwrites the key if it is already present.
    ///
    /// - parameter key: The key under which the value should be saved.
    /// - parameter value: The data which should be saved.
    ///
    /// - throws: If the write operation fails (`Error.putFailed(message:)`)
    public func put(key: String, value: Data) throws {
        let cValue = [UInt8](value).map { uint8Val in
            return Int8(bitPattern: uint8Val)
        }

        rocksdb_put(db, writeOptions, key, strlen(key), cValue, cValue.count, errorPointer)

        try throwIfError(err: errorPointer, throwable: Error.putFailed)
    }

    /// Puts the given value as a string into this database for the given key.
    /// Overwrites the key if it is already present.
    ///
    /// - parameter key: The key under which the value should be saved.
    /// - parameter value: The string which should be saved.
    ///
    /// - throws: If the given value is not convertible to Data (`Error.dataNotConvertible`) and
    ///           if the write operation fails (`Error.putFailed(message:)`)
    public func put(key: String, value: String) throws {
        if let dataValue = value.data(using: .utf8) {
            try put(key: key, value: dataValue)
        } else {
            throw Error.dataNotConvertible
        }
    }

    /// Returns the value for the given key in the database.
    ///
    /// - parameter key: The key to search the database for.
    ///
    /// - throws: If the get operation fails (`Error.getFailed(message:)`)
    public func get(key: String) throws -> Data {
        var len: Int = 0
        let returnValue = rocksdb_get(db, readOptions, key, strlen(key), &len, errorPointer)

        try throwIfError(err: errorPointer, throwable: Error.getFailed)

        let copy = Data(Array(UnsafeBufferPointer(start: returnValue, count: len)).map({ UInt8(bitPattern: $0) }))

        free(returnValue)

        return copy
    }
}
