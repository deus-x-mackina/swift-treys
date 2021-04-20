/// An enumeration type representing the thirteen possible
/// ranks that a card can have.
public enum Rank: Int8 {
  /// Rank of 2.
  case two = 0

  /// Rank of 3.
  case three

  /// Rank of 4.
  case four

  /// Rank of 5.
  case five

  /// Rank of 6.
  case six

  /// Rank of 7.
  case seven

  /// Rank of 8.
  case eight

  /// Rank of 9.
  case nine

  /// Rank of 10.
  case ten

  /// Rank of jack.
  case jack

  /// Rank of queen.
  case queen

  /// Rank of king.
  case king

  /// Rank of ace.
  case ace

  /// Attempt to create a `Rank` from its single-character representation.
  ///
  /// Fails unless passed one of "23456789TJKQA".
  public init?(_ ch: Character) {
    switch ch {
    case "2": self = .two
    case "3": self = .three
    case "4": self = .four
    case "5": self = .five
    case "6": self = .six
    case "7": self = .seven
    case "8": self = .eight
    case "9": self = .nine
    case "T": self = .ten
    case "J": self = .jack
    case "Q": self = .queen
    case "K": self = .king
    case "A": self = .ace
    default: return nil
    }
  }

  /// The single-character representation for this `Rank`.
  public func asCharacter() -> Character {
    switch self {
    case .two: return "2"
    case .three: return "3"
    case .four: return "4"
    case .five: return "5"
    case .six: return "6"
    case .seven: return "7"
    case .eight: return "8"
    case .nine: return "9"
    case .ten: return "T"
    case .jack: return "J"
    case .queen: return "Q"
    case .king: return "K"
    case .ace: return "A"
    }
  }

  /// The spelled out name of this rank in singular form.
  ///
  /// Used for printing poker hands such as "high card, ace".
  internal var singularStringName: StaticString {
    switch self {
    case .two: return "two"
    case .three: return "three"
    case .four: return "four"
    case .five: return "five"
    case .six: return "six"
    case .seven: return "seven"
    case .eight: return "eight"
    case .nine: return "nine"
    case .ten: return "ten"
    case .jack: return "jack"
    case .queen: return "queen"
    case .king: return "king"
    case .ace: return "ace"
    }
  }

  /// The spelled out name of this rank in plural form.
  ///
  /// Used for printing poker hands such as "pair of twos".
  internal var pluralStringName: StaticString {
    switch self {
    case .two: return "twos"
    case .three: return "threes"
    case .four: return "fours"
    case .five: return "fives"
    case .six: return "sixes"
    case .seven: return "sevens"
    case .eight: return "eights"
    case .nine: return "nines"
    case .ten: return "tens"
    case .jack: return "jacks"
    case .queen: return "queens"
    case .king: return "kings"
    case .ace: return "aces"
    }
  }
}

extension Rank: CaseIterable {}

extension Rank: Hashable {}

extension Rank: Equatable {}

extension Rank: Comparable {
  public static func < (lhs: Rank, rhs: Rank) -> Bool {
    lhs.rawValue < rhs.rawValue
  }
}

extension Rank: CustomStringConvertible {
  public var description: String {
    String(asCharacter())
  }
}

extension Rank: Codable {}
