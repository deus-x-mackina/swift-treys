public enum Rank: String, CaseIterable {
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case ten = "T"
    case jack = "J"
    case queen = "Q"
    case king = "K"
    case ace = "A"
}

extension Rank: Equatable {}

extension Rank: Hashable {}

extension Rank: Codable {}

extension Rank: Comparable {
    public static func < (lhs: Rank, rhs: Rank) -> Bool {
        Card.CHAR_RANK_TO_INT_RANK[Character(lhs.rawValue)]! < Card.CHAR_RANK_TO_INT_RANK[
            Character(rhs.rawValue)]!
    }
}
