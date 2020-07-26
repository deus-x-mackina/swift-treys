public enum SwiftTreysError: Error {
    /**
        `Evaluator` method `evaluate(cards:board:)`
        did not receive a total number of 5 t0 7 cards
    */
    case invalidNumberOfCards(Int)

    /**
        `Evaluator` method `evaluate(cards:board:)`
        did not receive a pool of cards + board that contained
        all unique `Card` instances.
    */
    case cardsNotUnique

    /**
        `Evaluator` method `getRankClass(handRank:)`
        was not passed a valid hand rank value between 0 - 7462
    */
    case invalidHandRankInteger(Int)

    /**
        `Evaluator` method `classToString(classInt:)`
        could not lookup the given hand class integer value
    */
    case invalidHandClassInteger(Int)

    /**
        `Evaluator` method `handSummary(board:hands:)`
        did not receive a valid poker board of 5 dealt cards.
    */
    case invalidPokerBoard(incorrectCardCount: Int)

    /**
        `Evaluator` method `handSummary(board:hands:)`
        did not receive a list of valid poker hands comprised of 2 cards each.
    */
    case invalidPokerHand(incorrectCardCount: Int)
}
