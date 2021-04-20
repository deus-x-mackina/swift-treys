/// The result of a poker hand evaluation.
public struct Evaluation {
  internal let metadata: PokerHandMetadata

  internal init(metadata: PokerHandMetadata) {
    self.metadata = metadata
  }

  /// The worst possible poker hand `Evaluation`.
  public static let worst = Self(metadata: .worst)

  /// The best possible poker hand `Evaluation`.
  public static let best = Self(metadata: .best)

  internal var handRank: PokerHandRank {
    metadata.handRank
  }

  /// Get the class of poker hand corresponding to this `Evaluation`.
  ///
  /// This can be convenient in `switch` or `if/guard let` expressions,
  /// instead of using one of the `is...` properties.
  public var `class`: PokerHandClass {
    metadata.class
  }

  /// Whether this `Evaluation` corresponds to a high card hand.
  public var isHighCard: Bool {
    metadata.isHighCard
  }

  /// Whether this `Evaluation` corresponds to a pair.
  public var isPair: Bool {
    metadata.isPair
  }

  /// Whether this `Evaluation` corresponds to a two pair.
  public var isTwoPair: Bool {
    metadata.isTwoPair
  }

  /// Whether this `Evaluation` corresponds to a three-of-a-kind.
  public var isThreeOfAKind: Bool {
    metadata.isThreeOfAKind
  }

  /// Whether this `Evaluation` corresponds to a straight.
  public var isStraight: Bool {
    metadata.isStraight
  }

  /// Whether this `Evaluation` corresponds to a flush.
  public var isFlush: Bool {
    metadata.isFlush
  }

  /// Whether this `Evaluation` corresponds to a full house.
  public var isFullHouse: Bool {
    metadata.isFullHouse
  }

  /// Whether this `Evaluation` corresponds to a four of a kind.
  public var isFourOfAKind: Bool {
    metadata.isFourOfAKind
  }

  /// Whether this `Evaluation` corresponds to a straight flush.
  public var isStraightFlush: Bool {
    metadata.isStraightFlush
  }

  /// Whether this `Evaluation` corresponds to a royal flush.
  ///
  /// By definition, this is also a straight flush.
  public var isRoyalFlush: Bool {
    metadata.isRoyalFlush
  }
}

extension Evaluation: CustomStringConvertible {
  public var description: String {
    metadata.description
  }
}

extension Evaluation: Comparable {
  public static func < (lhs: Evaluation, rhs: Evaluation) -> Bool {
    lhs.metadata < rhs.metadata
  }
}

extension Evaluation: Equatable {}

extension Evaluation: Hashable {}
