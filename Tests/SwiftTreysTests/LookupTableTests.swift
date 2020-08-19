import XCTest

@testable import SwiftTreys

final class LookupTableTests: XCTestCase {
    let table = LookupTable()
    func testTableSize() throws {
        XCTAssertTrue(table.flushLookup.count == 1287)
        XCTAssertTrue(table.unsuitedLookup.count == 6175)
    }
}
