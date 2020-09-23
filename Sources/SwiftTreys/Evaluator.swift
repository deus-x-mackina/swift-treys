/// Evaluates hand strengths using a variant of Cactus Kev's algorithm:
/// http://suffe.cool/poker/evaluator.html.
public struct Evaluator {
    public typealias HandRank = Int
    public typealias ClassRank = Int

    static let table = LookupTable()

    private init() {}

    /// Evaluates given cards and board and returns and integer between 1 and 7462,
    /// with a lower rank being a better poker hand.
    ///
    /// The total number of cards passed to this function
    /// (cards.count + (board?.count ?? 0))
    /// should equal 5, 6, or 7 in order to avoid an error throw.
    ///
    /// - Parameters:
    ///   - cards: A `RangeReplaceableCollection` of `Cards` representing a poker hand.
    ///   - board: A `RangeReplaceableCollection` of five `Card`s to evaulate the hands against.
    /// - Returns: An `Int` representing the best possible hand's rank out of 7462. Lower is better.
    /// - Throws: `SwiftTreysError.cardsNotUnique`, if not all cards passed in are unique.
    ///     `SwiftTreysError.invalidNumberOfCards(_:)` if the total number of `Card`s between `board`
    ///     and `hand` are not between 5 and 7.
    public static func evaluate<T: RangeReplaceableCollection>(cards: T, board: T? = nil) throws
        -> HandRank where T.Element == Card
    {
        let allCards = cards + (board ?? T())
        guard allCards.allUnique else { throw SwiftTreysError.cardsNotUnique }
        switch allCards.count {
        case 5: return five(cards: allCards)
        case let x where x == 6 || x == 7: return sixOrSeven(cards: allCards)
        default: throw SwiftTreysError.invalidNumberOfCards(allCards.count)
        }
    }

    /// Similar to `evaluate(cards:board:)`, but directly returns a string representing
    /// the best poker hand classification given the cards/board passed in.
    ///
    /// This method can throw all the errors that can be thrown by
    /// `evaluate(cards:board:)`, `getClassRank(handRank:)`, and
    /// `classRankToString(classRank:)`.
    ///
    /// - Parameters:
    ///   - cards: A `RangeReplaceableCollection` of `Cards` representing a poker hand.
    ///   - board: A `RangeReplaceableCollection` of five `Card`s to evaulate the hands against.
    /// - Returns: A `String` representing the name of the best hand formed from the cards passed in. For example, "Straight Flush".
    /// - Throws: `SwiftTreysError.cardsNotUnique`, if not all cards passed in are unique.
    ///     `SwiftTreysError.invalidNumberOfCards(_:)` if the total number of `Card`s between `board`
    ///     and `hand` are not between 5 and 7.
    public static func classifyPokerHand<T: RangeReplaceableCollection>(cards: T, board: T? = nil)
        throws -> PokerHandClass where T.Element == Card
    {
        try classRankToPokerHand(
            classRank: getClassRank(handRank: evaluate(cards: cards, board: board)))
    }

    // Performs an evaluation given cards, mapping them to
    // a rank in the range [1, 7462], with lower ranks being more powerful.
    //
    // Variant of Cactus Kev's 5 card evaluator, though I saved a lot of memory
    // space using a hash table and condensing some of the calculations.
    private static func five<T: RangeReplaceableCollection>(cards: T) -> HandRank
    where T.Element == Card {
        // if flush
        if cards.reduce(0xF000, { $0 & $1.binaryInteger }) != 0 {
            let handOR = (cards.reduce(0, { $0 | $1.binaryInteger })) >> 16
            let prime = Card.primeProductFromRankbits(handOR)
            return table.flushLookup[prime]!
        }

        // otherwise
        let prime = Card.primeProductFromHand(cards)
        return table.unsuitedLookup[prime]!
    }

    // If cards.count == 6:
    // Performs five_card_eval() on all (6 choose 5) = 6 subsets
    // of 5 cards in the set of 6 to determine the best ranking,
    // and returns this ranking.
    //
    // If cards.count == 7:
    // Performs five_card_eval() on all (7 choose 5) = 21 subsets
    // of 5 cards in the set of 7 to determine the best ranking,
    // and returns this ranking.
    private static func sixOrSeven<T: RangeReplaceableCollection>(cards: T) -> HandRank
    where T.Element == Card {
        var minimum = LookupTable.MAX_HIGH_CARD
        let allFiveCardCombos = CombinationsGenerator(pool: Array(cards), r: 5)
        for combo in allFiveCardCombos {
            let score = five(cards: combo)
            if score < minimum { minimum = score }
        }
        return minimum
    }

    /// Returns the class of hand given the hand handRank
    /// returned from evaluate.
    ///
    /// - Parameter handRank: The hand rank `Int` type to convert.
    /// - Returns: A class rank `Int` type representing the class of hand corresponding to
    ///     the hand rank.
    /// - Throws: `SwiftTreysError.invalidHandRankInteger(_:)` if `handRank` isn't between
    ///     0 and 7462.
    public static func getClassRank(handRank: HandRank) throws -> ClassRank {
        let lt = LookupTable.self
        let mtr = lt.MAX_TO_RANK_CLASS

        switch handRank {

        case let x where x < 0: throw SwiftTreysError.invalidHandRankInteger(handRank)
        case let x where x >= 0 && x <= lt.MAX_STRAIGHT_FLUSH: return mtr[lt.MAX_STRAIGHT_FLUSH]!
        case let x where x <= lt.MAX_FOUR_OF_A_KIND: return mtr[lt.MAX_FOUR_OF_A_KIND]!
        case let x where x <= lt.MAX_FULL_HOUSE: return mtr[lt.MAX_FULL_HOUSE]!
        case let x where x <= lt.MAX_FLUSH: return mtr[lt.MAX_FLUSH]!
        case let x where x <= lt.MAX_STRAIGHT: return mtr[lt.MAX_STRAIGHT]!
        case let x where x <= lt.MAX_THREE_OF_A_KIND: return mtr[lt.MAX_THREE_OF_A_KIND]!
        case let x where x <= lt.MAX_TWO_PAIR: return mtr[lt.MAX_TWO_PAIR]!
        case let x where x <= lt.MAX_PAIR: return mtr[lt.MAX_PAIR]!
        case let x where x <= lt.MAX_HIGH_CARD: return mtr[lt.MAX_HIGH_CARD]!
        default: throw SwiftTreysError.invalidHandRankInteger(handRank)
        }
    }

    /// Converts the integer class hand score into a human-readable string.
    ///
    /// - Parameter classRank: The class rank `Int` type to convert.
    /// - Returns: The `String` representation of the rank class, i.e., "Straight Flush".
    /// - Throws: `SwiftTreysError.invalidHandClassInteger(_:)` if the class rank is not
    ///     between 1 and 9.
    public static func classRankToPokerHand(classRank: ClassRank) throws -> PokerHandClass {
        guard let result = LookupTable.RANK_CLASS_TO_POKER_HAND[classRank] else {
            throw SwiftTreysError.invalidHandClassInteger(classRank)
        }
        return result
    }

    /// Scales the hand rank score to the [0.0, 1.0] range.
    ///
    /// - Parameter handRank: The hand rank `Int` type to consider.
    /// - Returns: A double representing the precentage of hands `handRank` outranks.
    public static func getFiveCardRankPercentage(handRank: HandRank) -> Double {
        Double(handRank) / Double(LookupTable.MAX_HIGH_CARD)
    }

    /// Gives a summary of the hand with ranks as time proceeds.
    ///
    /// Requires that the board is in chronological order for the
    /// analysis to make sense.
    ///
    /// - Parameters:
    ///   - board: A `RangeReplaceableCollection` of 5 `Card` objects.
    ///   - hands: A 2-dimensional `RangeReplaceableCollection` where each sub-collection is
    ///     comprised of 2 `Card` objects each.
    /// - Throws: `SwiftTreysError.invalidPokerBoard(incorrectCardCount:)` if `board` does not
    ///     consist of 5 `Card` objects.
    ///     `SwiftTreysError.invalidPokerHand(incorrectCardCount:)` if each of the sub-collections
    ///     of `hands` is not comprised of 2 `Card` objects.
    public static func handSummary<T: RangeReplaceableCollection, U: RangeReplaceableCollection>(
        board: T, hands: U
    ) throws where T.Element == Card, T.Index == Int, U.Element == T, U.Index == Int {
        guard board.count == 5 else {
            throw SwiftTreysError.invalidPokerBoard(incorrectCardCount: board.count)
        }

        for hand in hands {
            guard hand.count == 2 else {
                throw SwiftTreysError.invalidPokerHand(incorrectCardCount: hand.count)
            }
        }

        let lineLength = 10
        let stages = ["FLOP", "TURN", "RIVER"]

        for i in 0..<stages.count {
            let line = "=" * lineLength
            print("\(line) \(stages[i]) \(line)")

            var bestRank = 7463  // rank one worse than worst hand
            var winners = [Int]()

            for (player, hand) in hands.enumerated() {
                // evaluate current board position
                let rank = try! evaluate(cards: hand, board: T(board[0..<(i + 3)]))
                let rankClass = try! getClassRank(handRank: rank)
                let classString = try! classRankToPokerHand(classRank: rankClass)
                // higher better here
                let percentage = 1.0 - getFiveCardRankPercentage(handRank: rank)
                print(
                    """
                    Player \(player + 1) hand = \(classString), \
                    percentage rank among all hands = \(percentage)
                    """)

                // detect winner
                if rank == bestRank {
                    winners.append(player)
                    bestRank = rank
                } else if rank < bestRank {
                    winners = [player]
                    bestRank = rank
                }
            }

            // if we're not on the river
            if i != stages.firstIndex(of: "RIVER")! {
                if winners.count == 1 {
                    print("Player \(winners[0] + 1) hand is currently winning.\n")
                } else {
                    print("Players \(winners.map { $0 + 1 }) are tied for the lead.\n")
                }
            }

            // otherwise on all other streets
            else {
                let handResult = try! classRankToPokerHand(
                    classRank: getClassRank(
                        handRank: evaluate(cards: hands[winners[0]], board: board)))
                print("\n\(line) HAND OVER \(line)")
                if winners.count == 1 {
                    print(
                        """
                        Player \(winners[0] + 1) is the winner \
                        with a \(handResult)\n
                        """)
                } else {
                    print(
                        """
                        Players \(winners.map { $0 + 1 }) tied \
                        for the win with a \(handResult)\n
                        """)
                }
            }
        }
    }
}
