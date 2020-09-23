import func Foundation.pow

struct LookupTable {
    static let MAX_STRAIGHT_FLUSH = 10
    static let MAX_FOUR_OF_A_KIND = 166
    static let MAX_FULL_HOUSE = 322
    static let MAX_FLUSH = 1599
    static let MAX_STRAIGHT = 1609
    static let MAX_THREE_OF_A_KIND = 2467
    static let MAX_TWO_PAIR = 3325
    static let MAX_PAIR = 6185
    static let MAX_HIGH_CARD = 7462

    static let MAX_TO_RANK_CLASS = [
        MAX_STRAIGHT_FLUSH: 1, MAX_FOUR_OF_A_KIND: 2, MAX_FULL_HOUSE: 3, MAX_FLUSH: 4,
        MAX_STRAIGHT: 5, MAX_THREE_OF_A_KIND: 6, MAX_TWO_PAIR: 7, MAX_PAIR: 8, MAX_HIGH_CARD: 9,
    ]

    static let RANK_CLASS_TO_POKER_HAND: [Int: PokerHandClass] = [
        1: .straightFlush, 2: .fourOfAKind, 3: .fullHouse, 4: .flush, 5: .straight,
        6: .threeOfAKind, 7: .twoPair, 8: .pair, 9: .highCard,
    ]

    private(set) var flushLookup = [Int: Int]()
    private(set) var unsuitedLookup = [Int: Int]()

    init() {
        flushes()
        multiples()
    }

    // Straight flushes and flushes
    // Lookup is done on 13 bit integer (2^13 > 7462):
    // xxxbbbbb bbbbbbbb => integer hand index
    mutating func flushes() {
        let straightFlushes = [
            7936, // Int('1111100000000', radix: 2), royal flush
            3968, // Int('111110000000', radix: 2),
            1984, // Int('11111000000', radix: 2),
            992, // Int('1111100000', radix: 2),
            496, // Int('111110000', radix: 2),
            248, // Int('11111000', radix: 2),
            124, // Int('1111100', radix: 2),
            62, // Int('111110', radix: 2),
            31, // Int('11111', radix: 2),
            4111, // Int('1000000001111', radix: 2), 5 high
        ]

        // now we'll dynamically generate all the other
        // flushes (including straight flushes)
        var flushes = [Int]()
        var gen = BitSequenceGenerator(Int("11111", radix: 2)!)

        // 1277 = number of high cards
        // 1277 + straightFlushes.count is number of hands with all cards unique rank
        for _ in 0 ..< (1277 &+ straightFlushes.count &- 1) {
            // pull next flush pattern from our generator
            let f = gen.next()!

            // if this flush matches perfectly any
            // straight flush, do not add it
            var notSF = true
            for sf in straightFlushes {
                // if f XOR sf == 0, then bit pattern
                // is same, and we should not add
                if f ^ sf == 0 { notSF = false }
            }
            if notSF { flushes.append(f) }
        }

        // we started from the lowest straight pattern, now we want to start ranking from
        // the most powerful hands, so we reverse
        flushes.reverse()

        // now add to the lookup map:
        // start with straight flushes and the rank of 1
        // since it is the best hand in poker
        // rank 1 = Royal Flush!
        var rank = 1
        for sf in straightFlushes {
            let primeProduct = Card.primeProductFromRankbits(sf)
            flushLookup[primeProduct] = rank
            rank &+= 1
        }

        // we start the counting for flushes on max full house, which
        // is the worst rank that a full house can have (2,2,2,3,3)
        rank = Self.MAX_FULL_HOUSE &+ 1
        for f in flushes {
            let primeProduct = Card.primeProductFromRankbits(f)
            flushLookup[primeProduct] = rank
            rank &+= 1
        }

        // we can reuse these bit sequences for straights
        // and high cards since they are inherently related
        // and differ only by context
        straightAndHighCards(straights: straightFlushes, highCards: flushes)
    }

    // Unique five card sets. Straights and high cards.
    // Reuses bit sequences from flush calculations.
    mutating func straightAndHighCards(straights: [Int], highCards: [Int]) {
        var rank = Self.MAX_FLUSH &+ 1
        for s in straights {
            let primeProduct = Card.primeProductFromRankbits(s)
            unsuitedLookup[primeProduct] = rank
            rank &+= 1
        }

        rank = Self.MAX_PAIR &+ 1
        for h in highCards {
            let primeProduct = Card.primeProductFromRankbits(h)
            unsuitedLookup[primeProduct] = rank
            rank &+= 1
        }
    }

    /// Pair, Two Pair, Three of a Kind, Full House, and 4 of a Kind.
    mutating func multiples() {
        let backwardsRanks = Array((0 ... Card.INT_RANKS.count &- 1).reversed())

        // 1) Four of a kind
        var rank = Self.MAX_STRAIGHT_FLUSH &+ 1
        // for each choice of a set of four ranks
        for i in backwardsRanks {
            // and for each possible kicker rank
            var kickers = backwardsRanks
            kickers.removeFirst { $0 == i }
            for k in kickers {
                let product = Card.PRIMES[i] ** 4 &* Card.PRIMES[k]
                unsuitedLookup[product] = rank
                rank &+= 1
            }
        }

        // 2) Full house
        rank = Self.MAX_FOUR_OF_A_KIND &+ 1

        // for each three of a kind
        for i in backwardsRanks {
            // and for each choice of pair rank
            var pairRanks = backwardsRanks
            pairRanks.removeFirst { $0 == i }
            for pr in pairRanks {
                let product = Card.PRIMES[i] ** 3 &* Card.PRIMES[pr] ** 2
                unsuitedLookup[product] = rank
                rank &+= 1
            }
        }

        // 3) Three of a kind
        rank = Self.MAX_STRAIGHT &+ 1

        // pick 3 of one rank
        for i in backwardsRanks {
            var kickers = backwardsRanks
            kickers.removeFirst { $0 == i }
            let combos = CombinationsGenerator(pool: kickers, r: 2)
            for k in combos {
                let c1 = k[0]
                let c2 = k[1]
                let product = Card.PRIMES[i] ** 3 &* Card.PRIMES[c1] &* Card.PRIMES[c2]
                unsuitedLookup[product] = rank
                rank &+= 1
            }
        }

        // 4) Two Pair
        rank = Self.MAX_THREE_OF_A_KIND &+ 1
        let twoPairsCombos = CombinationsGenerator(pool: backwardsRanks, r: 2)
        for twoPair in twoPairsCombos {
            let pair1 = twoPair[0]
            let pair2 = twoPair[1]
            var kickers = backwardsRanks
            kickers.removeFirst { $0 == pair1 }
            kickers.removeFirst { $0 == pair2 }
            for kicker in kickers {
                let product =
                    Card.PRIMES[pair1] ** 2 &* Card.PRIMES[pair2] ** 2 &* Card.PRIMES[kicker]
                unsuitedLookup[product] = rank
                rank &+= 1
            }
        }

        // 5) Pair
        rank = Self.MAX_TWO_PAIR &+ 1

        // choose a pair
        for pairRank in backwardsRanks {
            var kickers = backwardsRanks
            kickers.removeFirst { $0 == pairRank }
            let kickerCombos = CombinationsGenerator(pool: kickers, r: 3)
            for kickerCombo in kickerCombos {
                let k1 = kickerCombo[0]
                let k2 = kickerCombo[1]
                let k3 = kickerCombo[2]
                let product =
                    Card.PRIMES[pairRank] ** 2 &* Card.PRIMES[k1] &* Card.PRIMES[k2]
                        &* Card.PRIMES[k3]
                unsuitedLookup[product] = rank
                rank &+= 1
            }
        }
    }
}

infix operator **: ExponentialPrecedence
precedencegroup ExponentialPrecedence {
    associativity: right
    higherThan: MultiplicationPrecedence
}

private func ** (lhs: Int, rhs: Int) -> Int { Int(pow(Double(lhs), Double(rhs))) }
