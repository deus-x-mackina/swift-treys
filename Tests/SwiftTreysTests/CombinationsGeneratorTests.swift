import XCTest
@testable import SwiftTreys

final class CombinationsGeneratorTests: XCTestCase {
    func testCombinations() throws {
        let languages = ["English", "Spanish", "Japanese"]

        let monolingual = Array(CombinationsGenerator(pool: languages, r: 1))
        XCTAssertTrue(monolingual.count == 3 && monolingual.allUnique)
        for speakableLanguage in monolingual {
            XCTAssertTrue(speakableLanguage.count == 1 && speakableLanguage.allUnique)
        }

        let bilingual = Array(CombinationsGenerator(pool: languages, r: 2))
        XCTAssertTrue(bilingual.count == 3 && bilingual.allUnique)
        for speakableLanguages in bilingual {
            XCTAssertTrue(speakableLanguages.count == 2 && speakableLanguages.allUnique)
        }

        let trilingual = Array(CombinationsGenerator(pool: languages, r: 3))
        XCTAssertTrue(trilingual.count == 1 && trilingual.allUnique)
        for speakableLanguages in trilingual {
            XCTAssertTrue(speakableLanguages.count == 3 && speakableLanguages.allUnique)
        }
    }
}
