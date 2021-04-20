/// Bit hack from here: http://www-graphics.stanford.edu/~seander/bithacks.html#NextBitPermutation.
///
/// Generator even does this in poker order rank
/// so no need to sort when done! Perfect.
internal struct BitSequenceGenerator: IteratorProtocol, Sequence {
  internal var bits: Int16
  internal var t: Int16 = 0
  internal var nextBits: Int16 = 0

  internal init(bits: Int16) {
    self.bits = bits
  }

  internal mutating func next() -> Int16? {
    t = bits | (bits &- 1)
    nextBits = (t &+ 1) | (((~t & -(~t)) &- 1) >> (Int16(bits.trailingZeroBitCount) &+ 1))
    bits = nextBits
    return nextBits
  }
}

internal func primeProductFromRankBits(_ rankBits: Int16) -> Int32 {
  var product: Int32 = 1
  for i in INT_RANKS {
    if rankBits & (1 << i) != 0 {
      product &*= PRIMES[Int(i)]
    }
  }
  return product
}

internal func primeProductFromHand<C: Collection>(_ hand: C) -> Int32 where C.Element == Card {
  var product: Int32 = 1
  for card in hand {
    product &*= card.uniqueInteger & 0xFF
  }
  return product
}

internal func highRankFromRankBits(_ rankBits: Int16) -> Rank {
  guard rankBits != STRAIGHT_FLUSHES[9] else {
    return .five
  }

  for i in INT_RANKS.reversed() {
    if rankBits & (1 << i) != 0 {
      return Rank.allCases[Int(i)]
    }
  }

  fatalError("Internal error: ran unreachable code")
}

internal let INT_RANKS: Range<Int16> = 0 ..< 13

internal let PRIMES: [Int32] = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41]

internal let STRAIGHT_FLUSHES: [Int16] = [
  0b1_1111_0000_0000, // 7936
  0b1111_1000_0000, // 3968
  0b111_1100_0000, // 1984
  0b11_1110_0000, // 992
  0b1_1111_0000, // 496
  0b1111_1000, // 248
  0b1111100, // 124
  0b111110, // 62
  0b11111, // 31
  0b1_0000_0000_1111, // 4111
]

internal let MAX_STRAIGHT_FLUSH: Int16 = 10

internal let MAX_FOUR_OF_A_KIND: Int16 = 166

internal let MAX_FULL_HOUSE: Int16 = 322

internal let MAX_FLUSH: Int16 = 1599

internal let MAX_STRAIGHT: Int16 = 1609

internal let MAX_THREE_OF_A_KIND: Int16 = 2467

internal let MAX_TWO_PAIR: Int16 = 3325

internal let MAX_PAIR: Int16 = 6185

internal let MAX_HIGH_CARD: Int16 = 7462
