@testable import SwiftTreys
import XCTest

final class UtilitiesTests: XCTestCase {
  func newDeck() -> [Card] { Card.generateDeck() }

  func testBitSequenceGenerator() throws {
    let someNumber: Int16 = 0b10011
    var generator = BitSequenceGenerator(bits: someNumber)

    func nextCheck(bits: Int16) {
      XCTAssertEqual(generator.next()!, bits)
    }

    nextCheck(bits: 0b0001_0101)
    nextCheck(bits: 0b0001_0110)
    nextCheck(bits: 0b0001_1001)
    nextCheck(bits: 0b0001_1010)
    nextCheck(bits: 0b0001_1100)
    nextCheck(bits: 0b0010_0011)
  }

  func testHighRankFromHandBits() throws {
    for _ in 0 ..< 16 {
      var deck = newDeck()
      let firstFive = deck[0 ..< 5]
      deck.removeSubrange(0 ..< 5)

      let highCard = firstFive.max()!
      let rankBits: Int16 = firstFive.reduce(into: 0) { result, next in
        result |= Int16(next.uniqueInteger >> 16)
      }
      let result = highRankFromRankBits(rankBits)
      XCTAssertEqual(highCard.rank, result)
    }
  }
}
