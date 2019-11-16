import XCTest

import rocksdb_swiftTests

var tests = [XCTestCaseEntry]()
tests += rocksdb_swiftTests.allTests()
XCTMain(tests)
