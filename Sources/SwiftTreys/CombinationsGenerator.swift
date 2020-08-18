/// Swift translations of Pythons `itertools.combinations()` function.
/// https://docs.python.org/3/library/itertools.html#itertools.combinations.
struct CombinationsGenerator<T>: IteratorProtocol, Sequence {
    private let pool: [T]
    private let r: Int
    private let n: Int
    private var calledOnce = false
    private var indices: [Int]

    init(pool: [T], r: Int) {
        self.pool = pool
        self.r = r
        self.n = pool.count
        indices = Array(0..<r)
    }

    mutating func next() -> [T]? {
        if !calledOnce {
            if r > n { return nil }
            let ret = indices.map { pool[$0] }
            calledOnce = true
            return ret
        }
        var index = 0
        var broken = false
        for i in (0..<r).reversed() {
            if indices[i] != i &+ n &- r {
                broken = true
                index = i
                break
            }
        }
        if !broken { return nil }
        indices[index] &+= 1
        for i in (index &+ 1)..<r { indices[i] = indices[i &- 1] &+ 1 }
        let ret = indices.map { pool[$0] }
        return ret
    }
}
