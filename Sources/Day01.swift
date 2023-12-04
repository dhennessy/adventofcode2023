import Algorithms

struct Day01: AdventDay {
    var data: String
    
    var lines: [String] {
        data.split(separator:"\n").map { String($0) }
    }
    
    let numbers = [ "zero": "0", "one": "1", "two": "2", "three": "3", "four": "4",
                    "five": "5", "six": "6", "seven": "7", "eight": "8", "nine": "9",
    ]
    
    func part1() -> Any {
        var sum = 0
        for line in lines {
            let digitNames = findSubstrings(line, substrings: Array(numbers.keys))
            
            var s = line
            if let (_, firstName) = digitNames.first, let digit = numbers[firstName] {
                s = s.replacingOccurrences(of: firstName, with: digit)
            }
            let first = s.first { $0.isNumber }
            
            s = line
            if let (_, lastName) = digitNames.last, let digit = numbers[lastName] {
                s = s.replacingOccurrences(of: lastName, with: digit)
            }
            let last = s.last { $0.isNumber }
            
            let n = Int("\(first!)\(last!)")!
            sum += n
        }
        
        return sum
    }
    
    func part2() -> Any {
        part1()
    }
    
    /// Find all occurrances of a set of substrings, and return an array of (index, substring), ordered by index
    func findSubstrings(_ s: String, substrings: [String]) -> [(String.Index, String)] {
        var results: [(String.Index, String)] = []
        for substring in substrings {
            results.append(contentsOf: s.ranges(of: substring).map({ ($0.lowerBound, substring) }))
        }
        return results.sorted { $0.0 < $1.0 }
    }
    
}
