import XCTest

@testable import struct SwiftTreys.Card
@testable import struct SwiftTreys.Deck

final class DeckTests: XCTestCase {
    func testDeckGeneration() throws {
        let d = Deck()
        XCTAssertTrue(d.count == 52)
        XCTAssertTrue(d.allUnique)
    }

    func testDraw() throws {
        var d = Deck()
        let amountToDraw = 5
        let hand1 = d.draw(amountToDraw)
        let hand2 = d.draw(amountToDraw)
        var hand3 = [Card]()
        for _ in 0..<amountToDraw { hand3 += d.draw() }

        XCTAssertTrue(d.count == 52 - (amountToDraw * 3))
        XCTAssertTrue(hand1.count == 5)
        XCTAssertTrue(hand2.count == 5)
        XCTAssertTrue(hand3.count == 5)
        XCTAssertTrue(hand1 != hand2)
        XCTAssertTrue(hand2 != hand3)
    }
}
