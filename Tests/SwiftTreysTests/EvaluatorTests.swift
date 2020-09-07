import Foundation
import XCTest

@testable import SwiftTreys

final class EvaluatorTests: XCTestCase {

    func testAllFiveCardCombos() throws {
        print("\nTesting all 5 card hand combinations. This may take a bit...")
        var ints = Set<Int>()
        let gen = CombinationsGenerator(pool: Array(Deck()), r: 5)
        for hand in gen {
            let res = try! Evaluator.evaluate(cards: hand)
            ints.insert(res)
        }
        XCTAssertTrue(ints.count == 7462)
        for i in 1...7462 { XCTAssertTrue(ints.contains(i)) }
    }

    func testFiveCardHandHighCard() throws {
        let pokerHand = try! Evaluator.classifyPokerHand(cards: RepresentativeFiveCardHand.highCard)
        XCTAssertTrue(pokerHand == LookupTable.RANK_CLASS_TO_POKER_HAND[9]!)
    }

    func testFiveCardHandPair() throws {
        let pokerHand = try! Evaluator.classifyPokerHand(cards: RepresentativeFiveCardHand.pair)
        XCTAssertTrue(pokerHand == LookupTable.RANK_CLASS_TO_POKER_HAND[8]!)
    }

    func testFiveCardHandTwoPair() throws {
        let pokerHand = try! Evaluator.classifyPokerHand(cards: RepresentativeFiveCardHand.twoPair)
        XCTAssertTrue(pokerHand == LookupTable.RANK_CLASS_TO_POKER_HAND[7]!)
    }

    func testFiveCardHandThreeOfAKind() throws {
        let pokerHand = try! Evaluator.classifyPokerHand(
            cards: RepresentativeFiveCardHand.threeOfAKind)
        XCTAssertTrue(pokerHand == LookupTable.RANK_CLASS_TO_POKER_HAND[6]!)
    }

    func testFiveCardHandStraight() throws {
        let pokerHand = try! Evaluator.classifyPokerHand(cards: RepresentativeFiveCardHand.straight)
        XCTAssertTrue(pokerHand == LookupTable.RANK_CLASS_TO_POKER_HAND[5]!)
    }

    func testFiveCardHandFlush() throws {
        let pokerHand = try! Evaluator.classifyPokerHand(cards: RepresentativeFiveCardHand.flush)
        XCTAssertTrue(pokerHand == LookupTable.RANK_CLASS_TO_POKER_HAND[4]!)
    }

    func testFiveCardHandFullHouse() throws {
        let pokerHand = try! Evaluator.classifyPokerHand(
            cards: RepresentativeFiveCardHand.fullHouse)
        XCTAssertTrue(pokerHand == LookupTable.RANK_CLASS_TO_POKER_HAND[3]!)
    }

    func testFiveCardHandFourOfAKind() throws {
        let pokerHand = try! Evaluator.classifyPokerHand(
            cards: RepresentativeFiveCardHand.fourOfAKind)
        XCTAssertTrue(pokerHand == LookupTable.RANK_CLASS_TO_POKER_HAND[2]!)
    }

    func testFiveCardHandStraightFlush() throws {
        let pokerHand = try! Evaluator.classifyPokerHand(
            cards: RepresentativeFiveCardHand.straightFlush)
        XCTAssertTrue(pokerHand == LookupTable.RANK_CLASS_TO_POKER_HAND[1]!)
    }

    func testFiveCardHandRoyalFlush() throws {
        let pokerHand = try! Evaluator.classifyPokerHand(
            cards: RepresentativeFiveCardHand.royalFlush)
        XCTAssertTrue(pokerHand == LookupTable.RANK_CLASS_TO_POKER_HAND[1]!)
        let rank = try! Evaluator.evaluate(cards: RepresentativeFiveCardHand.royalFlush)
        XCTAssertTrue(rank == 1)
    }

    func testSixCardHandHighCard() throws {
        let pokerHand = try! Evaluator.classifyPokerHand(
            cards: RepresentativeSixCardHand.highCard[0..<2],
            board: RepresentativeSixCardHand.highCard[2..<6])
        XCTAssertTrue(pokerHand == LookupTable.RANK_CLASS_TO_POKER_HAND[9]!)
    }

    func testSixCardHandPair() throws {
        let pokerHand = try! Evaluator.classifyPokerHand(
            cards: RepresentativeSixCardHand.pair[0..<2],
            board: RepresentativeSixCardHand.pair[2..<6])
        XCTAssertTrue(pokerHand == LookupTable.RANK_CLASS_TO_POKER_HAND[8]!)
    }

    func testSixCardHandTwoPair() throws {
        let pokerHand = try! Evaluator.classifyPokerHand(
            cards: RepresentativeSixCardHand.twoPair[0..<2],
            board: RepresentativeSixCardHand.twoPair[2..<6])
        XCTAssertTrue(pokerHand == LookupTable.RANK_CLASS_TO_POKER_HAND[7]!)
    }

    func testSixCardHandThreeOfAKind() throws {
        let pokerHand = try! Evaluator.classifyPokerHand(
            cards: RepresentativeSixCardHand.threeOfAKind[0..<2],
            board: RepresentativeSixCardHand.threeOfAKind[2..<6])
        XCTAssertTrue(pokerHand == LookupTable.RANK_CLASS_TO_POKER_HAND[6]!)
    }

    func testSixCardHandStraight() throws {
        let pokerHand = try! Evaluator.classifyPokerHand(
            cards: RepresentativeSixCardHand.straight[0..<2],
            board: RepresentativeSixCardHand.straight[2..<6])
        XCTAssertTrue(pokerHand == LookupTable.RANK_CLASS_TO_POKER_HAND[5]!)
    }

    func testSixCardHandFlush() throws {
        let pokerHand = try! Evaluator.classifyPokerHand(
            cards: RepresentativeSixCardHand.flush[0..<2],
            board: RepresentativeSixCardHand.flush[2..<6])
        XCTAssertTrue(pokerHand == LookupTable.RANK_CLASS_TO_POKER_HAND[4]!)
    }

    func testSixCardHandFullHouse() throws {
        let pokerHand = try! Evaluator.classifyPokerHand(
            cards: RepresentativeSixCardHand.fullHouse[0..<2],
            board: RepresentativeSixCardHand.fullHouse[2..<6])
        XCTAssertTrue(pokerHand == LookupTable.RANK_CLASS_TO_POKER_HAND[3]!)
    }

    func testSixCardHandFourOfAKind() throws {
        let pokerHand = try! Evaluator.classifyPokerHand(
            cards: RepresentativeSixCardHand.fourOfAKind[0..<2],
            board: RepresentativeSixCardHand.fourOfAKind[2..<6])
        XCTAssertTrue(pokerHand == LookupTable.RANK_CLASS_TO_POKER_HAND[2]!)
    }

    func testSixCardHandStraightFlush() throws {
        let pokerHand = try! Evaluator.classifyPokerHand(
            cards: RepresentativeSixCardHand.straightFlush[0..<2],
            board: RepresentativeSixCardHand.straightFlush[2..<6])
        XCTAssertTrue(pokerHand == LookupTable.RANK_CLASS_TO_POKER_HAND[1]!)
    }

    func testSixCardHandRoyalFlush() throws {
        let pokerHand = try! Evaluator.classifyPokerHand(
            cards: RepresentativeSixCardHand.royalFlush[0..<2],
            board: RepresentativeSixCardHand.royalFlush[2..<6])
        XCTAssertTrue(pokerHand == LookupTable.RANK_CLASS_TO_POKER_HAND[1]!)
        let rank = try! Evaluator.evaluate(cards: RepresentativeFiveCardHand.royalFlush)
        XCTAssertTrue(rank == 1)
    }

    func testSevenCardHandHighCard() throws {
        let pokerHand = try! Evaluator.classifyPokerHand(
            cards: RepresentativeSevenCardHand.highCard[0..<2],
            board: RepresentativeSevenCardHand.highCard[2..<7])
        XCTAssertTrue(pokerHand == LookupTable.RANK_CLASS_TO_POKER_HAND[9]!)
    }

    func testSevenCardHandPair() throws {
        let pokerHand = try! Evaluator.classifyPokerHand(
            cards: RepresentativeSevenCardHand.pair[0..<2],
            board: RepresentativeSevenCardHand.pair[2..<7])
        XCTAssertTrue(pokerHand == LookupTable.RANK_CLASS_TO_POKER_HAND[8]!)
    }

    func testSevenCardHandTwoPair() throws {
        let pokerHand = try! Evaluator.classifyPokerHand(
            cards: RepresentativeSevenCardHand.twoPair[0..<2],
            board: RepresentativeSevenCardHand.twoPair[2..<7])
        XCTAssertTrue(pokerHand == LookupTable.RANK_CLASS_TO_POKER_HAND[7]!)
    }

    func testSevenCardHandThreeOfAKind() throws {
        let pokerHand = try! Evaluator.classifyPokerHand(
            cards: RepresentativeSevenCardHand.threeOfAKind[0..<2],
            board: RepresentativeSevenCardHand.threeOfAKind[2..<7])
        XCTAssertTrue(pokerHand == LookupTable.RANK_CLASS_TO_POKER_HAND[6]!)
    }

    func testSevenCardHandStraight() throws {
        let pokerHand = try! Evaluator.classifyPokerHand(
            cards: RepresentativeSevenCardHand.straight[0..<2],
            board: RepresentativeSevenCardHand.straight[2..<7])
        XCTAssertTrue(pokerHand == LookupTable.RANK_CLASS_TO_POKER_HAND[5]!)
    }

    func testSevenCardHandFlush() throws {
        let pokerHand = try! Evaluator.classifyPokerHand(
            cards: RepresentativeSevenCardHand.flush[0..<2],
            board: RepresentativeSevenCardHand.flush[2..<7])
        XCTAssertTrue(pokerHand == LookupTable.RANK_CLASS_TO_POKER_HAND[4]!)
    }

    func testSevenCardHandFullHouse() throws {
        let pokerHand = try! Evaluator.classifyPokerHand(
            cards: RepresentativeSevenCardHand.fullHouse[0..<2],
            board: RepresentativeSevenCardHand.fullHouse[2..<7])
        XCTAssertTrue(pokerHand == LookupTable.RANK_CLASS_TO_POKER_HAND[3]!)
    }

    func testSevenCardHandFourOfAKind() throws {
        let pokerHand = try! Evaluator.classifyPokerHand(
            cards: RepresentativeSevenCardHand.fourOfAKind[0..<2],
            board: RepresentativeSevenCardHand.fourOfAKind[2..<7])
        XCTAssertTrue(pokerHand == LookupTable.RANK_CLASS_TO_POKER_HAND[2]!)
    }

    func testSevenCardHandStraightFlush() throws {
        let pokerHand = try! Evaluator.classifyPokerHand(
            cards: RepresentativeSevenCardHand.straightFlush[0..<2],
            board: RepresentativeSevenCardHand.straightFlush[2..<7])
        XCTAssertTrue(pokerHand == LookupTable.RANK_CLASS_TO_POKER_HAND[1]!)
    }

    func testSevenCardHandRoyalFlush() throws {
        let pokerHand = try! Evaluator.classifyPokerHand(
            cards: RepresentativeSevenCardHand.royalFlush[0..<2],
            board: RepresentativeSevenCardHand.royalFlush[2..<7])
        XCTAssertTrue(pokerHand == LookupTable.RANK_CLASS_TO_POKER_HAND[1]!)
        let rank = try! Evaluator.evaluate(cards: RepresentativeFiveCardHand.royalFlush)
        XCTAssertTrue(rank == 1)
    }

    struct RepresentativeFiveCardHand {
        static let highCard = Card.fromStringList(["Ah", "8s", "6d", "4c", "2h"])!
        static let pair = Card.fromStringList(["Ac", "Ah", "9s", "8d", "7c"])!
        static let twoPair = Card.fromStringList(["Kd", "Kc", "Qh", "Qs", "Jd"])!
        static let threeOfAKind = Card.fromStringList(["Ac", "Ah", "As", "2d", "7c"])!
        static let straight = Card.fromStringList(["5h", "6c", "7d", "8s", "9h"])!
        static let flush = Card.fromStringList(["Ac", "5c", "Tc", "Jc", "8c"])!
        static let fullHouse = Card.fromStringList(["As", "Ad", "Ac", "Kh", "Ks"])!
        static let fourOfAKind = Card.fromStringList(["Ac", "Ah", "As", "Ad", "2h"])!
        static let straightFlush = Card.fromStringList(["5s", "6s", "7s", "8s", "9s", "Ts"])!
        static let royalFlush = Card.fromStringList(["Th", "Jh", "Qh", "Kh", "Ah"])!
    }

    struct RepresentativeSixCardHand {
        static let highCard = Card.fromStringList(["Ah", "8s", "6d", "4c", "2h", "Jh"])!
        static let pair = Card.fromStringList(["Ac", "Ah", "9s", "8d", "7c", "6c"])!
        static let twoPair = Card.fromStringList(["Kd", "Kc", "Qh", "Qs", "Jd", "2c"])!
        static let threeOfAKind = Card.fromStringList(["Ac", "Ah", "As", "2d", "7c", "3h"])!
        static let straight = Card.fromStringList(["5h", "6c", "7d", "8s", "9h", "2d"])!
        static let flush = Card.fromStringList(["Ac", "5c", "Tc", "Jc", "8c", "4h"])!
        static let fullHouse = Card.fromStringList(["As", "Ad", "Ac", "Kh", "Ks", "2d"])!
        static let fourOfAKind = Card.fromStringList(["Ac", "Ah", "As", "Ad", "2h", "3c"])!
        static let straightFlush = Card.fromStringList(["5s", "6s", "7s", "8s", "9s", "Ts", "2c"])!
        static let royalFlush = Card.fromStringList(["Th", "Jh", "Qh", "Kh", "Ah", "2c"])!
    }

    struct RepresentativeSevenCardHand {
        static let highCard = Card.fromStringList(["Ah", "8s", "6d", "4c", "2h", "Jh", "Ts"])!
        static let pair = Card.fromStringList(["Ac", "Ah", "9s", "8d", "7c", "6c", "2h"])!
        static let twoPair = Card.fromStringList(["Kd", "Kc", "Qh", "Qs", "Jd", "2c", "3s"])!
        static let threeOfAKind = Card.fromStringList(["Ac", "Ah", "As", "2d", "7c", "3h", "5s"])!
        static let straight = Card.fromStringList(["5h", "6c", "7d", "8s", "9h", "2d", "Ac"])!
        static let flush = Card.fromStringList(["Ac", "5c", "Tc", "Jc", "8c", "4h", "As"])!
        static let fullHouse = Card.fromStringList(["As", "Ad", "Ac", "Kh", "Ks", "2d", "3c"])!
        static let fourOfAKind = Card.fromStringList(["Ac", "Ah", "As", "Ad", "2h", "3c", "4d"])!
        static let straightFlush = Card.fromStringList([
            "5s", "6s", "7s", "8s", "9s", "Ts", "2c", "3h",
        ])!
        static let royalFlush = Card.fromStringList(["Th", "Jh", "Qh", "Kh", "Ah", "2c", "3s"])!
    }
}
