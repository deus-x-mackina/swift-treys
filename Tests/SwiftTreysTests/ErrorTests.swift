import XCTest

@testable import SwiftTreys

final class ErrorTests: XCTestCase {
    var error: Error?

    func testThrowsInvalidNumberOfCards() throws {
        do {
            // First, too many on board
            let hand = Card.fromStringList(["Th", "3d"])!
            let board = Card.fromStringList(["5s", "4d", "As", "Kc", "8s", "2c"])!
            XCTAssertThrowsError(try Evaluator.evaluate(cards: hand, board: board)) { error = $0 }
            XCTAssert(error is SwiftTreysError)
            XCTAssert(error as? SwiftTreysError == .invalidNumberOfCards(8))
            XCTAssert(
                (error as! SwiftTreysError).debugDescription == """
                    Evaluator method evaluate(cards:board:) received \
                    8 cards instead of 5 - 7 cards.
                    """)
            XCTAssert(
                (error as! SwiftTreysError).description
                    == (error as! SwiftTreysError).debugDescription)
        }

        do {
            // Too many in hand
            let hand = Card.fromStringList(["Th", "3d", "2c"])!
            let board = Card.fromStringList(["5s", "4d", "As", "Kc", "8s"])!
            XCTAssertThrowsError(try Evaluator.evaluate(cards: hand, board: board)) { error = $0 }
            XCTAssert(error is SwiftTreysError)
            XCTAssert(error as? SwiftTreysError == .invalidNumberOfCards(8))
            XCTAssert(
                (error as! SwiftTreysError).debugDescription == """
                    Evaluator method evaluate(cards:board:) received \
                    8 cards instead of 5 - 7 cards.
                    """)
            XCTAssert(
                (error as! SwiftTreysError).description
                    == (error as! SwiftTreysError).debugDescription)
        }

        do {
            // Too few in board
            let hand = Card.fromStringList(["Th", "3d"])!
            let board = Card.fromStringList(["5s", "4d"])!
            XCTAssertThrowsError(try Evaluator.evaluate(cards: hand, board: board)) { error = $0 }
            XCTAssert(error is SwiftTreysError)
            XCTAssert(error as? SwiftTreysError == .invalidNumberOfCards(4))
            XCTAssert(
                (error as! SwiftTreysError).debugDescription == """
                    Evaluator method evaluate(cards:board:) received \
                    4 cards instead of 5 - 7 cards.
                    """)
            XCTAssert(
                (error as! SwiftTreysError).description
                    == (error as! SwiftTreysError).debugDescription)
        }

        do {
            // Too few in hand
            let hand = Card.fromStringList([])!
            let board = Card.fromStringList(["5s", "4d", "Th", "3d"])!
            XCTAssertThrowsError(try Evaluator.evaluate(cards: hand, board: board)) { error = $0 }
            XCTAssert(error is SwiftTreysError)
            XCTAssert(error as? SwiftTreysError == .invalidNumberOfCards(4))
            XCTAssert(
                (error as! SwiftTreysError).debugDescription == """
                    Evaluator method evaluate(cards:board:) received \
                    4 cards instead of 5 - 7 cards.
                    """)
            XCTAssert(
                (error as! SwiftTreysError).description
                    == (error as! SwiftTreysError).debugDescription)
        }
    }

    func testThrowsCardsNotUnique() throws {
        do {
            // Hand only
            let hand = Card.fromStringList(["As", "As", "As", "As", "As"])!
            XCTAssertThrowsError(try Evaluator.evaluate(cards: hand)) { error = $0 }
            XCTAssert(error is SwiftTreysError)
            XCTAssert(error as? SwiftTreysError == .cardsNotUnique)
            XCTAssert(
                (error as! SwiftTreysError).debugDescription
                    == "The cards supplied to the Evaluator were not all unique.")
            XCTAssert(
                (error as! SwiftTreysError).description
                    == (error as! SwiftTreysError).debugDescription)
        }

        do {
            // Hand and board
            let hand = Card.fromStringList(["As", "Th"])!
            let board = Card.fromStringList(["As", "Qc", "5h", "2d", "4s"])!
            XCTAssertThrowsError(try Evaluator.evaluate(cards: hand, board: board)) { error = $0 }
            XCTAssert(error is SwiftTreysError)
            XCTAssert(error as? SwiftTreysError == .cardsNotUnique)
            XCTAssert(
                (error as! SwiftTreysError).debugDescription
                    == "The cards supplied to the Evaluator were not all unique.")
            XCTAssert(
                (error as! SwiftTreysError).description
                    == (error as! SwiftTreysError).debugDescription)
        }
    }

    func testThrowsInvalidHandRankInteger() throws {
        do {
            // Too low of a rank
            let lowRank = -1
            XCTAssertThrowsError(try Evaluator.getClassRank(handRank: lowRank)) { error = $0 }
            XCTAssert(error is SwiftTreysError)
            XCTAssert(error as? SwiftTreysError == .invalidHandRankInteger(lowRank))
            XCTAssert(
                (error as! SwiftTreysError).debugDescription == """
                    Evaluator method getRankClass(handRank:) \
                    received a hand rank integer representation \
                    of \(lowRank) rather than a value between 0 and 7462.
                    """)
            XCTAssert(
                (error as! SwiftTreysError).description
                    == (error as! SwiftTreysError).debugDescription)
        }

        do {
            // Too high of a rank
            let highRank = 7463
            XCTAssertThrowsError(try Evaluator.getClassRank(handRank: highRank)) { error = $0 }
            XCTAssert(error is SwiftTreysError)
            XCTAssert(error as? SwiftTreysError == .invalidHandRankInteger(highRank))
            XCTAssert(
                (error as! SwiftTreysError).debugDescription == """
                    Evaluator method getRankClass(handRank:) \
                    received a hand rank integer representation \
                    of \(highRank) rather than a value between 0 and 7462.
                    """)
            XCTAssert(
                (error as! SwiftTreysError).description
                    == (error as! SwiftTreysError).debugDescription)
        }
    }

    func testThrowsInvalidHandClassInteger() throws {
        do {
            // Too low of a rank
            let lowRank = 0
            XCTAssertThrowsError(try Evaluator.classRankToString(classRank: lowRank)) { error = $0 }
            XCTAssert(error is SwiftTreysError)
            XCTAssert(error as? SwiftTreysError == .invalidHandClassInteger(lowRank))
            XCTAssert(
                (error as! SwiftTreysError).debugDescription == """
                    Evaluator method classToString(classInt:) \
                    could not look up the hand class integer \
                    \(lowRank). Expected a value from 1 to 9.
                    """)
            XCTAssert(
                (error as! SwiftTreysError).debugDescription
                    == (error as! SwiftTreysError).description)
        }

        do {
            // Too high of a rank
            let highRank = 10
            XCTAssertThrowsError(try Evaluator.classRankToString(classRank: highRank)) {
                error = $0
            }
            XCTAssert(error is SwiftTreysError)
            XCTAssert(error as? SwiftTreysError == .invalidHandClassInteger(highRank))
            XCTAssert(
                (error as! SwiftTreysError).debugDescription == """
                    Evaluator method classToString(classInt:) \
                    could not look up the hand class integer \
                    \(highRank). Expected a value from 1 to 9.
                    """)
            XCTAssert(
                (error as! SwiftTreysError).debugDescription
                    == (error as! SwiftTreysError).description)
        }
    }

    func testThrowsInvalidPokerBoard() throws {
        let hand = Card.fromStringList(["Td", "4h"])!
        do {
            // Too big of a board
            let board = Card.fromStringList(["Ac", "As", "Ad", "Ah", "2c", "2s"])!
            XCTAssertThrowsError(try Evaluator.handSummary(board: board, hands: [hand])) {
                error = $0
            }
            XCTAssert(error is SwiftTreysError)
            XCTAssert(error as? SwiftTreysError == .invalidPokerBoard(incorrectCardCount: 6))
            XCTAssert(
                (error as! SwiftTreysError).debugDescription == """
                    Evaluator method \
                    handSummary(board:hands:) \
                    received a board comprised of \
                    6 cards, rather than 5 cards.
                    """)
            XCTAssert(
                (error as! SwiftTreysError).debugDescription
                    == (error as! SwiftTreysError).description)
        }

        do {
            // Too small of a board
            let board = Card.fromStringList(["Ac", "As", "Ad", "Ah"])!
            XCTAssertThrowsError(try Evaluator.handSummary(board: board, hands: [hand])) {
                error = $0
            }
            XCTAssert(error is SwiftTreysError)
            XCTAssert(error as? SwiftTreysError == .invalidPokerBoard(incorrectCardCount: 4))
            XCTAssert(
                (error as! SwiftTreysError).debugDescription == """
                    Evaluator method \
                    handSummary(board:hands:) \
                    received a board comprised of \
                    4 cards, rather than 5 cards.
                    """)
            XCTAssert(
                (error as! SwiftTreysError).debugDescription
                    == (error as! SwiftTreysError).description)
        }
    }

    func testThrowsInvalidPokerHand() throws {
        let board = Card.fromStringList(["Ac", "2d", "Qh", "Ad", "5s"])!
        do {
            // One hand too small
            let hand1 = Card.fromStringList(["5c", "Td"])!
            let hand2 = Card.fromStringList(["7h"])!
            XCTAssertThrowsError(try Evaluator.handSummary(board: board, hands: [hand1, hand2])) {
                error = $0
            }
            XCTAssert(error is SwiftTreysError)
            XCTAssert(error as? SwiftTreysError == .invalidPokerHand(incorrectCardCount: 1))
            XCTAssert(
                (error as! SwiftTreysError).debugDescription == """
                    Evaluator method \
                    handSummary(board:hands:) \
                    did not receive a list of valid \
                    poker hands comprised of 2 cards \
                    each. Got a hand with 1 card(s) \
                    instead.
                    """)
            XCTAssert(
                (error as! SwiftTreysError).debugDescription
                    == (error as! SwiftTreysError).description)
        }

        do {
            // One hand too large
            let hand1 = Card.fromStringList(["5c", "Td"])!
            let hand2 = Card.fromStringList(["7h", "8d", "4d"])!
            XCTAssertThrowsError(try Evaluator.handSummary(board: board, hands: [hand1, hand2])) {
                error = $0
            }
            XCTAssert(error is SwiftTreysError)
            XCTAssert(error as? SwiftTreysError == .invalidPokerHand(incorrectCardCount: 3))
            XCTAssert(
                (error as! SwiftTreysError).debugDescription == """
                    Evaluator method \
                    handSummary(board:hands:) \
                    did not receive a list of valid \
                    poker hands comprised of 2 cards \
                    each. Got a hand with 3 card(s) \
                    instead.
                    """)
            XCTAssert(
                (error as! SwiftTreysError).debugDescription
                    == (error as! SwiftTreysError).description)
        }
    }
}
