extension Collection {
    // Safe Collection indexing
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

extension Collection where Element: Hashable {
    var allUnique: Bool {
        Set(self).count == self.count
    }
}

extension String {
    // Emulates the Python str.join() method
    func join<C: Collection>(_ col: C) -> String where C.Element: StringProtocol {
        col.joined(separator: self)
    }
}

extension Array {
    @discardableResult
    mutating func removeFirst(where f: (Element) throws -> Bool) rethrows -> Element? {
        var copy = self
        for (index, el) in self.enumerated() {
            if try f(el) {
                let removed = copy.remove(at: index)
                self = copy
                return removed
            }
        }
        return nil
    }
}