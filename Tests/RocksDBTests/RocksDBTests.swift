import XCTest
@testable import RocksDB

final class RocksDBTests: XCTestCase {

    var rocksDB: RocksDB!

    override func setUp() {
        super.setUp()

        let path = "/tmp/\(UUID().uuidString)"
        rocksDB = try! RocksDB(path: URL(fileURLWithPath: path))
    }

    override func tearDown() {
        super.tearDown()

        try! FileManager.default.removeItem(at: rocksDB.path)
    }

    func testSimplePut() {
        try! rocksDB.put(key: "testText", value: "lolamkhaha")
        try! rocksDB.put(key: "testEmoji", value: "😂")
        try! rocksDB.put(key: "testTextEmoji", value: "emojitext 😂")
        try! rocksDB.put(key: "testMultipleEmoji", value: "😂😂😂")

        XCTAssertEqual(try! rocksDB.get(type: String.self, key: "testText"), "lolamkhaha")
        XCTAssertEqual(try! rocksDB.get(type: String.self, key: "testEmoji"), "😂")
        XCTAssertEqual(try! rocksDB.get(type: String.self, key: "testTextEmoji"), "emojitext 😂")
        XCTAssertEqual(try! rocksDB.get(type: String.self, key: "testMultipleEmoji"), "😂😂😂")
    }

    func testSimpleDelete() {
        try! rocksDB.put(key: "testDeleteKey", value: "this is a simple value 😘")
        try! rocksDB.delete(key: "testDeleteKey")

        XCTAssertEqual(try! rocksDB.get(type: String.self, key: "testDeleteKey"), "")
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

    }

    static var allTests = [
        ("testSimplePut", testSimplePut),
        ("testSimpleDelete", testSimpleDelete),
        ("testPrefixedPut", testPrefixedPut),
        ("testPrefixedDelete", testPrefixedDelete),
    ]
}
