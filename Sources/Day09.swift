import Algorithms

struct Day09: AdventDay {
    var data: String
    
    var history: [[Int]] {
        data.split(separator: "\n").map { $0.split(separator: " ").compactMap { Int($0) } }
    }
    
    func part1() -> Any {
        history.reduce(0) {
            $0 + deltaStack($1).reduce(0, { $0 + $1.last! })
        }
    }
    
    func part2() -> Any {
        history.reduce(0) {
            $0 + deltaStack($1).reversed().reduce(0, { $1.first! - $0 })
        }
    }
    
    func deltaStack(_ history: [Int]) -> [[Int]] {
        var values = history
        var stack: [[Int]] = []
        while !values.allSatisfy({ $0 == 0 }) {
            stack.append(values)
            var next: [Int] = []
            for i in 1..<values.count {
                next.append(values[i]-values[i-1])
            }
            values = next
        }
        return stack
    }
}
