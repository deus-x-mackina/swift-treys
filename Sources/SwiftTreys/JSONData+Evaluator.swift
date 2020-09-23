import Foundation

extension Evaluator {
    /// Write the `Evaluator`'s internal lookup table data to the `path` provided.
    ///
    /// This method writes to `(path)/flush_lookup.json` and `(path)/unsuited_lookup.json`.
    ///
    /// - Parameters:
    ///     - path: The directory in which to write the JSON data
    /// - Throws: Errors from the `JSONEncoder` API and `Data.write(to:)`
    public static func writeJSONData(to path: String) throws {
        let encoder = JSONEncoder()
        func write<T: Encodable>(filename: String, instance: T) throws {
            let data = try encoder.encode(instance)
            try data.write(
                to: URL(fileURLWithPath: path)
                    .appendingPathComponent(filename)
                    .appendingPathExtension("json"),
                options: .atomic
            )
        }
        try write(filename: "flush_lookup", instance: table.flushLookup)
        try write(filename: "unsuited_lookup", instance: table.unsuitedLookup)
    }
}
