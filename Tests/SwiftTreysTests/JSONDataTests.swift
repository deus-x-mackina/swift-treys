@testable import SwiftTreys
import XCTest

final class JSONDataTests: XCTestCase {
    func testWritingJSONData() throws {
        let tempFolder = FileManager.default.temporaryDirectory
        try Evaluator.writeJSONData(to: tempFolder.absoluteString)
        let flush = tempFolder
            .appendingPathComponent("flush_lookup")
            .appendingPathExtension("json")
        let unsuited = tempFolder
            .appendingPathComponent("unsuited_lookup")
            .appendingPathExtension("json")
        XCTAssert(FileManager.default.fileExists(atPath: flush.path))
        XCTAssert(FileManager.default.fileExists(atPath: unsuited.path))

        try FileManager.default.removeItem(at: flush)
        try FileManager.default.removeItem(at: unsuited)
    }
}
