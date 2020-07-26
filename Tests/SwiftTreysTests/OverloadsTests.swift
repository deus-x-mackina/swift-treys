import XCTest
@testable import SwiftTreys

final class OverloadsTests: XCTestCase {
    func testAsteriskOverload() throws {
        let hello = ["hello"]
        XCTAssertTrue(hello * 3 == ["hello", "hello", "hello"])

        let numbers = [0, 1]
        XCTAssertTrue(numbers * 2 == [0, 1, 0, 1])

        let heterogeneousArray = ["a", 1, 1.5] as [Any]
        var timesTwo = heterogeneousArray * 2
        for _ in 0..<2 {
            XCTAssertTrue(timesTwo.popLast()! as! Double == 1.5)
            XCTAssertTrue(timesTwo.popLast()! as! Int == 1)
            XCTAssertTrue(timesTwo.popLast()! as! String == "a")
        }
    }
}