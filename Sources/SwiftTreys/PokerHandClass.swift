/// The various classifications of poker hands.
public enum PokerHandClass {
  /// A high card hand.
  case highCard(highRank: Rank)

  /// A pair.
  case pair(pair: Rank)

  /// Two pair.
  case twoPair(highPair: Rank, lowPair: Rank)

  /// Three of a kind.
  case threeOfAKind(trips: Rank)

  /// A straight.
  case straight(highRank: Rank)

  /// A flush.
  case flush(highRank: Rank)

  /// A full house.
  case fullHouse(trips: Rank, pair: Rank)

  /// Four of a kind.
  case fourOfAKind(quads: Rank)

  /// A straight flush (includes royal flushes).
  case straightFlush(highRank: Rank)
}

extension PokerHandClass: Equatable {}
