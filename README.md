# Swift Treys

A Swift port of [ihendley/treys](https://github.com/ihendley/treys/), who
provided the original implementation for the logic in Python, which was itself
based on [Cactus Kev's Algorith](http://suffe.cool/poker/evaluator.html). I have
translated the logic into Swift, keeping core features but making "Swifty"
adjustments where convenient. I have also retained the vast majority of the
original documentation and variables names, again with amendments as needed.

This library is used for the evaluation of poker hands, comprised of 5, 6, or 7
cards. For example:

```swift
import SwiftTreys
let myHand: [Card] = Card.fromStringList(["Ah", "Th"])!
let pokerBoard: [Card] = Card.fromStringList(["4d", "Jh", "Qh", "Ac", "Kh"])!
print(Evaluator.classifyPokerHand(cards: myHand, board: pokerBoard))
// prints "Straight Flush"
```

## Installation

### Using Swift Package Manager

Include this line to your dependencies in `Package.swift`:

```swift
let package = Package(
    // ...
    dependencies: [
        .package(
            url: "https://github.com/blitzensblitzin/swift-treys.git",
            from: "0.1.3"),
        ]
    // ...
)
```

### Cloning the repo

If cloning the repo manually, you have a bit more flexibility with the things
you can play around with.

```shell script
git clone https://github.com/blitzensblitzin/swift-treys.git
cd swift-treys
```

#### Using the REPL

Despite being a compiled language, Swift offers a built-in REPL that can import
custom modules. From within the repo's directory, simply run:

```shell script
swift run --repl
```

Once the REPL boots up, you can `import SwiftTreys` and play around with the
code.

#### Running Tests

A test suite has been written and can be run from within the repo directory via
the command:

```shell script
swift test
```

**Note:** One of tests involves running through each of the 2+ million five-card
hand combinations, so the tests may take around 20 to 40 seconds in total to
execute.

## At A Glance

### `Rank` and `Suit`

These two enumerations make it easier to prevent errors when creating a single
`Card` instance.

### `Card`

The base type for representing an evaluable card, `Card` instances wrap a unique
`binaryInteger` property calculated from its rank and suit that is used for
evaluating poker hands algorithmically.

**Description:**

- Conforms to `Equatable`, `Hashable`, `CustomStringConvertible`, and `Codable`
- `init(_ rank: Rank, _ suit: Suit)`
- Can create multiple cards from the static method declared as:
  `func fromStringList(_ strings: [String]) -> [Card]?`. In order to ensure a
  non-nil return, each string in `strings` should be exactly two characters
  long, with the first character (rank) being one of [23456789TJQK] and the
  second character (suit) is one of [chsd].

### `Deck`

Utility for creating a standard, shuffled deck of 52 `Card` instances. Use the
method `draw(n:)` to return an `n`-length array of cards, that can represent a
hand or poker board.

### `Evaluator`

The bread and butter of the library. This static struct ships with a few
methods, the most interesting of which are `classifyPokerHand(cards:board:)` and
`handSummary(board:hands:)`.

#### `classifyPokerHand(cards:board:)`

Pass in a `RangeReplaceableCollection`-conforming collection of `Card` instances
into this method (arrays work just fine!). As long as the total of the `Card`s
between both parameters totals to 5, 6, or 7, the method should return a String
representation of the best poker hand available.

#### `handSummary(board:hands:)`

Pass in a `board` of 5 `Card` instances (an array works here), and an array of
two-`Card` arrays for `hands` to get a chronological breakdown of the poker game
that unfolded given the `board` and `hands` passed in. For example:

```swift
// in the REPL
import SwiftTreys
let board = Card.fromStringList(["4d", "Jh", "Qh", "Ac", "Kh"])!
let myHand = Card.fromStringList(["Ah", "Th"])!
let opponentHand = Card.fromStringList(["Qd", "Ad"])!
Evaluator.handSummary(board: board, hands: [myHand, opponentHand])
```

Doing so prints the following:

```
========== FLOP ==========
Player 1 hand = High Card, percentage rank among all hands = 0.14835164835164838
Player 2 hand = Pair, percentage rank among all hands = 0.4931653712141517
Player 2 hand is currently winning.

========== TURN ==========
Player 1 hand = Pair, percentage rank among all hands = 0.5469043151969981
Player 2 hand = Two Pair, percentage rank among all hands = 0.6676494237469848
Player 2 hand is currently winning.

========== RIVER ==========
Player 1 hand = Straight Flush, percentage rank among all hands = 0.9998659876708658
Player 2 hand = Two Pair, percentage rank among all hands = 0.667783436076119

========== HAND OVER ==========
Player 1 is the winner with a Straight Flush
```

## Acknowledgements

Thanks for making your code available, ihendley! It was a great time working
with your code.
