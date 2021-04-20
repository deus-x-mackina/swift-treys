/// Represents the two possibilities that can prevent a poker hand from being
/// correctly evaluated.
public enum EvaluationError {
  /// This hand contains one of more duplicate `Card`s.
  case cardsNotUnique([Card])

  /// This hand contains 4 or less `Card`s.
  case invalidHandSize(Int)
}

extension EvaluationError: Equatable {}

extension EvaluationError: CustomStringConvertible {
  public var description: String {
    switch self {
    case let .cardsNotUnique(cards):
      var counts = [Card: Int]()
      counts.reserveCapacity(cards.count)
      for card in cards {
        if let count = counts[card] {
          counts[card] = count + 1
        } else {
          counts[card] = 1
        }
      }
      let dups = counts.compactMap { (card: Card, count: Int) -> String? in
        if count > 1 {
          return card.rankSuitString()
        } else {
          return nil
        }
      }.joined(separator: " ")
      return """
      Cannot evaluate a poker hand with a set of cards that \
      are not unique. Cards duplicated at least once: \
      \(dups)
      """
    case let .invalidHandSize(size):
      return """
      Cannot evaluate a poker hand with a set of less than 5 \
      cards. Number of cards received: \(size)
      """
    }
  }
}

extension EvaluationError: Error {}
