import Foundation

extension Evaluator {
    public static func writeJSONData(to path: String) throws {
        let encoder = JSONEncoder()
        func write<T: Encodable>(filename: String, instance: T) throws {
            let data = try encoder.encode(instance)
            try data.write(
                to: URL(fileURLWithPath: path)
                    .appendingPathComponent(filename)
                    .appendingPathExtension("json"),
                options: .atomic)
        }
        try write(filename: "flush_lookup", instance: table.flushLookup)
        try write(filename: "unsuited_lookup", instance: table.unsuitedLookup)
    }
}
