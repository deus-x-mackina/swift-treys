@testable import SwiftTreys
import XCTest

final class ExtensionsTests: XCTestCase {
  // MARK: FixedWidthInteger Extensions

  func testWrappingPow() throws {
    XCTAssertEqual(2.wrappingPow(0), Int(pow(Double(2), 0)))
    XCTAssertEqual(2.wrappingPow(1), Int(pow(Double(2), 1)))
    XCTAssertEqual(2.wrappingPow(2), Int(pow(Double(2), 2)))
    XCTAssertEqual(2.wrappingPow(3), Int(pow(Double(2), 3)))

    XCTAssertEqual(3.wrappingPow(0), Int(pow(Double(3), 0)))
    XCTAssertEqual(3.wrappingPow(1), Int(pow(Double(3), 1)))
    XCTAssertEqual(3.wrappingPow(2), Int(pow(Double(3), 2)))
    XCTAssertEqual(3.wrappingPow(3), Int(pow(Double(3), 3)))
  }

  // MARK: Collection Extensions

  func testAllUnique() throws {
    let array1 = [1, 2, 3]
    let array2 = ["foo", "bar", "baz"]
    let array3 = [1, 1, 1]
    let array4 = ["x", "x", "x"]

    XCTAssert(array1.allUnique)
    XCTAssert(array2.allUnique)
    XCTAssert(!array3.allUnique)
    XCTAssert(!array4.allUnique)
  }
}
