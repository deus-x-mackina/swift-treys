/// The errors that can be thrown by the `SwiftTreys` module.
public enum SwiftTreysError: Error {
    /// `Evaluator` method `evaluate(cards:board:)` did not receive a total number of 5 to 7 cards
    case invalidNumberOfCards(Int)

    /// `Evaluator` method `evaluate(cards:board:)`
    /// did not receive a pool of cards + board that contained
    /// all unique `Card` instances.
    case cardsNotUnique

    /// `Evaluator` method `getRankClass(handRank:)` was not passed a valid hand rank value
    /// between 0 - 7462
    case invalidHandRankInteger(Int)

    /// `Evaluator` method `classToString(classInt:)`
    /// could not lookup the given hand class integer value
    case invalidHandClassInteger(Int)

    /// `Evaluator` method `handSummary(board:hands:)`
    /// did not receive a valid poker board of 5 dealt cards.
    case invalidPokerBoard(incorrectCardCount: Int)

    /// `Evaluator` method `handSummary(board:hands:)`
    /// did not receive a list of valid poker hands comprised of 2 cards each.
    case invalidPokerHand(incorrectCardCount: Int)
}

extension SwiftTreysError: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        switch self {
        case let .invalidNumberOfCards(n):
            return """
                Evaluator method evaluate(cards:board:) received \
                \(n) cards instead of 5 - 7 cards.
                """
        case .cardsNotUnique: return "The cards supplied to the Evaluator were not all unique."
        case let .invalidHandRankInteger(n):
            return """
                Evaluator method getRankClass(handRank:) \
                received a hand rank integer representation \
                of \(n) rather than a value between 0 and 7462.
                """
        case let .invalidHandClassInteger(n):
            return """
                Evaluator method classToString(classInt:) \
                could not look up the hand class integer \
                \(n). Expected a value from 1 to 9.
                """
        case let .invalidPokerBoard(incorrectCardCount: n):
            return """
                Evaluator method \
                handSummary(board:hands:) \
                received a board comprised of \
                \(n) cards, rather than 5 cards.
                """
        case let .invalidPokerHand(incorrectCardCount: n):
            return """
                Evaluator method \
                handSummary(board:hands:) \
                did not receive a list of valid \
                poker hands comprised of 2 cards \
                each. Got a hand with \(n) card(s) \
                instead.
                """
        }
    }
    public var debugDescription: String { description }
}

extension SwiftTreysError: Equatable {}

extension SwiftTreysError: Hashable {}
