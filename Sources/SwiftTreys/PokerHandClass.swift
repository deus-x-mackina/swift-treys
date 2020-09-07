/// An enumeration type representing every possible classification
/// for a poker hand, such as flush, two pair, straight, etc.
public enum PokerHandClass: String {
    case highCard = "High Card"
    case pair = "Pair"
    case twoPair = "Two Pair"
    case threeOfAKind = "Three of a Kind"
    case straight = "Straight"
    case flush = "Flush"
    case fullHouse = "Full House"
    case fourOfAKind = "Four of a Kind"
    case straightFlush = "Straight Flush"

    private static var ranks = LookupTable.RANK_CLASS_TO_POKER_HAND.swappingKeysAndValues()!
}

extension PokerHandClass: Hashable {}

extension PokerHandClass: Codable {}

extension PokerHandClass: Comparable {
    public static func < (lhs: PokerHandClass, rhs: PokerHandClass) -> Bool {
        PokerHandClass.ranks[lhs]! > PokerHandClass.ranks[rhs]!
    }
}
