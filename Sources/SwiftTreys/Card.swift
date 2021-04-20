/// Structure that wraps cards which are represented as 32-bit integers.
///
/// Most of the bits are used, and have a specific meaning. See below.
///
///                                 Card:
///
///                       bitrank     suit rank   prime
///                 +--------+--------+--------+--------+
///                 |xxxbbbbb|bbbbbbbb|cdhsrrrr|xxpppppp|
///                 +--------+--------+--------+--------+
///
/// 1) p = prime number of rank (deuce=2,trey=3,four=5,...,ace=41)
/// 2) r = rank of card (deuce=0,trey=1,four=2,five=3,...,ace=12)
/// 3) cdhs = suit of card (bit turned on based on suit of card)
/// 4) b = bit turned on depending on rank of card
/// 5) x = unused
///
/// This representation will allow us to do very important things like:
/// - Make a unique prime product for each hand
/// - Detect flushes
/// - Detect straights
///
/// and is also quite performant.
public struct Card {
  /// The unique binary representation of this `Card`'s rank and suit information.
  public let uniqueInteger: Int32

  /// Create a `Card` with the given `Rank` and `Suit` values.
  public init(_ rank: Rank, _ suit: Suit) {
    let rankInt = Int32(rank.rawValue)
    let suitInt = Int32(suit.rawValue)
    let rankPrime = PRIMES[Int(rankInt)]
    let bitRank: Int32 = (1 << rankInt) << 16
    let cardSuit = suitInt << 12
    let cardRank = rankInt << 8
    uniqueInteger = bitRank | cardSuit | cardRank | rankPrime
  }

  /// Attempt to create a `Card` using the single-character representations of
  /// its `Rank` and `Suit`.
  ///
  /// Fails unless
  /// - `rankChar` is one of "23456789TJQKA"
  /// - `suitChar` is one of "chsd"
  public init(rankChar: Character, suitChar: Character) throws {
    guard let rank = Rank(rankChar) else {
      throw ParseCardError.invalidRank(
        originalInput: String(rankChar),
        incorrectChar: rankChar
      )
    }
    guard let suit = Suit(suitChar) else {
      throw ParseCardError.invalidSuit(
        originalInput: String(suitChar),
        incorrectChar: suitChar
      )
    }
    self.init(rank, suit)
  }

  /// This `Card`'s `Rank` value, derived from its `uniqueInteger`.
  public var rank: Rank {
    let rankInt = (uniqueInteger >> 8) & 0xF
    return Rank(rawValue: Int8(rankInt))!
  }

  /// This `Card`'s `Suit` value, derived from its `uniqueInteger`.
  public var suit: Suit {
    let suitInt = (uniqueInteger >> 12) & 0xF
    return Suit(rawValue: Int8(suitInt))!
  }

  /// Obtain a two-character string that contains this `Card`'s `Rank` character
  /// followed by its `Suit` character.
  ///
  /// For example, the ten of clubs would yield "Tc".
  public func rankSuitString() -> String {
    "\(rank.asCharacter())\(suit.asCharacter())"
  }

  /// Generate an array of the 52 distinct `Card` combinations.
  public static func generateDeck(shuffle: Bool = true) -> [Card] {
    var deck = [Card]()
    deck.reserveCapacity(52)
    for rank in Rank.allCases {
      for suit in Suit.allCases {
        deck.append(Card(rank, suit))
      }
    }
    if shuffle {
      deck.shuffle()
    }
    return deck
  }

  /// Attempt to parse a `Card` given the two-character representation of its `Rank`
  /// and `Suit`.
  ///
  /// For example, if you wanted to parse the queen of spades successfully, pass
  /// "Qs" to this function.
  public static func parse<S: StringProtocol>(_ str: S) throws -> Self {
    var chars = str.makeIterator()
    guard let rank = chars.next(),
          let suit = chars.next(),
          case .none = chars.next()
    else {
      throw ParseCardError.invalidLength(originalInput: String(str))
    }

    let card: Card
    do {
      card = try Card(rankChar: rank, suitChar: suit)
    } catch let ParseCardError.invalidRank(originalInput: _, incorrectChar: ch) {
      throw ParseCardError.invalidRank(
        originalInput: String(str),
        incorrectChar: ch
      )
    } catch let ParseCardError.invalidSuit(originalInput: _, incorrectChar: ch) {
      throw ParseCardError.invalidSuit(
        originalInput: String(str),
        incorrectChar: ch
      )
    }
    return card
  }

  /// Attempt to parse an array of `Card`s from an array of two-character string
  /// representations.
  ///
  /// This function throws the first error it encounters while parsing.
  public static func parseArray<Str, Seq>(strings: Seq) throws -> [Card]
    where
    Str: StringProtocol,
    Seq: Sequence,
    Seq.Element == Str
  {
    var cards = [Card]()
    cards.reserveCapacity(strings.underestimatedCount)
    for string in strings {
      let card = try Card.parse(string)
      cards.append(card)
    }
    return cards
  }

  /// Attempt to parse an array of `Card`s from an array of two-character string
  /// representations.
  ///
  /// The reulsting array will contain a `nil` value upon failure, but all input
  /// strings will be processed.
  public static func parseOptionalArray<Str, Seq>(strings: Seq) -> [Self?]
    where
    Str: StringProtocol,
    Seq: Sequence,
    Seq.Element == Str
  {
    var cards = [Card?]()
    cards.reserveCapacity(strings.underestimatedCount)
    for string in strings {
      let card = try? Card.parse(string)
      cards.append(card)
    }
    return cards
  }
}

extension Card: Equatable {}

extension Card: Hashable {}

extension Card: Comparable {
  public static func < (lhs: Card, rhs: Card) -> Bool {
    lhs.rank < rhs.rank
  }
}

extension Card: CustomDebugStringConvertible {
  public var debugDescription: String {
    "Card { uniqueInteger: \(uniqueInteger), rank: \(rank), suit: \(suit.asCharacter()) }"
  }
}

extension Card: CustomStringConvertible {
  public var description: String {
    "[ \(rank)\(suit) ]"
  }
}

extension Card: Codable {}
