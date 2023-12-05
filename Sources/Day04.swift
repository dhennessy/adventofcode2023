import Algorithms

struct Day04: AdventDay {
    let entities: [[Int]]
    
    init(data: String) {
        entities = data.split(separator: "\n").map {
            let scores = $0.split(separator: ":").last!.split(separator: "|")
            let winning = scores.first!.split(separator: " ").compactMap { Int($0) }
            let player = scores.last!.split(separator: " ").compactMap { Int($0) }
            return player.filter({ winning.contains($0)})
        }
    }
    
    func part1() -> Any {
        entities.map({ binaryPower($0.count) }).reduce(0, +)
    }
    
    func part2() -> Any {
        let originals = entities
        var sum = 0
        for i in 0..<originals.count {
            sum += playCard(i)
        }
        return sum
    }
    
    func playCard(_ i: Int) -> Int {
        var sum = 1
        let count = entities[i].count
        for j in i+1..<i+1+count {
            sum += playCard(j)
        }
        return sum
    }
    
    func binaryPower(_ val: Int) -> Int {
        if val > 0 {
            return 1 << (val - 1)
        } else {
            return 0
        }
    }
}
