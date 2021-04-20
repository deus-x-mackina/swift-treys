import Algorithms

/// Manages the evaluation of poker hands.
public enum Evaluator {
  internal static let lookupTable = LookupTable()

  /// Attempt to evaluate a collection of `Card` instances.
  ///
  /// An error is thrown if the cards are not all unique or
  /// there are 4 or less cards present in the collection.
  public static func evaluate<C: Collection>(cards: C) throws -> Evaluation
    where C.Element == Card, C.Index == Int
  {
    guard cards.allUnique else {
      throw EvaluationError.cardsNotUnique(Array(cards))
    }
    switch cards.count {
    case let x where x < 5: throw EvaluationError.invalidHandSize(x)
    case 5: return five(cards)
    default: return sixPlus(cards)
    }
  }

  /// Attempt to evaluate a hand in the context of a board.
  ///
  /// This is a convenicnece overload `evaluate(cards:)` that combines `hand` and `board` together for
  /// evaluation. The rules pertaining to cards needing to be unique and the total number of cards being
  /// five or greater applies to `hand + board` as a whole.
  public static func evaluate<C: RangeReplaceableCollection>(hand: C, board: C) throws -> Evaluation
    where C.Element == Card, C.Index == Int
  {
    try evaluate(cards: hand + board)
  }

  internal static func five<C: Collection>(_ cards: C) -> Evaluation where C.Element == Card, C.Index == Int {
    assert(cards.count == 5)
    let detectFlush = cards.reduce(into: 0xF000) { acc, next in
      acc &= next.uniqueInteger
    } != 0
    if detectFlush {
      let bitRankOr = cards.reduce(into: 0) { acc, next in
        acc |= next.uniqueInteger
      } >> 16
      let prime = primeProductFromRankBits(Int16(bitRankOr))
      return Evaluation(
        metadata: lookupTable.flushLookup[prime]!
      )
    } else {
      let prime = primeProductFromHand(cards)
      return Evaluation(
        metadata: lookupTable.unsuitedLookup[prime]!
      )
    }
  }

  internal static func sixPlus<C: Collection>(_ cards: C) -> Evaluation where C.Element == Card, C.Index == Int {
    assert(cards.count > 5)
    var currentMax: Evaluation = .worst
    let allFiveCardCombinations = cards.combinations(ofCount: 5)
    for combo in allFiveCardCombinations {
      let score = five(combo)
      if score > currentMax {
        currentMax = score
      }
    }
    return currentMax
  }
}
