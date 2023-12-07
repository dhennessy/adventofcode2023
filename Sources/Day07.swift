import Algorithms

extension String {
    /// Easy and lazy string indexing
    subscript(i: Int) -> String {
        let index = index(startIndex, offsetBy: i)
        return String(self[index...index])
    }
}

extension Array where Element: Equatable {
    /// Return the number of identical elements starting at an index
    func run(from: Int) -> Int {
        var i = from
        while i < self.count && self[i] == self[from] {
            i += 1
        }
        return i - from
    }
}

struct Card: CustomDebugStringConvertible, Equatable {
    let label: String
    
    var strength: Int {
        ["2": 2, "3": 3, "4": 4, "5": 5, "6": 6, "7": 7, "8": 8, "9": 9, "T": 10, "J": 11, "Q": 12, "K": 13, "A": 14][label]!
    }

    var strengthWithJoker: Int {
        ["2": 2, "3": 3, "4": 4, "5": 5, "6": 6, "7": 7, "8": 8, "9": 9, "T": 10, "J": 1, "Q": 12, "K": 13, "A": 14][label]!
    }

    var debugDescription: String {
        label
    }
}

enum Trick: Int {
    case highCard = 0
    case pair = 1
    case twoPair = 2
    case threeOfAKind = 3
    case fullHouse = 4
    case fourOfAKind = 5
    case fiveOfAKind = 6
    
    init(cards: [Card]) {
        let ordered = cards.sorted { $0.strength < $1.strength }
        if ordered.run(from: 0) == 5 {
            self = .fiveOfAKind
        } else if ordered.run(from: 0) == 4 || ordered.run(from: 1) == 4 {
            self = .fourOfAKind
        } else if (ordered.run(from: 0) == 3 && ordered.run(from: 3) == 2) ||
                    (ordered.run(from: 0) == 2 && ordered.run(from: 2) == 3) {
            self = .fullHouse
        } else if ordered.run(from: 0) == 3 || ordered.run(from: 1) == 3 || ordered.run(from: 2) == 3 {
            self = .threeOfAKind
        } else {
            let pairs = (0..<4).filter { ordered.run(from: $0) == 2 }
            if pairs.count == 2 {
                self = .twoPair
            } else if pairs.count == 1 {
                self = .pair
            } else {
                self = .highCard
            }
        }
    }
}

struct Hand {
    let cards: [Card]
    let bid: Int
    let strength: Int
    
    init(_ s: String, useJoker: Bool) {
        cards = (0..<5).map { Card(label: s[$0]) }
        bid = Int(s.split(separator: " ").last!)!
        if useJoker {
            let possibleTricks = permute(cards: cards, position: 0).map { Trick(cards: $0) }
            let trick = possibleTricks.sorted { $0.rawValue > $1.rawValue }.first!
            strength = trick.rawValue * 1000000 + cards.reduce(0, { $0 * 14 + $1.strengthWithJoker })
        } else {
            let trick = Trick(cards: cards)
            strength = trick.rawValue * 1000000 + cards.reduce(0, { $0 * 14 + $1.strength })
        }
    }
}

func permute(cards: [Card], position: Int) -> [[Card]] {
    if cards[position].label == "J" {
        var permutations: [[Card]] = []
        for card in "23456789TQKA".map({ Card(label: String($0)) }) {
            var alt = cards
            alt[position] = card
            if position < cards.count-1 {
                permutations.append(contentsOf: permute(cards: alt, position: position+1))
            } else {
                permutations.append(alt)
            }
        }
        return permutations
    } else {
        if position < cards.count-1 {
            return permute(cards: cards, position: position+1)
        } else {
            return [cards]
        }
    }
}

struct Day07: AdventDay {
    var data: String
    
    func part1() -> Any {
        let hands = data.split(separator: "\n").map { Hand(String($0), useJoker: false) }
        let ranked = hands.sorted { $0.strength < $1.strength }
        let wins = (0..<ranked.count).map { ranked[$0].bid * ($0+1) }
        return wins.reduce(0, +)
    }
    
    func part2() -> Any {
        let hands = data.split(separator: "\n").map { Hand(String($0), useJoker: true) }
        let ranked = hands.sorted { $0.strength < $1.strength }
        let wins = (0..<ranked.count).map { ranked[$0].bid * ($0+1) }
        return wins.reduce(0, +)
    }
}
