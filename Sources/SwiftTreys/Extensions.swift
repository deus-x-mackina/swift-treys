extension FixedWidthInteger {
  internal func wrappingPow(_ exp: Self) -> Self {
    var result: Self = 1
    var copy = self
    var exp = exp

    while true {
      if exp & 1 != 0 {
        result &*= copy
      }
      exp >>= 1
      if exp == 0 {
        break
      }
      copy &*= copy
    }

    return result
  }
}

extension Sequence where Element: Equatable & Hashable {
  internal var allUnique: Bool {
    var set = Set<Element>()
    set.reserveCapacity(underestimatedCount)
    return allSatisfy { set.insert($0).inserted }
  }
}
