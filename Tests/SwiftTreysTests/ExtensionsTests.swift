import XCTest

@testable import SwiftTreys

final class ExtensionsTests: XCTestCase {
    func testCollectionExtensionSafeIndexing() throws {
        let array = [1, 2, 3]
        let string = "hello"
        let set: Set = ["unique", "new york"]
        let dict = ["Swift": "Pretty cool", "Python": "Also pretty cool", "Java": "No thanks"]
        var notNil: Any?
        var isNil: Any?
        func assertions() {
            XCTAssertNotNil(notNil)
            XCTAssertNil(isNil)
        }

        // array
        notNil = array[safe: 0]
        isNil = array[safe: 10]
        assertions()

        // string
        notNil = string[safe: string.startIndex]
        isNil = string[safe: string.endIndex]
        assertions()

        // set
        notNil = set[safe: set.startIndex]
        isNil = set[safe: set.endIndex]
        assertions()

        // dict
        notNil = dict[safe: dict.startIndex]
        isNil = dict[safe: dict.endIndex]
        assertions()
    }

    func testStringExtensionJoin() throws {
        let phoneNumber = "".join(["8", "6", "7", "5", "3", "0", "9"])
        XCTAssertTrue(phoneNumber == "8675309")

        let groceryList = ", ".join(["bread", "milk", "eggs"])
        XCTAssertTrue(groceryList == "bread, milk, eggs")
    }

    func testArrayExtensionRemoveFirst() throws {
        var numbers = [1, 2, 1, 3]
        var removed = numbers.removeFirst { $0 == 1 }
        XCTAssertNotNil(removed)
        XCTAssertTrue(removed! == 1 && numbers == [2, 1, 3])

        removed = numbers.removeFirst { $0 == 10 }
        XCTAssertNil(removed)
        XCTAssertTrue(numbers == [2, 1, 3])
    }

    func testCollectionExtensionAllUnique() throws {
        let unique = ["a", "b", "c"]
        let notUnique = [1, 1, 1]
        XCTAssertTrue(unique.allUnique && !notUnique.allUnique)
    }

    func testDictionaryExtensionSwapKeysAndValues() throws {
        let uniqueKeysAndValues = [
            1: "one",
            2: "two",
            3: "three",
            4: "four",
            5: "five",
        ]

        let notUniqueValues = [
            "hola": "hello",
            "bonjour": "hello",
            "sayounara": "goodbye",
        ]

        let uniqueSwapped = uniqueKeysAndValues.swappingKeysAndValues()
        let notUniqueSwapped = notUniqueValues.swappingKeysAndValues()

        XCTAssertNotNil(uniqueSwapped)
        XCTAssertNil(notUniqueSwapped)

        XCTAssert(uniqueSwapped == [
            "one": 1,
            "two": 2,
            "three": 3,
            "four": 4,
            "five": 5,
        ])
    }
}
