import Foundation
#if canImport(librocksdb)
    import librocksdb
#endif
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

        case deleteFailed(message: String)

        case batchFailed(message: String)

        case dataNotConvertible
    }

    // MARK: - Properties

    public let path: URL

    public let prefix: String?

    private var isOpen = false

    private let dbOptions: OpaquePointer!
    private let writeOptions: OpaquePointer!
    private let readOptions: OpaquePointer!
    private let db: OpaquePointer!

    private var errorPointer: UnsafeMutablePointer<Int8>? = nil

    // MARK: - Initialization

    /// Initializes an instance of RocksDB to interact with the given database file.
    /// Creates the database file if it does not exist.
    ///
    /// - parameter path: The url to the database file on the filesystem.
    /// - parameter prefix: The prefix which will be appended to all keys for operations on this instance.
    ///
    /// - throws: If the database file cannot be opened (`RocksDB.Error.openFailed(message:)`)
    public init(path: URL, prefix: String? = nil) throws {
        self.path = path
        self.prefix = prefix

        self.dbOptions = rocksdb_options_create()
        let cpus = sysconf(Int32(_SC_NPROCESSORS_ONLN))

        // Optimize rocksdb
        rocksdb_options_increase_parallelism(dbOptions, Int32(cpus))
        rocksdb_options_optimize_level_style_compaction(dbOptions, 0)

        // create the DB if it's not already present
        rocksdb_options_set_create_if_missing(dbOptions, 1)

        // create writeoptions
        self.writeOptions = rocksdb_writeoptions_create()
        // create readoptions
        self.readOptions = rocksdb_readoptions_create()

        // Prefix
        if let prefix = prefix {
            rocksdb_options_set_prefix_extractor(dbOptions, rocksdb_slicetransform_create_fixed_prefix(prefix.count))
            rocksdb_readoptions_set_prefix_same_as_start(readOptions, 1)
        }

        // open DB
        self.db = rocksdb_open(dbOptions, path.path, &errorPointer)

        try throwIfError(err: &errorPointer, throwable: Error.openFailed)

        isOpen = true
    }

    deinit {
        if writeOptions != nil {
            rocksdb_writeoptions_destroy(writeOptions)
        }
        if readOptions != nil {
            rocksdb_readoptions_destroy(readOptions)
        }
        if dbOptions != nil {
            rocksdb_options_destroy(dbOptions)
        }
        if db != nil && isOpen {
            rocksdb_close(db)
        }
    }

    // MARK: - Helper functions

    /// Throws the given throwable Error if the given error pointer contains an error message.
    /// Passes the error message to the throwable function.
    ///
    /// - parameter err: The error to check.
    /// - parameter throwable: The throwable function which takes the error message and returns an Error which will be thrown.
    private func throwIfError(err: inout UnsafeMutablePointer<Int8>?, throwable: (_ str: String) -> Swift.Error) throws {
        if let pointee = err {
            let message = String(cString: pointee)

            // free and set error pointee to nil to be reusable later
            free(pointee)
            err = nil

            throw throwable(message)
        }
    }

    /// Returns the given key with the database prefix, if any.
    ///
    /// - parameter from: The key which should be prefixed.
    ///
    /// - returns: The prefixed key.
    private func getPrefixedKey(from key: String) -> String {
        var key = key
        if let prefix = prefix {
            key = "\(prefix)\(key)"
        }

        return key
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
        let key = getPrefixedKey(from: key)

        let cValue = [UInt8](value).map { uint8Val in
            return Int8(bitPattern: uint8Val)
        }

        rocksdb_put(db, writeOptions, key, strlen(key), cValue, cValue.count, &errorPointer)

        try throwIfError(err: &errorPointer, throwable: Error.putFailed)
    }

    /// Puts the given value encoded according to its definition into this database for the given key.
    /// Overwrites the key if it is already present.
    ///
    /// - parameter key: The key under which the value should be saved.
    /// - parameter value: The value which should be saved.
    ///
    /// - throws: If the write operation fails (`Error.putFailed(message:)`) and
    ///           if the given value is not convertible to Data (`Error.dataNotConvertible`)
    public func put<T: RocksDBValueRepresentable>(key: String, value: T) throws {
        try put(key: key, value: value.makeData())
    }

    /// Returns the value for the given key in the database.
    /// Returns empty Data if the key is not set in the database.
    ///
    /// - parameter key: The key to search the database for.
    ///
    /// - throws: If the get operation fails (`Error.getFailed(message:)`)
    public func get(key: String) throws -> Data {
        let key = getPrefixedKey(from: key)

        var len: Int = 0
        let returnValue = rocksdb_get(db, readOptions, key, strlen(key), &len, &errorPointer)

        try throwIfError(err: &errorPointer, throwable: Error.getFailed)

        let copy = Data(Array(UnsafeBufferPointer(start: returnValue, count: len)).map({ UInt8(bitPattern: $0) }))

        free(returnValue)

        return copy
    }

    /// Returns the value for the given key in the database initialized with the given type.
    ///
    /// The given type decides how to treat empty fields. Because the database returns an empty Data object
    /// if the key does not exist, `String` will for example be an empty String.
    ///
    /// - parameter type: The type to which the data should be converted.
    /// - parameter key: The key to search the database for.
    ///
    /// - throws: If the get operation fails (`Error.getFailed(message:)`) and
    ///           if the given type is not initializable from the data (`Error.dataNotConvertible`)
    public func get<T: RocksDBValueInitializable>(type: T.Type, key: String) throws -> T {
        return try type.init(data: get(key: key))
    }

    /// Deletes the given key in the database, if it is available.
    ///
    /// - parameter key: The key to delete.
    ///
    /// - throws: If the delete operation fails (`Error.deleteFailed(message:)`)
    public func delete(key: String) throws {
        let key = getPrefixedKey(from: key)

        rocksdb_delete(db, writeOptions, key, strlen(key), &errorPointer)

        try throwIfError(err: &errorPointer, throwable: Error.deleteFailed)
    }

    public func sequence<Key: RocksDBValueInitializable, Value: RocksDBValueInitializable>(
        keyType: Key.Type? = nil,
        valueType: Value.Type? = nil,
        gte: String? = nil
    ) -> RocksDBSequence<Key, Value> {
        return RocksDBSequence(iterator: RocksDBIterator(db: db, prefix: prefix, gte: gte, lte: nil))
    }

    public func sequence<Key: RocksDBValueInitializable, Value: RocksDBValueInitializable>(
        keyType: Key.Type? = nil,
        valueType: Value.Type? = nil,
        lte: String
    ) -> RocksDBSequence<Key, Value> {
        return RocksDBSequence(iterator: RocksDBIterator(db: db, prefix: prefix, gte: nil, lte: lte))
    }

    /// Write the given Operations as a batch update to the database.
    /// The operations will be executed in order as they appear in the given array.
    ///
    /// - parameter operations: The array of operations to execute in order as a batch.
    ///
    /// - throws: If the write operation fails (`Error.putFailed(message:)`)
    public func batch<Value: RocksDBValueConvertible>(operations: [RocksDBBatchOperation<Value>]) throws {
        let writeBatch = rocksdb_writebatch_create()

        for operation in operations {
            switch operation {
            case .delete(let key):
                let key = getPrefixedKey(from: key)
                rocksdb_writebatch_delete(writeBatch, key, strlen(key))
            case .put(let key, let value):
                let key = getPrefixedKey(from: key)
                let cValue = try [UInt8](value.makeData()).map { uint8Val in
                    return Int8(bitPattern: uint8Val)
                }
                rocksdb_writebatch_put(writeBatch, key, strlen(key), cValue, cValue.count)
            }
        }

        rocksdb_write(db, writeOptions, writeBatch, &errorPointer)

        try throwIfError(err: &errorPointer, throwable: Error.batchFailed)
    }
}

// MARK: - Iterator

public struct RocksDBSequence<K: RocksDBValueInitializable, V: RocksDBValueInitializable>: Sequence {

    private let iterator: RocksDBIterator<K, V>

    fileprivate init(iterator: RocksDBIterator<K, V>) {
        self.iterator = iterator
    }

    public __consuming func makeIterator() -> RocksDBIterator<K, V> {
        return iterator
    }
}

public class RocksDBIterator<K: RocksDBValueInitializable, V: RocksDBValueInitializable>: IteratorProtocol {

    private let readopts: OpaquePointer
    private let iterator: OpaquePointer

    private var isFirstIteration = true

    private var valid = true

    private var reversed = false

    /// Creates an iterator for the given instance of rocksdb.
    /// Either gte or lte can be set but not both.
    ///
    /// - parameter prefix: The prefix of the iter operation.
    /// - parameter gte: Search for keys greater than or equal the given (unprefixed).
    /// - parameter lte: Search for keys lower than or equal the given (unprefixed). Starts a reverse search.
    fileprivate init(db: OpaquePointer, prefix: String?, gte: String?, lte: String?) {
        self.readopts = rocksdb_readoptions_create()
        if let _ = prefix {
            rocksdb_readoptions_set_prefix_same_as_start(readopts, 1)
        }
//        if let gte = gte {
//            rocksdb_readoptions_set_iterate_lower_bound(readopts, gte, strlen(gte))
//        }
//        if let lte = lte {
//            rocksdb_readoptions_set_iterate_upper_bound(readopts, lte, strlen(lte))
//        }

        self.iterator = rocksdb_create_iterator(db, readopts)

        // Set prefixes to gte and lte
        var gtePrefixed: String? = nil
        if let gte = gte {
            gtePrefixed = "\(prefix ?? "")\(gte)"
        }
        var ltePrefixed: String? = nil
        if let lte = lte {
            ltePrefixed = "\(prefix ?? "")\(lte)"
        }

        // Seek to correct position and set reversed if needed
        if let gtePrefixed = gtePrefixed {
            rocksdb_iter_seek(iterator, gtePrefixed, strlen(gtePrefixed))
        } else if let ltePrefixed = ltePrefixed {
            rocksdb_iter_seek_for_prev(iterator, ltePrefixed, strlen(ltePrefixed))
            reversed = true
        } else if let prefix = prefix {
            rocksdb_iter_seek(iterator, prefix, strlen(prefix))
        } else {
            rocksdb_iter_seek_to_first(iterator)
        }
    }

    public func next() -> (key: K, value: V)? {
        if !valid {
            return nil
        }

        if isFirstIteration {
            isFirstIteration = false
        } else {
            if reversed {
                rocksdb_iter_prev(iterator)
            } else {
                rocksdb_iter_next(iterator)
            }
        }

        if rocksdb_iter_valid(iterator) == 0 {
            valid = false
            return nil
        }

        var klen: Int = 0
        let keyReturn = rocksdb_iter_key(iterator, &klen)
        let keyCopy = Data(Array(UnsafeBufferPointer(start: keyReturn, count: klen)).map({ UInt8(bitPattern: $0) }))
        guard let k = try? K.init(data: keyCopy) else {
            return nil
        }

        var vlen: Int = 0
        let valReturn = rocksdb_iter_value(iterator, &vlen)
        let valCopy = Data(Array(UnsafeBufferPointer(start: valReturn, count: vlen)).map({ UInt8(bitPattern: $0) }))
        guard let v = try? V.init(data: valCopy) else {
            return nil
        }

        return (key: k, value: v)
    }

    deinit {
        rocksdb_iter_destroy(iterator)
        rocksdb_readoptions_destroy(readopts)
    }
}

// MARK: - Internal functions

extension RocksDB {

    internal func closeDB() {
        if isOpen {
            rocksdb_close(db)
            isOpen = false
        }
    }
}
