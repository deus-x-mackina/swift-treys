/**
    Class representing a deck. The first time we create, we seed the static
    deck with the list of unique card integers. Each object instantiated simply
    makes a copy of this object and shuffles it.
*/
public struct Deck {
    private static let fullDeck: [Card] = generateFullDeck()
    private var cards = [Card]()

    public init() {
        cards = Self.fullDeck.shuffled()
    }

    public mutating func draw(_ n: Int = 1) -> [Card] {
        if n == 1 {
            guard let card = cards.popLast() else { return [] }
            return [card]
        }
        var cards = [Card]()
        for _ in 0..<n { cards.append(contentsOf: draw()) }
        return cards
    }

    private static func generateFullDeck() -> [Card] {
        Rank.allCases.flatMap { rank in
            Suit.allCases.map { suit in
                Card(rank, suit)
            }
        }
    }
}

extension Deck: CustomStringConvertible {
    public var description: String {
        Card.prettyCards(cards)
    }
}

extension Deck: Collection {
    public func index(after i: Deck.Index) -> Deck.Index {
        cards.index(after: i)
    }

    public subscript(position: Deck.Index) -> Deck.Element {
        cards[position]
    }
    public var startIndex: Array<Card>.Index {
        cards.startIndex
    }

    public var endIndex: Array<Card>.Index {
        cards.endIndex
    }

    public typealias Element = Card
    public typealias Index = Array<Card>.Index
}

extension Deck: Codable {}
