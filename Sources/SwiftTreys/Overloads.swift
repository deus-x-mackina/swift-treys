func *<C: RangeReplaceableCollection>(lhs: C, rhs: Int) -> C {
    switch rhs {
    case let x where x < 1:
        return C()
    case 1:
        return lhs
    default:
        var ret = lhs
        for _ in 0..<rhs - 1 {
            ret += lhs
        }
        return ret
    }
}