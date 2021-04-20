import Algorithms
@testable import SwiftTreys
import XCTest

final class EvaluationTests: XCTestCase {
  func testAllFiveCardCombinations() throws {
    let gen = Card.generateDeck(shuffle: false).combinations(ofCount: 5)
    var evaluations = Set<Evaluation>()
    evaluations.reserveCapacity(7462)
    for hand in gen {
      evaluations.insert(try Evaluator.evaluate(cards: hand))
    }
    XCTAssertEqual(evaluations.count, 7462)
    for i in 1 ... 7462 {
      XCTAssert(evaluations.contains { meta in meta.handRank == PokerHandRank(rank: Int16(i)) })
    }
  }

  func testRepresentativeFiveCardHands() throws {
    try representativeHandEvaluatesCorrectly(forType: FiveCardHand.self)
  }

  func testRepresentativeSixCardHands() throws {
    try representativeHandEvaluatesCorrectly(forType: SixCardHand.self)
  }

  func testRepresentativeSevenCardHands() throws {
    try representativeHandEvaluatesCorrectly(forType: SevenCardHand.self)
  }

  func representativeHandEvaluatesCorrectly<T: RepresentableHand>(forType _: T.Type = T.self) throws {
    XCTAssert(T.allHands().allSatisfy { $0.count == T.handCount })

    XCTAssert(try Evaluator.evaluate(cards: T.highCard).isHighCard)
    XCTAssert(try Evaluator.evaluate(cards: T.pair).isPair)
    XCTAssert(try Evaluator.evaluate(cards: T.twoPair).isTwoPair)
    XCTAssert(try Evaluator.evaluate(cards: T.threeOfAKind).isThreeOfAKind)
    XCTAssert(try Evaluator.evaluate(cards: T.straight).isStraight)
    XCTAssert(try Evaluator.evaluate(cards: T.flush).isFlush)
    XCTAssert(try Evaluator.evaluate(cards: T.fullHouse).isFullHouse)
    XCTAssert(try Evaluator.evaluate(cards: T.fourOfAKind).isFourOfAKind)
    XCTAssert(try Evaluator.evaluate(cards: T.straightFlush).isStraightFlush)
    XCTAssert(try Evaluator.evaluate(cards: T.royalFlush).isRoyalFlush)
  }
}

typealias Hand = [Card]
protocol RepresentableHand {
  static var handCount: Int { get }
  static var highCard: Hand { get }
  static var pair: Hand { get }
  static var twoPair: Hand { get }
  static var threeOfAKind: Hand { get }
  static var straight: Hand { get }
  static var flush: Hand { get }
  static var fullHouse: Hand { get }
  static var fourOfAKind: Hand { get }
  static var straightFlush: Hand { get }
  static var royalFlush: Hand { get }
}

extension RepresentableHand {
  static func allHands() -> [Hand] {
    let list = [
      highCard,
      pair,
      twoPair,
      threeOfAKind,
      straight,
      flush,
      fullHouse,
      fourOfAKind,
      straightFlush,
      royalFlush,
    ]

    assert(list.count == 10)

    return list
  }
}

enum FiveCardHand: RepresentableHand {
  static var handCount: Int = 5
  static var highCard: Hand = try! Card.parseArray(strings: ["Ah", "8s", "6d", "4c", "2h"])
  static var pair: Hand = try! Card.parseArray(strings: ["Ac", "Ah", "9s", "8d", "7c"])
  static var twoPair: Hand = try! Card.parseArray(strings: ["Kd", "Kc", "Qh", "Qs", "Jd"])
  static var threeOfAKind: Hand = try! Card.parseArray(strings: ["Ac", "Ah", "As", "2d", "7c"])
  static var straight: Hand = try! Card.parseArray(strings: ["5h", "6c", "7d", "8s", "9h"])
  static var flush: Hand = try! Card.parseArray(strings: ["Ac", "5c", "Tc", "Jc", "8c"])
  static var fullHouse: Hand = try! Card.parseArray(strings: ["As", "Ad", "Ac", "Kh", "Ks"])
  static var fourOfAKind: Hand = try! Card.parseArray(strings: ["Ac", "Ah", "As", "Ad", "2h"])
  static var straightFlush: Hand = try! Card.parseArray(strings: ["5s", "6s", "7s", "8s", "9s"])
  static var royalFlush: Hand = try! Card.parseArray(strings: ["Th", "Jh", "Qh", "Kh", "Ah"])
}

enum SixCardHand: RepresentableHand {
  static var handCount: Int = 6
  static var highCard: Hand = try! Card.parseArray(strings: ["Ah", "8s", "6d", "4c", "2h", "Jh"])
  static var pair: Hand = try! Card.parseArray(strings: ["Ac", "Ah", "9s", "8d", "7c", "6c"])
  static var twoPair: Hand = try! Card.parseArray(strings: ["Kd", "Kc", "Qh", "Qs", "Jd", "2c"])
  static var threeOfAKind: Hand = try! Card.parseArray(strings: ["Ac", "Ah", "As", "2d", "7c", "3h"])
  static var straight: Hand = try! Card.parseArray(strings: ["5h", "6c", "7d", "8s", "9h", "2d"])
  static var flush: Hand = try! Card.parseArray(strings: ["Ac", "5c", "Tc", "Jc", "8c", "4h"])
  static var fullHouse: Hand = try! Card.parseArray(strings: ["As", "Ad", "Ac", "Kh", "Ks", "2d"])
  static var fourOfAKind: Hand = try! Card.parseArray(strings: ["Ac", "Ah", "As", "Ad", "2h", "3c"])
  static var straightFlush: Hand = try! Card.parseArray(strings: ["5s", "6s", "7s", "8s", "9s", "Ts"])
  static var royalFlush: Hand = try! Card.parseArray(strings: ["Th", "Jh", "Qh", "Kh", "Ah", "2c"])
}

enum SevenCardHand: RepresentableHand {
  static var handCount: Int = 7
  static var highCard: Hand = try! Card.parseArray(strings: ["Ah", "8s", "6d", "4c", "2h", "Jh", "Ts"])
  static var pair: Hand = try! Card.parseArray(strings: ["Ac", "Ah", "9s", "8d", "7c", "6c", "2h"])
  static var twoPair: Hand = try! Card.parseArray(strings: ["Kd", "Kc", "Qh", "Qs", "Jd", "2c", "3s"])
  static var threeOfAKind: Hand = try! Card.parseArray(strings: ["Ac", "Ah", "As", "2d", "7c", "3h", "5s"])
  static var straight: Hand = try! Card.parseArray(strings: ["5h", "6c", "7d", "8s", "9h", "2d", "Ac"])
  static var flush: Hand = try! Card.parseArray(strings: ["Ac", "5c", "Tc", "Jc", "8c", "4h", "As"])
  static var fullHouse: Hand = try! Card.parseArray(strings: ["As", "Ad", "Ac", "Kh", "Ks", "2d", "3c"])
  static var fourOfAKind: Hand = try! Card.parseArray(strings: ["Ac", "Ah", "As", "Ad", "2h", "3c", "4d"])
  static var straightFlush: Hand = try! Card.parseArray(strings: ["5s", "6s", "7s", "8s", "9s", "Ts", "2c"])
  static var royalFlush: Hand = try! Card.parseArray(strings: ["Th", "Jh", "Qh", "Kh", "Ah", "2c", "3s"])
}
