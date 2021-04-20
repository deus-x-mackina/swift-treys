internal struct PokerHandRank {
  internal let rank: Int16

  internal static let best = Self(rank: 1)
  internal static let worst = Self(rank: MAX_HIGH_CARD)

  internal func isBetterThan(_ other: Self) -> Bool {
    rank < other.rank
  }
}

extension PokerHandRank: Equatable {}

extension PokerHandRank: Hashable {}

extension PokerHandRank: Codable {}
