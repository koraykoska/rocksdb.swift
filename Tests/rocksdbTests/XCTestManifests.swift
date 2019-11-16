import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(rocksdb_swiftTests.allTests),
    ]
}
#endif
