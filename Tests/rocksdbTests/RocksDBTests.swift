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
        let value1 = "thisisatestmessage".data(using: .utf8)!
        try! rocksDB.put(key: "testKey", value: value1)
        XCTAssertEqual(try! rocksDB.get(key: "testKey"), value1)
    }

    static var allTests = [
        ("testSimplePut", testSimplePut),
    ]
}
