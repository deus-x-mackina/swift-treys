/// An enumeration type representing the four suits
/// that a `Card` can have.
public enum Suit: Int8 {
  /// The suit of clubs.
  case clubs = 8

  /// The suit of hearts.
  case hearts = 2

  /// The suit of spades.
  case spades = 1

  /// The suit of diamonds.
  case diamonds = 4

  /// Attempt to create a `Suit` from its single-character representation.
  ///
  /// Fails unless passed one of "chsd".
  public init?(_ ch: Character) {
    switch ch {
    case "c": self = .clubs
    case "h": self = .hearts
    case "d": self = .diamonds
    case "s": self = .spades
    default: return nil
    }
  }

  /// The single-character representation for this `Suit`.
  public func asCharacter() -> Character {
    switch self {
    case .clubs: return "c"
    case .hearts: return "h"
    case .diamonds: return "d"
    case .spades: return "s"
    }
  }

  /// The single-character representation for this `Suit` using their
  /// dedicated Unicode symbols.
  public func asPrettyCharacter() -> Character {
    switch self {
    case .clubs: return "\u{2663}"
    case .hearts: return "\u{2665}"
    case .diamonds: return "\u{2666}"
    case .spades: return "\u{2660}"
    }
  }
}

extension Suit: CaseIterable {}

extension Suit: Hashable {}

extension Suit: Equatable {}

extension Suit: CustomStringConvertible {
  public var description: String {
    String(asPrettyCharacter())
  }
}

extension Suit: Codable {}
