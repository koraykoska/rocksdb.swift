import XCTest
@testable import rocksdb

final class rocksdbTests: XCTestCase {

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

    func testRocksDB() {
        let value1 = "thisisatestmessage"
        try! rocksDB.put(key: "testKey", value: value1)
        XCTAssertEqual(try! rocksDB.get(key: "testKey"), value1.data(using: .utf8)!)
    }

    static var allTests = [
        ("testRocksDB", testRocksDB),
    ]
}
