/// Represents the three possibilies that can prevent a `Card` from being parsed from a `String`.
public enum ParseCardError {
  /// The `String` did not contain two characters.
  case invalidLength(originalInput: String)

  /// The rank character was not one of "23456789TJQKA".
  case invalidRank(originalInput: String, incorrectChar: Character)

  /// The suit character was not one of "chsd".
  case invalidSuit(originalInput: String, incorrectChar: Character)
}

extension ParseCardError: Equatable {}

extension ParseCardError: CustomStringConvertible {
  public var description: String {
    switch self {
    case let .invalidLength(originalInput: input):
      return """
      Error parsing input '\(input)' as a Card: Found \
      input of length \(input.count), expected 2
      """
    case let .invalidRank(originalInput: input, incorrectChar: ch):
      return """
      Error parsing input '\(input)' as a Card: Invalid \
      rank character '\(ch)', expected one of [23456789TJQKA]
      """
    case let .invalidSuit(originalInput: input, incorrectChar: ch):
      return """
      Error parsing input '\(input)' as a Card: Invalid \
      suit character '\(ch)', expected one of [chsd]
      """
    }
  }
}

extension ParseCardError: Error {}
