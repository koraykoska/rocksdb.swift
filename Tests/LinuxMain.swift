import XCTest

import RocksDBTests

var tests = [XCTestCaseEntry]()
tests += RocksDBTests.allTests()
XCTMain(tests)
