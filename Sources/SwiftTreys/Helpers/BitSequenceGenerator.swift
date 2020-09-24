/// Bit hack from here: http://www-graphics.stanford.edu/~seander/bithacks.html#NextBitPermutation.
///
/// Generator even does this in poker order rank
/// so no need to sort when done! Perfect.
struct BitSequenceGenerator: IteratorProtocol {
    let bits: Int
    var calledOnce = false

    var t: Int
    var nextBits: Int

    init(_ bits: Int) {
        self.bits = bits
        t = Int(bits | (bits &- 1)) &+ 1
        nextBits = t | ((Int((t & -t) / (bits & -bits)) >> 1) &- 1)
    }

    mutating func next() -> Int? {
        if !calledOnce {
            calledOnce = true
            return nextBits
        }
        t = (nextBits | (nextBits - 1)) &+ 1
        nextBits = t | ((((t & -t) /! (nextBits & -nextBits)) >> 1) &- 1)
        return nextBits
    }
}

infix operator /!: MultiplicationPrecedence
private func /! (lhs: Int, rhs: Int) -> Int {
    let d = Double(lhs) / Double(rhs)
    return Int(d.rounded(.down))
}
