import Algorithms
@testable import SwiftTreys
import XCTest

final class ErrorTests: XCTestCase {
  func testCardFromCharsThrows() throws {
    let validRanks = "A23456789TJQKA"
    let validSuits = "chsd"

    let invalidRanks: [Character] = chain(
      UnicodeScalar("A").value ... UnicodeScalar("Z").value,
      UnicodeScalar("0").value ... UnicodeScalar("9").value
    )
    .reduce(into: []) { arr, i in
      let scalar = UnicodeScalar(i)!
      let character = Character(scalar)
      guard !validRanks.contains(character) else { return }
      arr.append(character)
    }

    let invalidSuits: [Character] = (UnicodeScalar("a").value ... UnicodeScalar("z").value).reduce(into: []) { arr, i in
      let scalar = UnicodeScalar(i)!
      let character = Character(scalar)
      guard !validSuits.contains(character) else { return }
      arr.append(character)
    }

    for rank in invalidRanks {
      XCTAssertThrowsError(try Card(rankChar: rank, suitChar: "c")) { error in
        guard let error = error as? ParseCardError,
              case let .invalidRank(originalInput: i, incorrectChar: r) = error else { return XCTFail() }
        XCTAssertEqual(rank, r)
        XCTAssertEqual(
          error.description,
          """
          Error parsing input '\(i)' as a Card: Invalid \
          rank character '\(r)', expected one of [23456789TJQKA]
          """
        )
      }
    }

    for suit in invalidSuits {
      XCTAssertThrowsError(try Card(rankChar: "A", suitChar: suit)) { error in
        guard let error = error as? ParseCardError,
              case let .invalidSuit(originalInput: i, incorrectChar: s) = error else { return XCTFail() }
        XCTAssertEqual(suit, s)
        XCTAssertEqual(
          error.description,
          """
          Error parsing input '\(i)' as a Card: Invalid \
          suit character '\(s)', expected one of [chsd]
          """
        )
      }
    }
  }

  func testCardParseThrows() throws {
    let threeCharInput = "abc"
    let emptyInput = ""

    XCTAssertThrowsError(try Card.parse(threeCharInput)) { error in
      guard let error = error as? ParseCardError,
            case let .invalidLength(originalInput: i) = error else { return XCTFail() }
      XCTAssertEqual(i, threeCharInput)
      XCTAssertEqual(
        error.description,
        """
        Error parsing input '\(threeCharInput)' as a Card: Found \
        input of length \(threeCharInput.count), expected 2
        """
      )
    }

    XCTAssertThrowsError(try Card.parse(emptyInput)) { error in
      guard let error = error as? ParseCardError,
            case let .invalidLength(originalInput: i) = error else { return XCTFail() }
      XCTAssertEqual(i, emptyInput)
      XCTAssertEqual(
        error.description,
        """
        Error parsing input '' as a Card: Found \
        input of length 0, expected 2
        """
      )
    }

    let invalidRank = "tc"
    let invalidSuit = "5H"

    XCTAssertThrowsError(try Card.parse(invalidRank)) { error in
      guard let error = error as? ParseCardError,
            case .invalidRank(originalInput: _, incorrectChar: _) = error else { return XCTFail() }
    }

    XCTAssertThrowsError(try Card.parse(invalidSuit)) { error in
      guard let error = error as? ParseCardError,
            case .invalidSuit(originalInput: _, incorrectChar: _) = error else { return XCTFail() }
    }
  }

  func testEvaluationDuplicateErrors() throws {
    let oneDup = try Card.parseArray(strings: ["5c", "5c", "Ad", "3h", "7d"])
    for hand in oneDup.permutations(ofCount: 5) {
      assert(hand.count == 5)
      XCTAssertThrowsError(try Evaluator.evaluate(cards: hand)) { error in
        guard let error = error as? EvaluationError,
              case let .cardsNotUnique(h) = error else { return XCTFail() }
        XCTAssertEqual(hand, h)
        XCTAssertEqual(
          error.description,
          """
          Cannot evaluate a poker hand with a set of cards that \
          are not unique. Cards duplicated at least once: \
          5c
          """
        )
      }
    }

    let oneTrip = try Card.parseArray(strings: ["5c", "5c", "5c", "3h", "7d"])
    for hand in oneTrip.permutations(ofCount: 5) {
      assert(hand.count == 5)
      XCTAssertThrowsError(try Evaluator.evaluate(cards: hand)) { error in
        guard let error = error as? EvaluationError,
              case let .cardsNotUnique(h) = error else { return XCTFail() }
        XCTAssertEqual(hand, h)
        XCTAssertEqual(
          error.description,
          """
          Cannot evaluate a poker hand with a set of cards that \
          are not unique. Cards duplicated at least once: \
          5c
          """
        )
      }
    }

    let multiDup = try Card.parseArray(strings: ["5c", "5c", "3h", "3h", "7d"])
    for hand in multiDup.permutations(ofCount: 5) {
      assert(hand.count == 5)
      XCTAssertThrowsError(try Evaluator.evaluate(cards: hand)) { error in
        guard let error = error as? EvaluationError,
              case let .cardsNotUnique(h) = error else { return XCTFail() }
        XCTAssertEqual(hand, h)
        XCTAssert(error.description.contains("5c") && error.description.contains("3h"))
      }
    }
  }

  func testEvaluationInvalidCountErrors() {
    let deck = Card.generateDeck()
    for i in 0 ..< 5 {
      let cards = deck[0 ..< i]
      assert(cards.count == i && i < 5)
      XCTAssertThrowsError(try Evaluator.evaluate(cards: cards)) { error in
        guard let error = error as? EvaluationError,
              case let .invalidHandSize(size) = error else { return XCTFail() }
        XCTAssertEqual(i, size)
        XCTAssertEqual(
          error.description,
          """
          Cannot evaluate a poker hand with a set of less than 5 \
          cards. Number of cards received: \(i)
          """
        )
      }
    }
  }
}
