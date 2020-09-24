extension Collection {
    // Safe Collection indexing
    subscript(safe index: Index) -> Element? { indices.contains(index) ? self[index] : nil }
}

extension Collection where Element: Hashable {
    var allUnique: Bool { Set(self).count == count }
}

extension String {
    // Emulates the Python str.join() method
    func join<C: Collection>(_ col: C) -> String where C.Element: StringProtocol {
        col.joined(separator: self)
    }
}

extension Array {
    @discardableResult mutating func removeFirst(where f: (Element) throws -> Bool) rethrows
        -> Element?
    {
        for (index, el) in enumerated() { if try f(el) { return remove(at: index) } }
        return nil
    }
}

extension Dictionary where Value: Hashable {
    func swappingKeysAndValues() -> [Value: Key]? {
        guard Set(values).count == Set(keys).count else { return nil }
        return reduce(into: [:]) { (res: inout [Value: Key], next) in res[next.value] = next.key }
    }
}
