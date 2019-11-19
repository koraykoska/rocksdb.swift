import XCTest
@testable import RocksDB

final class RocksDBTests: XCTestCase {

    var rocksDB: RocksDB!

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testSimplePut() {
        let path = "/tmp/\(UUID().uuidString)"
        rocksDB = try! RocksDB(path: URL(fileURLWithPath: path))

        try! rocksDB.put(key: "testText", value: "lolamkhaha")
        try! rocksDB.put(key: "testEmoji", value: "😂")
        try! rocksDB.put(key: "testTextEmoji", value: "emojitext 😂")
        try! rocksDB.put(key: "testMultipleEmoji", value: "😂😂😂")

        XCTAssertEqual(try! rocksDB.get(type: String.self, key: "testText"), "lolamkhaha")
        XCTAssertEqual(try! rocksDB.get(type: String.self, key: "testEmoji"), "😂")
        XCTAssertEqual(try! rocksDB.get(type: String.self, key: "testTextEmoji"), "emojitext 😂")
        XCTAssertEqual(try! rocksDB.get(type: String.self, key: "testMultipleEmoji"), "😂😂😂")

        rocksDB.closeDB()

        try! FileManager.default.removeItem(at: rocksDB.path)
    }

    func testSimpleDelete() {
        let path = "/tmp/\(UUID().uuidString)"
        rocksDB = try! RocksDB(path: URL(fileURLWithPath: path))

        try! rocksDB.put(key: "testDeleteKey", value: "this is a simple value 😘")
        try! rocksDB.delete(key: "testDeleteKey")

        XCTAssertEqual(try! rocksDB.get(type: String.self, key: "testDeleteKey"), "")

        rocksDB.closeDB()

        try! FileManager.default.removeItem(at: rocksDB.path)
    }

    func testPrefixedPut() {
        let prefixedPath = "/tmp/\(UUID().uuidString)"

        let prefixedDB = try! RocksDB(path: URL(fileURLWithPath: prefixedPath), prefix: "correctprefix")

        try! prefixedDB.put(key: "testText", value: "lolamkhaha")
        try! prefixedDB.put(key: "testEmoji", value: "😂")
        try! prefixedDB.put(key: "testTextEmoji", value: "emojitext 😂")
        try! prefixedDB.put(key: "testMultipleEmoji", value: "😂😂😂")

        XCTAssertEqual(try! prefixedDB.get(type: String.self, key: "testText"), "lolamkhaha")
        XCTAssertEqual(try! prefixedDB.get(type: String.self, key: "testEmoji"), "😂")
        XCTAssertEqual(try! prefixedDB.get(type: String.self, key: "testTextEmoji"), "emojitext 😂")
        XCTAssertEqual(try! prefixedDB.get(type: String.self, key: "testMultipleEmoji"), "😂😂😂")

        prefixedDB.closeDB()

        let wrongPrefixedDB = try! RocksDB(path: URL(fileURLWithPath: prefixedPath), prefix: "wrongprefix")

        XCTAssertEqual(try! wrongPrefixedDB.get(type: String.self, key: "testText"), "")
        XCTAssertEqual(try! wrongPrefixedDB.get(type: String.self, key: "testEmoji"), "")
        XCTAssertEqual(try! wrongPrefixedDB.get(type: String.self, key: "testTextEmoji"), "")
        XCTAssertEqual(try! wrongPrefixedDB.get(type: String.self, key: "testMultipleEmoji"), "")

        wrongPrefixedDB.closeDB()

        let prefixedDB2 = try! RocksDB(path: URL(fileURLWithPath: prefixedPath), prefix: "correctprefix")

        XCTAssertEqual(try! prefixedDB2.get(type: String.self, key: "testText"), "lolamkhaha")
        XCTAssertEqual(try! prefixedDB2.get(type: String.self, key: "testEmoji"), "😂")
        XCTAssertEqual(try! prefixedDB2.get(type: String.self, key: "testTextEmoji"), "emojitext 😂")
        XCTAssertEqual(try! prefixedDB2.get(type: String.self, key: "testMultipleEmoji"), "😂😂😂")

        prefixedDB2.closeDB()

        try! FileManager.default.removeItem(at: wrongPrefixedDB.path)
    }

    func testPrefixedDelete() {
        let prefixedPath = "/tmp/\(UUID().uuidString)"

        let prefixedDB = try! RocksDB(path: URL(fileURLWithPath: prefixedPath), prefix: "correctprefix")

        try! prefixedDB.put(key: "testText", value: "lolamkhaha")
        try! prefixedDB.put(key: "testEmoji", value: "😂")
        try! prefixedDB.put(key: "testTextEmoji", value: "emojitext 😂")
        try! prefixedDB.put(key: "testMultipleEmoji", value: "😂😂😂")

        prefixedDB.closeDB()

        let wrongPrefixedDB = try! RocksDB(path: URL(fileURLWithPath: prefixedPath), prefix: "wrongprefix")

        try! wrongPrefixedDB.put(key: "testText", value: "lolamkhaha")
        try! wrongPrefixedDB.put(key: "testEmoji", value: "😂")
        try! wrongPrefixedDB.put(key: "testTextEmoji", value: "emojitext 😂")
        try! wrongPrefixedDB.put(key: "testMultipleEmoji", value: "😂😂😂")

        wrongPrefixedDB.closeDB()

        let prefixedDB2 = try! RocksDB(path: URL(fileURLWithPath: prefixedPath), prefix: "correctprefix")

        try! prefixedDB2.delete(key: "testText")
        try! prefixedDB2.delete(key: "testEmoji")
        try! prefixedDB2.delete(key: "testTextEmoji")
        try! prefixedDB2.delete(key: "testMultipleEmoji")

        XCTAssertEqual(try! prefixedDB2.get(type: String.self, key: "testText"), "")
        XCTAssertEqual(try! prefixedDB2.get(type: String.self, key: "testEmoji"), "")
        XCTAssertEqual(try! prefixedDB2.get(type: String.self, key: "testTextEmoji"), "")
        XCTAssertEqual(try! prefixedDB2.get(type: String.self, key: "testMultipleEmoji"), "")

        prefixedDB2.closeDB()

        let wrongPrefixedDB2 = try! RocksDB(path: URL(fileURLWithPath: prefixedPath), prefix: "wrongprefix")

        XCTAssertEqual(try! wrongPrefixedDB2.get(type: String.self, key: "testText"), "lolamkhaha")
        XCTAssertEqual(try! wrongPrefixedDB2.get(type: String.self, key: "testEmoji"), "😂")
        XCTAssertEqual(try! wrongPrefixedDB2.get(type: String.self, key: "testTextEmoji"), "emojitext 😂")
        XCTAssertEqual(try! wrongPrefixedDB2.get(type: String.self, key: "testMultipleEmoji"), "😂😂😂")

        wrongPrefixedDB2.closeDB()

        try! FileManager.default.removeItem(at: wrongPrefixedDB.path)
    }

    func testSimpleIterator() {
        let path = "/tmp/\(UUID().uuidString)"
        rocksDB = try! RocksDB(path: URL(fileURLWithPath: path))

        let orderedKeysAndValues = [
            (key: "testEmoji", value: "😂"),
            (key: "testMultipleEmoji", value: "😂😂😂"),
            (key: "testText", value: "lolamkhaha"),
            (key: "testTextEmoji", value: "emojitext 😂")
        ]

        for (k, v) in orderedKeysAndValues {
            try! rocksDB.put(key: k, value: v)
        }

        var i = 0
        for (key, val) in rocksDB.sequence(keyType: String.self, valueType: String.self) {
            XCTAssertEqual(key, orderedKeysAndValues[i].key)
            XCTAssertEqual(val, orderedKeysAndValues[i].value)
            i += 1
        }
        XCTAssertEqual(i, 4)

        i = 1
        for (key, val) in rocksDB.sequence(keyType: String.self, valueType: String.self, gte: "testMultipleEmoji") {
            XCTAssertEqual(key, orderedKeysAndValues[i].key)
            XCTAssertEqual(val, orderedKeysAndValues[i].value)
            i += 1
        }
        XCTAssertEqual(i, 4)

//        i = 0
//        for (key, val) in rocksDB.sequence(keyType: String.self, valueType: String.self, lte: "testMultipleEmoji") {
//            XCTAssertEqual(key, orderedKeysAndValues[i].key)
//            XCTAssertEqual(val, orderedKeysAndValues[i].value)
//            i += 1
//        }

        rocksDB.closeDB()

        try! FileManager.default.removeItem(at: rocksDB.path)
    }

    static var allTests = [
        ("testSimplePut", testSimplePut),
        ("testSimpleDelete", testSimpleDelete),
        ("testPrefixedPut", testPrefixedPut),
        ("testPrefixedDelete", testPrefixedDelete),
    ]
}
