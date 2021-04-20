internal enum PokerHandMetadata {
  case highCard(handRank: PokerHandRank, highRank: Rank)
  case pair(handRank: PokerHandRank, pair: Rank)
  case twoPair(handRank: PokerHandRank, highPair: Rank, lowPair: Rank)
  case threeOfAKind(handRank: PokerHandRank, trips: Rank)
  case straight(handRank: PokerHandRank, highRank: Rank)
  case flush(handRank: PokerHandRank, highRank: Rank)
  case fullHouse(handRank: PokerHandRank, trips: Rank, pair: Rank)
  case fourOfAKind(handRank: PokerHandRank, quads: Rank)
  case straightFlush(handRank: PokerHandRank, highRank: Rank)

  static let best: Self = .straightFlush(
    handRank: .best,
    highRank: .ace
  )

  static let worst: Self = .highCard(
    handRank: .worst,
    highRank: .seven
  )

  var handRank: PokerHandRank {
    switch self {
    case .highCard(handRank: let rank, highRank: _),
         .pair(handRank: let rank, pair: _),
         .twoPair(handRank: let rank, highPair: _, lowPair: _),
         .threeOfAKind(handRank: let rank, trips: _),
         .straight(handRank: let rank, highRank: _),
         .flush(handRank: let rank, highRank: _),
         .fullHouse(handRank: let rank, trips: _, pair: _),
         .fourOfAKind(handRank: let rank, quads: _),
         .straightFlush(handRank: let rank, highRank: _):
      return rank
    }
  }

  var `class`: PokerHandClass {
    switch self {
    case .highCard(handRank: _, highRank: let rank):
      return .highCard(highRank: rank)
    case .pair(handRank: _, pair: let rank):
      return .pair(pair: rank)
    case .twoPair(handRank: _, highPair: let rank1, lowPair: let rank2):
      return .twoPair(highPair: rank1, lowPair: rank2)
    case .threeOfAKind(handRank: _, trips: let rank):
      return .threeOfAKind(trips: rank)
    case .straight(handRank: _, highRank: let rank):
      return .straight(highRank: rank)
    case .flush(handRank: _, highRank: let rank):
      return .flush(highRank: rank)
    case .fullHouse(handRank: _, trips: let rank1, pair: let rank2):
      return .fullHouse(trips: rank1, pair: rank2)
    case .fourOfAKind(handRank: _, quads: let rank):
      return .fourOfAKind(quads: rank)
    case .straightFlush(handRank: _, highRank: let rank):
      return .straightFlush(highRank: rank)
    }
  }

  var isHighCard: Bool {
    if case .highCard(handRank: _, highRank: _) = self {
      return true
    } else {
      return false
    }
  }

  var isPair: Bool {
    if case .pair(handRank: _, pair: _) = self {
      return true
    } else {
      return false
    }
  }

  var isTwoPair: Bool {
    if case .twoPair(handRank: _, highPair: _, lowPair: _) = self {
      return true
    } else {
      return false
    }
  }

  var isThreeOfAKind: Bool {
    if case .threeOfAKind(handRank: _, trips: _) = self {
      return true
    } else {
      return false
    }
  }

  var isStraight: Bool {
    if case .straight(handRank: _, highRank: _) = self {
      return true
    } else {
      return false
    }
  }

  var isFlush: Bool {
    if case .flush(handRank: _, highRank: _) = self {
      return true
    } else {
      return false
    }
  }

  var isFullHouse: Bool {
    if case .fullHouse(handRank: _, trips: _, pair: _) = self {
      return true
    } else {
      return false
    }
  }

  var isFourOfAKind: Bool {
    if case .fourOfAKind(handRank: _, quads: _) = self {
      return true
    } else {
      return false
    }
  }

  var isStraightFlush: Bool {
    if case .straightFlush(handRank: _, highRank: _) = self {
      return true
    } else {
      return false
    }
  }

  var isRoyalFlush: Bool {
    if case .straightFlush(handRank: .best, highRank: _) = self {
      return true
    } else {
      return false
    }
  }
}

extension PokerHandMetadata: Equatable {
  static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.handRank == rhs.handRank
  }
}

extension PokerHandMetadata: Comparable {
  static func < (lhs: Self, rhs: Self) -> Bool {
    let handRankLeft = lhs.handRank
    let handRankRight = rhs.handRank
    if !handRankLeft.isBetterThan(handRankRight) {
      return true
    } else {
      return false
    }
  }
}

extension PokerHandMetadata: Hashable {
  func hash(into hasher: inout Hasher) {
    handRank.hash(into: &hasher)
  }
}

extension PokerHandMetadata: CustomStringConvertible {
  var description: String {
    switch self {
    case .highCard(handRank: _, highRank: let rank):
      return "High card, \(rank.singularStringName)"
    case .pair(handRank: _, pair: let rank):
      return "Pair, \(rank.pluralStringName)"
    case .twoPair(handRank: _, highPair: let pair1, lowPair: let pair2):
      return """
      Two pair, \(pair1.pluralStringName) and \
      \(pair2.pluralStringName)
      """
    case .threeOfAKind(handRank: _, trips: let rank):
      return "Three of a kind, \(rank.pluralStringName)"
    case .straight(handRank: _, highRank: let rank):
      return "Straight, \(rank.singularStringName)-high"
    case .flush(handRank: _, highRank: let rank):
      return "Flush, \(rank.singularStringName)-high"
    case .fullHouse(handRank: _, let trips, let pair):
      return "Full house, \(trips.pluralStringName) over \(pair.pluralStringName)"
    case .fourOfAKind(handRank: _, quads: let rank):
      return "Four of a kind, \(rank.pluralStringName)"
    case .straightFlush(handRank: _, highRank: let rank):
      return "Straight flush, \(rank.singularStringName)-high"
    }
  }
}

extension PokerHandMetadata: Codable {
  internal enum CodingKeys: CodingKey {
    case highCard
    case pair
    case twoPair
    case threeOfAKind
    case straight
    case flush
    case fullHouse
    case fourOfAKind
    case straightFlush
  }

  internal init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    guard let key = container.allKeys.first else {
      throw DecodingError.dataCorrupted(
        DecodingError.Context(
          codingPath: container.codingPath,
          debugDescription: "Couldn't decode enum case for `PokerHandMetadata`"
        )
      )
    }

    switch key {
    case .highCard:
      var nested = try container.nestedUnkeyedContainer(forKey: .highCard)
      let handRank = try nested.decode(PokerHandRank.self)
      let highRank = try nested.decode(Rank.self)
      self = .highCard(handRank: handRank, highRank: highRank)
    case .pair:
      var nested = try container.nestedUnkeyedContainer(forKey: .pair)
      let handRank = try nested.decode(PokerHandRank.self)
      let pair = try nested.decode(Rank.self)
      self = .pair(handRank: handRank, pair: pair)
    case .twoPair:
      var nested = try container.nestedUnkeyedContainer(forKey: .twoPair)
      let handRank = try nested.decode(PokerHandRank.self)
      let highPair = try nested.decode(Rank.self)
      let lowPair = try nested.decode(Rank.self)
      self = .twoPair(handRank: handRank, highPair: highPair, lowPair: lowPair)
    case .threeOfAKind:
      var nested = try container.nestedUnkeyedContainer(forKey: .threeOfAKind)
      let handRank = try nested.decode(PokerHandRank.self)
      let trips = try nested.decode(Rank.self)
      self = .threeOfAKind(handRank: handRank, trips: trips)
    case .straight:
      var nested = try container.nestedUnkeyedContainer(forKey: .straight)
      let handRank = try nested.decode(PokerHandRank.self)
      let highRank = try nested.decode(Rank.self)
      self = .straight(handRank: handRank, highRank: highRank)
    case .flush:
      var nested = try container.nestedUnkeyedContainer(forKey: .flush)
      let handRank = try nested.decode(PokerHandRank.self)
      let highRank = try nested.decode(Rank.self)
      self = .flush(handRank: handRank, highRank: highRank)
    case .fullHouse:
      var nested = try container.nestedUnkeyedContainer(forKey: .fullHouse)
      let handRank = try nested.decode(PokerHandRank.self)
      let trips = try nested.decode(Rank.self)
      let pair = try nested.decode(Rank.self)
      self = .fullHouse(handRank: handRank, trips: trips, pair: pair)
    case .fourOfAKind:
      var nested = try container.nestedUnkeyedContainer(forKey: .fourOfAKind)
      let handRank = try nested.decode(PokerHandRank.self)
      let quads = try nested.decode(Rank.self)
      self = .fourOfAKind(handRank: handRank, quads: quads)
    case .straightFlush:
      var nested = try container.nestedUnkeyedContainer(forKey: .straightFlush)
      let handRank = try nested.decode(PokerHandRank.self)
      let highRank = try nested.decode(Rank.self)
      self = .straightFlush(handRank: handRank, highRank: highRank)
    }
  }

  internal func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    switch self {
    case let .highCard(handRank, highRank):
      var nested = container.nestedUnkeyedContainer(forKey: .highCard)
      try nested.encode(handRank)
      try nested.encode(highRank)
    case let .pair(handRank, pair):
      var nested = container.nestedUnkeyedContainer(forKey: .pair)
      try nested.encode(handRank)
      try nested.encode(pair)
    case let .twoPair(handRank, highPair, lowPair):
      var nested = container.nestedUnkeyedContainer(forKey: .twoPair)
      try nested.encode(handRank)
      try nested.encode(highPair)
      try nested.encode(lowPair)
    case let .threeOfAKind(handRank, trips):
      var nested = container.nestedUnkeyedContainer(forKey: .threeOfAKind)
      try nested.encode(handRank)
      try nested.encode(trips)
    case let .straight(handRank, highRank):
      var nested = container.nestedUnkeyedContainer(forKey: .straight)
      try nested.encode(handRank)
      try nested.encode(highRank)
    case let .flush(handRank, highRank):
      var nested = container.nestedUnkeyedContainer(forKey: .flush)
      try nested.encode(handRank)
      try nested.encode(highRank)
    case let .fullHouse(handRank, trips, pair):
      var nested = container.nestedUnkeyedContainer(forKey: .fullHouse)
      try nested.encode(handRank)
      try nested.encode(trips)
      try nested.encode(pair)
    case let .fourOfAKind(handRank, quads):
      var nested = container.nestedUnkeyedContainer(forKey: .fourOfAKind)
      try nested.encode(handRank)
      try nested.encode(quads)
    case let .straightFlush(handRank, highRank):
      var nested = container.nestedUnkeyedContainer(forKey: .straightFlush)
      try nested.encode(handRank)
      try nested.encode(highRank)
    }
  }
}
