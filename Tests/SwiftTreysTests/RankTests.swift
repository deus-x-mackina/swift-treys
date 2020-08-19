import XCTest

@testable import SwiftTreys

final class RankTests: XCTestCase {
    func testComparableConformance() throws {
        batchAssert(
            rank: ace,
            greaterThan: [king, queen, ten, nine, eight, seven, six, five, four, three, two],
            lessThan: [])
        batchAssert(
            rank: king, greaterThan: [queen, ten, nine, eight, seven, six, five, four, three, two],
            lessThan: [ace])
        batchAssert(
            rank: queen, greaterThan: [ten, nine, eight, seven, six, five, four, three, two],
            lessThan: [ace, king])
        batchAssert(
            rank: ten, greaterThan: [nine, eight, seven, six, five, four, three, two],
            lessThan: [ace, king, queen])
        batchAssert(
            rank: nine, greaterThan: [eight, seven, six, five, four, three, two],
            lessThan: [ace, king, queen, ten])
        batchAssert(
            rank: eight, greaterThan: [seven, six, five, four, three, two],
            lessThan: [ace, king, queen, ten, nine])
        batchAssert(
            rank: seven, greaterThan: [six, five, four, three, two],
            lessThan: [ace, king, queen, ten, nine, eight])
        batchAssert(
            rank: six, greaterThan: [five, four, three, two],
            lessThan: [ace, king, queen, ten, nine, eight, seven])
        batchAssert(
            rank: five, greaterThan: [four, three, two],
            lessThan: [ace, king, queen, ten, nine, eight, seven, six])
        batchAssert(
            rank: four, greaterThan: [three, two],
            lessThan: [ace, king, queen, ten, nine, eight, seven, six, five])
        batchAssert(
            rank: three, greaterThan: [two],
            lessThan: [ace, king, queen, ten, nine, eight, seven, six, five, four])
        batchAssert(
            rank: two, greaterThan: [],
            lessThan: [ace, king, queen, ten, nine, eight, seven, six, five, four, three])
    }

    func batchAssert(rank: Rank, greaterThan: [Rank], lessThan: [Rank]) {
        for r in greaterThan { XCTAssert(rank > r) }
        for r in lessThan { XCTAssert(rank < r) }
    }

    let ace = Rank.ace
    let king = Rank.king
    let queen = Rank.queen
    let jack = Rank.jack
    let ten = Rank.ten
    let nine = Rank.nine
    let eight = Rank.eight
    let seven = Rank.seven
    let six = Rank.six
    let five = Rank.five
    let four = Rank.four
    let three = Rank.three
    let two = Rank.two
}
