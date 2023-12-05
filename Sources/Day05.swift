import Algorithms

struct RangeMap {
    let range: Range<Int>
    let offset: Int
}

struct SparseMap: CustomDebugStringConvertible {
    var maps: [RangeMap] = []
    
    var debugDescription: String {
        return maps.map{ "(\($0.range)):\($0.offset)" }.joined(separator: ", ")
    }
    
    mutating func addMap(range: Range<Int>, offset: Int) {
        maps.append(RangeMap(range: range, offset: offset))
        maps.sort(by: { $0.range.lowerBound < $1.range.lowerBound })
    }
    
    func translate(range: Range<Int>) -> [Range<Int>] {
        var start = range.lowerBound
        var remaining = range.count
        var ranges: [Range<Int>] = []
        while remaining > 0 {
            let (mapIndex, extent) = findRangeMap(start)
            var offset = 0
            if let mapIndex {
                offset = maps[mapIndex].offset
            }
            let mappedLen = min(remaining, extent)
            ranges.append(start+offset..<start+offset+mappedLen)
            remaining -= mappedLen
            start += mappedLen
        }
        return ranges
    }
    
    func findRangeMap(_ start: Int) -> (Int?, Int) {
        for (i, map) in maps.enumerated() {
            if map.range.contains(start) {
                return (i, map.range.upperBound-start)
            }
            if map.range.lowerBound > start {
                return (nil, map.range.lowerBound-start)
            }
        }
        return (nil, Int.max)
    }
}

struct Day05: AdventDay {
    let seeds: [Int]
    var maps: [SparseMap]
    
    init(data: String) {
        let parts = data.split(separator: "\n\n")
        seeds = parts[0].split(separator: " ").dropFirst().map { Int($0)! }
        maps = parts.dropFirst().map { part in
            var map = SparseMap()
            for mapping in part.split(separator: "\n").dropFirst() {
                let vals = mapping.split(separator: " ").map { Int($0)! }
                if vals.count == 3 {
                    let dest = vals[0]
                    let src = vals[1]
                    let len = vals[2]
                    map.addMap(range: src..<src+len, offset: dest-src)
                }
            }
            return map
        }
    }

    func part1() -> Any {
        let locations = seeds.map { getLocation(range: $0..<$0+1) }
        return locations.min()!
    }
    
    func part2() -> Any {
        var minLocation = Int.max
        for i in 0..<seeds.count/2 {
            let start = seeds[i*2]
            let len = seeds[i*2+1]
            minLocation = min(minLocation, getLocation(range: start..<start+len))
        }
        return minLocation
    }

    
    func getLocation(range: Range<Int>) -> Int {
        var ranges: [Range<Int>] = [range]
        for map in maps {
            var nextRanges: [Range<Int>] = []
            for range in ranges {
                nextRanges.append(contentsOf: map.translate(range: range))
            }
            ranges = nextRanges
        }
        return ranges.sorted { $0.lowerBound < $1.lowerBound }.first!.lowerBound
    }
}
