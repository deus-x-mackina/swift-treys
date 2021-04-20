# Swift Treys

> **WARNING:**  Version 0.3.0 represents a major API overhaul and is incompatible with 0.2.x or 0.1.x versions.

A Swift port of [ihendley/treys](https://github.com/ihendley/treys/), who
provided the original implementation for the logic in Python, which was itself
based on [Cactus Kev's Algorithm](http://suffe.cool/poker/evaluator.html). I
have translated the logic into Swift, keeping core features but making "Swifty"
adjustments where convenient. I have also retained the vast majority of the
original documentation and variables names, again with amendments as needed.

This library is used for the evaluation of poker hands, comprised of 5, 6, or 7
cards. For example:

```swift
import SwiftTreys

let myHand: [Card] = try! Card.parseArray([["Ah", "Th"]])
let pokerBoard: [Card] = try! Card.parseArray(["4d", "Jh", "Qh", "Ac", "Kh"])
print(Evaluator.evaluate(hand: myHand, board: pokerBoard))
// prints "Royal flush"
```

## Installation

### Using Swift Package Manager

Include this line to your dependencies in `Package.swift`. Source stability during development is
maintained only through minor versions:

```swift
let package = Package(
    // ...
    dependencies: [
        .package(
            url: "https://github.com/deus-x-mackina/swift-treys.git",
            .upToNextMinor(from: "0.3.0")),
        ]
    // ...
)
```

### Cloning the repo

If cloning the repo manually, you have a bit more flexibility with the things
you can play around with.

```shell script
git clone https://github.com/deus-x-mackina/swift-treys.git
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

> **Note:** One of tests involves running through each of the 2+ million five-card
> hand combinations, so the tests may take around 20 to 40 seconds in total to
> execute.

## At A Glance

### `Rank` and `Suit`

These two enumerations make it easier to create `Card`s in a type-safe manner.

### `Card`

The base type for representing an evaluable card, `Card` instances wrap a `uniqueInteger`
property calculated from its rank and suit that is used for evaluating poker hands
algorithmically.

**Description:**

- Conforms to `Equatable`, `Hashable`, `CustomStringConvertible`, and `Codable`
- `init(_:_:)` offers convenient initialization syntax `Card(.ace, .spades)`
- Can create multiple cards from the static method declared as:

```swift
  static func parseArray<Str, Seq>(strings: Seq) throws -> [Card]
    where
    Str: StringProtocol,
    Seq: Sequence,
    Seq.Element == Str
```

  In order to ensure a non-nil return, each string in `strings` should be exactly two
  characters long, with the first character, the rank, being one of [[23456789TJQK]] and the
  second character, the suit, is one of [[chsd]].

### `Evaluator`

The bread and butter of the library. This static type ships the `evaluate` overloaded
method for evaluating hands. The return type of these methods is `Evaluation`, which can
be printed to see what hand exactly was evaluated. See [the source file](Sources/SwiftTreys/Evaluation.swift)
for more.

## Acknowledgements

Thanks for making your code available, ihendley! It was a great time working
with your code.
