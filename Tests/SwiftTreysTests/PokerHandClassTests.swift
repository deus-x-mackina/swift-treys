//
// Created by Danny Mack on 9/7/20.
// Copyright (c) 2020 Danny Mack.
//

import XCTest

@testable import SwiftTreys

final class PokerHandClassTests: XCTestCase {
    func testComparable() throws {
        batchAssert(hand: hc, greaterThan: [], lessThan: [p, tp, tok, s, f, fh, fok, sf])

        batchAssert(hand: p, greaterThan: [hc], lessThan: [tp, tok, s, f, fh, fok, sf])

        batchAssert(hand: tp, greaterThan: [hc, p], lessThan: [tok, s, f, fh, fok, sf])

        batchAssert(hand: tok, greaterThan: [hc, p, tp], lessThan: [s, f, fh, fok, sf])

        batchAssert(hand: s, greaterThan: [hc, p, tp, tok], lessThan: [f, fh, fok, sf])

        batchAssert(hand: f, greaterThan: [hc, p, tp, tok, s], lessThan: [fh, fok, sf])

        batchAssert(hand: fh, greaterThan: [hc, p, tp, tok, s, f], lessThan: [fok, sf])

        batchAssert(hand: fok, greaterThan: [hc, p, tp, tok, s, f, fh], lessThan: [sf])

        batchAssert(hand: sf, greaterThan: [hc, p, tp, tok, s, f, fh, fok], lessThan: [])
    }

    func batchAssert(
        hand: PokerHandClass, greaterThan: [PokerHandClass], lessThan: [PokerHandClass]
    ) {
        for h in greaterThan { XCTAssert(hand > h) }
        for h in lessThan { XCTAssert(hand < h) }
    }

    let hc = PokerHandClass.highCard
    let p = PokerHandClass.pair
    let tp = PokerHandClass.twoPair
    let tok = PokerHandClass.threeOfAKind
    let s = PokerHandClass.straight
    let f = PokerHandClass.flush
    let fh = PokerHandClass.fullHouse
    let fok = PokerHandClass.fourOfAKind
    let sf = PokerHandClass.straightFlush
}
