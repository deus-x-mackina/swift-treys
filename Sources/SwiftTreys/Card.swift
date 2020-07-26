/**
    Structure that wraps cards which are represented as 32-bit integers.
    Most of the bits are used, and have a specific meaning. See below:

                                    Card:

                          bitrank     suit rank   prime
                    +--------+--------+--------+--------+
                    |xxxbbbbb|bbbbbbbb|cdhsrrrr|xxpppppp|
                    +--------+--------+--------+--------+

    1) p = prime number of rank (deuce=2,trey=3,four=5,...,ace=41)
    2) r = rank of card (deuce=0,trey=1,four=2,five=3,...,ace=12)
    3) cdhs = suit of card (bit turned on based on suit of card)
    4) b = bit turned on depending on rank of card
    5) x = unused

    This representation will allow us to do very important things like:
    - Make a unique prime prodcut for each hand
    - Detect flushes
    - Detect straights

    and is also quite performant.
*/
public struct Card {
    // The basics
    static let STR_RANKS = Array("23456789TJQKA")
    static let INT_RANKS = 0...12
    static let PRIMES = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41]


    // Conversion from String => Int
    static let CHAR_RANK_TO_INT_RANK: [Character: Int] = Dictionary(
        uniqueKeysWithValues: zip(STR_RANKS, INT_RANKS)
    )
    static let CHAR_SUIT_TO_INT_SUIT: [Character: Int] = [
        "s": 1, // spades
        "h": 2, // hearts
        "d": 4, // diamonds
        "c": 8, // clubs
    ]
    static let INT_SUIT_TO_CHAR_SUIT = Array("xshxdxxxc")

    // For pretty printing
    static let PRETTY_SUITS = [
        1: "\u{9824}",
        2: "\u{9829}",
        4: "\u{9830}",
        8: "\u{9827}",
    ]

    // Hearts and diamonds
    static let PRETTY_REDS = [2, 4]

    let binaryInteger: Int
    public let rank: Rank
    public let suit: Suit

    /**
        Converts Card string to binary integer representation of card, inspired by:
        http://www.suffecool.net/poker/evaluator.html

        This representation is stored within self.binaryInteger

        Returns `nil` if the input string cannot be correctly parsed
    */
    public init(_ rank: Rank, _ suit: Suit) {
        self.rank = rank
        self.suit = suit
        let rankChar = rank.rawValue
        let suitChar = suit.rawValue

        let rankInt = Self.CHAR_RANK_TO_INT_RANK[rankChar]!
        let suitInt = Self.CHAR_SUIT_TO_INT_SUIT[suitChar]!
        let rankPrime = Self.PRIMES[rankInt]

        let bitRank = (1 << rankInt) << 16
        let cardSuit = suitInt << 12
        let cardRank = rankInt << 8

        binaryInteger = bitRank | cardSuit | cardRank | rankPrime
    }

    static func intToStr(_ cardInt: Int) -> String? {
        let rankInt = getRankInt(cardInt)
        let suitInt = getSuitInt(cardInt)

        guard let rankChar = STR_RANKS[safe: rankInt],
              let suitChar = INT_SUIT_TO_CHAR_SUIT[safe: suitInt] else { return nil }
        return String(rankChar) + String(suitChar)
    }

    static func getRankInt(_ cardInt: Int) -> Int {
        (cardInt >> 8) & 0xF
    }

    static func getSuitInt(_ cardInt: Int) -> Int {
        (cardInt >> 12) & 0xF
    }

    static func getBitRankInt(_ cardInt: Int) -> Int {
        (cardInt >> 16) & 0x1FFF
    }

    static func getPrime(_ cardInt: Int) -> Int {
        cardInt & 0x3F
    }

    /**
        Expects a list of cards as strings and returns a list
        of Cards of same length corresponding to those strings.

        The function will return `nil` unless each string in the list is:

        - exactly two characters long
        - the first character (rank) is one of [23456789TJQK]
        - the second character (suit) is one of [chsd]

        Example:

            let validStrings = ["As", "Qh", "Tc", "5d"]
            let invalidStrings = ["ace of spades", "QH", "10c", "5 diamonds"]
            let notNil: [Card]? = Card.fromStringList(validStrings)  // input successfully parsed
            let nil: [Card]? = Card.fromStringList(invalidStrings)  // input could not be parsed
    */
    public static func fromStringList(_ strings: [String]) -> [Card]? {
        var cards = [Card]()
        for str in strings {
            guard str.count == 2 else { return nil }
            let rankChar = str[str.startIndex]
            let suitCar = str[str.index(after: str.startIndex)]
            guard let rank = Rank(rawValue: rankChar),
                  let suit = Suit(rawValue: suitCar) else { return nil }
            cards.append(Card(rank, suit))
        }
        return cards
    }

    /// Expects a list of cards
    static func primeProductFromHand<T: RangeReplaceableCollection>(_ cards: T) -> Int
        where T.Element == Card {
        cards.reduce(1) {
            $0 * ($1.binaryInteger & 0xFF)
        }
    }

    static func primeProductFromRankbits(_ rankbits: Int) -> Int {
        var product = 1
        INT_RANKS.forEach {
            // if the ith bit is set
            if rankbits & (1 << $0) != 0 {
                product *= PRIMES[$0]
            }
        }
        return product
    }

    /// For debugging purposes. Displays the binary number as a
    /// human readable string in groups of four digits.
    static func intToBinary(_ cardInt: Int) -> String {

        // swift does not produce "0b..." like Python
        let bstr = String(cardInt, radix: 2).reversed()

        // output = list("".join(["0000" + "\t"] * 7) + "0000")
        var output = Array("".join(["0000" + "\t"] * 7) + "0000")

        (0..<bstr.count).forEach {
            output[$0 + Int($0 / 4)] = bstr[
                bstr.index(bstr.startIndex, offsetBy: $0)
                ]
        }

        output.reverse()
        return "".join(output.map { String($0) })
    }

    /// Prints a single card
    static func intToPrettyStr(_ cardInt: Int) -> String {
        let suitInt = getSuitInt(cardInt)
        let rankInt = getRankInt(cardInt)

        // If we need to color red
        var s = PRETTY_SUITS[suitInt]!
        if PRETTY_REDS.contains(suitInt) {
            s = "\u{001b}[31m" + s + "\u{001b}[0m"
        }
        let r = STR_RANKS[rankInt]
        return "[\(r)\(s)]"
    }

    // Renamed from original as the function does not print
    // anything.
    static func prettyCard(_ cardInt: Int) -> String {
        intToPrettyStr(cardInt)
    }

    static func prettyCards(_ cards: [Card]) -> String {
        var output = " "
        for i in 0..<cards.count {
            let c = cards[i]
            if i != cards.count - 1 {
                output += intToPrettyStr(c.binaryInteger) + ","
            } else {
                output += intToPrettyStr(c.binaryInteger) + " "
            }
        }
        return output
    }
}

extension Card: CustomStringConvertible {
    public var description: String {
        Self.prettyCard(self.binaryInteger)
    }
}

extension Card: Equatable {}

extension Card: Hashable {}
