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

        XCTAssertEqual(try! rocksDB!.get(type: String.self, key: "testText"), "lolamkhaha")
        XCTAssertEqual(try! rocksDB!.get(type: String.self, key: "testEmoji"), "😂")
        XCTAssertEqual(try! rocksDB!.get(type: String.self, key: "testTextEmoji"), "emojitext 😂")
        XCTAssertEqual(try! rocksDB!.get(type: String.self, key: "testMultipleEmoji"), "😂😂😂")
    }

    func testSimpleDelete() {
        try! rocksDB.put(key: "testDeleteKey", value: "this is a simple value 😘")
        try! rocksDB.delete(key: "testDeleteKey")

        XCTAssertEqual(try! rocksDB.get(type: String.self, key: "testDeleteKey"), "")
    }

    static var allTests = [
        ("testSimplePut", testSimplePut),
        ("testSimpleDelete", testSimpleDelete),
    ]
}
