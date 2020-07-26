import XCTest
@testable import struct SwiftTreys.Card
@testable import enum SwiftTreys.Rank
@testable import enum SwiftTreys.Suit

final class CardTests: XCTestCase {
    func testUniqueCardIntegers() throws {
        let integers: [Int] = Rank.allCases.flatMap { rank in
            Suit.allCases.map { suit in
                Card(rank, suit).binaryInteger
            }
        }

        XCTAssertTrue(integers.allUnique)
    }

    func testCardFromValidStringList() throws {
        // Card.fromStringList() fails if even one input string is invalid,
        // so we only need to test one at a time.
        validStrings.forEach {
            XCTAssertNotNil(Card.fromStringList([$0]))
        }
    }

    func testCardFromInvalidStringList() throws {
        let invalidStrings: [String] = validStrings.map {
            String($0[$0.startIndex]) + " " + String($0[$0.index(after: $0.startIndex)])
        }
        invalidStrings.forEach {
            XCTAssertNil(Card.fromStringList([$0]))
        }
    }

    func testStringConversions() throws {
        let cards: [Card] = Rank.allCases.flatMap { rank in
            Suit.allCases.map { suit in
                Card(rank, suit)
            }
        }
        cards.forEach {
            let rank = $0.rank
            let suit = $0.suit
            let prettySuit = Card.PRETTY_SUITS[Card.CHAR_SUIT_TO_INT_SUIT[suit.rawValue]!]!
            let desc = $0.description
            XCTAssertTrue(desc.contains(rank.rawValue))
            XCTAssertTrue(desc.contains(prettySuit))
        }
    }

    let validStrings: [String] = Rank.allCases.flatMap { rank in
        Suit.allCases.map { suit in
            String(rank.rawValue) + String(suit.rawValue)
        }
    }
}
