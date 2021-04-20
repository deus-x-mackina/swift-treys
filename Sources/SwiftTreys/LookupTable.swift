import Algorithms

internal struct LookupTable {
  internal private(set) var flushLookup: [Int32: PokerHandMetadata] = [:]

  internal private(set) var unsuitedLookup: [Int32: PokerHandMetadata] = [:]

  internal init() {
    flushLookup.reserveCapacity(6175)
    unsuitedLookup.reserveCapacity(1287)

    flushesStraightsAndHighCards()
    multiples()
  }

  private mutating func flushesStraightsAndHighCards() {
    var flushes = [Int16]()
    flushes.reserveCapacity(1277)

    var gen = BitSequenceGenerator(bits: 0b11111)

    for _ in 0 ..< 1286 {
      let f = gen.next()!
      var notSf = true
      for sf in STRAIGHT_FLUSHES {
        if f ^ sf == 0 {
          notSf = false
          break
        }
      }
      if notSf {
        flushes.append(f)
      }
    }

    var rankSuited: Int16 = 1
    var rankUnsuited: Int16 = MAX_FLUSH &+ 1
    var highRank: Rank
    var primeProduct: Int32

    // Straight flushes and straights
    for sf in STRAIGHT_FLUSHES {
      primeProduct = primeProductFromRankBits(sf)
      highRank = highRankFromRankBits(sf)

      flushLookup[primeProduct] = .straightFlush(
        handRank: .init(rank: rankSuited),
        highRank: highRank
      )

      unsuitedLookup[primeProduct] = .straight(
        handRank: .init(rank: rankUnsuited),
        highRank: highRank
      )

      rankSuited &+= 1
      rankUnsuited &+= 1
    }

    // Flushes and high cards
    rankSuited = MAX_FULL_HOUSE &+ 1
    rankUnsuited = MAX_PAIR &+ 1
    for f in flushes.reversed() {
      primeProduct = primeProductFromRankBits(f)
      highRank = highRankFromRankBits(f)

      flushLookup[primeProduct] = .flush(
        handRank: .init(rank: rankSuited),
        highRank: highRank
      )

      unsuitedLookup[primeProduct] = .highCard(
        handRank: .init(rank: rankUnsuited),
        highRank: highRank
      )

      rankSuited &+= 1
      rankUnsuited &+= 1
    }
  }

  private mutating func multiples() {
    let backwardsRanks = INT_RANKS.reversed()
    var product: Int32

    // Four of a kind
    var rank = MAX_STRAIGHT_FLUSH &+ 1
    for i in backwardsRanks {
      let kickers = backwardsRanks.lazy.filter { $0 != i }
      for k in kickers {
        product = PRIMES[Int(i)].wrappingPow(4) &* PRIMES[Int(k)]
        unsuitedLookup[product] = .fourOfAKind(
          handRank: .init(rank: rank),
          quads: Rank.allCases[Int(i)]
        )
        rank &+= 1
      }
    }

    // Full house
    rank = MAX_FOUR_OF_A_KIND &+ 1
    for i in backwardsRanks {
      let pairRanks = backwardsRanks.lazy.filter { $0 != i }
      for pr in pairRanks {
        product = PRIMES[Int(i)].wrappingPow(3)
          &* PRIMES[Int(pr)].wrappingPow(2)
        unsuitedLookup[product] = .fullHouse(
          handRank: .init(rank: rank),
          trips: Rank.allCases[Int(i)],
          pair: Rank.allCases[Int(pr)]
        )
        rank &+= 1
      }
    }

    // Three of a kind
    rank = MAX_STRAIGHT &+ 1
    for i in backwardsRanks {
      let kickers = backwardsRanks.filter { $0 != i }
      let gen = kickers.combinations(ofCount: 2)
      for k in gen {
        let c1 = Int(k[0])
        let c2 = Int(k[1])
        product = PRIMES[Int(i)].wrappingPow(3)
          &* PRIMES[c1]
          &* PRIMES[c2]
        unsuitedLookup[product] = .threeOfAKind(
          handRank: .init(rank: rank),
          trips: Rank.allCases[Int(i)]
        )
        rank &+= 1
      }
    }

    // Two pair
    rank = MAX_THREE_OF_A_KIND &+ 1
    let twoPairCombos = Array(backwardsRanks).combinations(ofCount: 2)
    for twoPair in twoPairCombos {
      let pair1 = twoPair[0]
      let pair2 = twoPair[1]
      let kickers = backwardsRanks.lazy.filter {
        $0 != pair1 && $0 != pair2
      }
      for kicker in kickers {
        product = PRIMES[Int(pair1)].wrappingPow(2)
          &* PRIMES[Int(pair2)].wrappingPow(2)
          &* PRIMES[Int(kicker)]
        unsuitedLookup[product] = .twoPair(
          handRank: .init(rank: rank),
          highPair: Rank.allCases[Int(pair1)],
          lowPair: Rank.allCases[Int(pair2)]
        )
        rank &+= 1
      }
    }

    // Pair
    rank = MAX_TWO_PAIR &+ 1
    for pairRank in backwardsRanks {
      let kickers = backwardsRanks.filter { $0 != pairRank }
      let kickerCombos = kickers.combinations(ofCount: 3)
      for kickerCombo in kickerCombos {
        let k1 = Int(kickerCombo[0])
        let k2 = Int(kickerCombo[1])
        let k3 = Int(kickerCombo[2])
        product = PRIMES[Int(pairRank)].wrappingPow(2)
          &* PRIMES[k1]
          &* PRIMES[k2]
          &* PRIMES[k3]
        unsuitedLookup[product] = .pair(
          handRank: .init(rank: rank),
          pair: Rank.allCases[Int(pairRank)]
        )
        rank &+= 1
      }
    }
  }
}

extension LookupTable: Equatable {}

extension LookupTable: Codable {}
