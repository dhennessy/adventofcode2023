import Algorithms

struct Day10: AdventDay {
    let map: Grid
    
    let exits: [String: [(Int, Int)]] = [
        ".": [],
        "F": [(1, 0), (0, 1)],
        "-": [(1, 0), (-1, 0)],
        "7": [(-1, 0), (0, 1)],
        "|": [(0, -1), (0, 1)],
        "J": [(0, -1), (-1, 0)],
        "L": [(0, -1), (1, 0)]
    ]
    
    init(data: String) {
        map = Grid(data)
    }
    
    func part1() -> Any {
        return findRoute().count / 2
    }
    
    func part2() -> Any {
        var cleanMap = Grid(repeating: ".", width: map.width, height: map.height)
        for e in findRoute() {
            cleanMap[e.0, e.1] = map[e.0, e.1]
        }

        /// If start element could be a '|', replace the 'S' with that on the map
        let start = map.find("S")!
        let adjacentPipe = surrounding(start).filter { isConnected(from: $0, to: start) }
        for p in ["F", "-", "7", "|", "J", "L"] {
            let steps = exits[p]!.compactMap { step(from: start, by: $0) }
            if steps.count == 2 &&
                adjacentPipe.contains(where: { $0.0 == steps[0].0 && $0.1 == steps[0].1 }) &&
                adjacentPipe.contains(where: { $0.0 == steps[1].0 && $0.1 == steps[1].1 }) {
                cleanMap[start.0, start.1] = p
                break
            }
        }
        
        var insideCount = 0
        for y in 0..<map.height {
            var inside = false
            var spanStart = "."
            for x in 0..<map.width {
                switch cleanMap[x, y] {
                case ".":
                    if inside {
                        insideCount += 1
                        cleanMap[x, y] = "I"
                    } else {
                        cleanMap[x, y] = "O"
                    }
                case "|":
                    inside = !inside
                case "F":
                    spanStart = "F"
                case "L":
                    spanStart = "L"
                case "7":
                    if spanStart == "L" {
                        inside = !inside
                    }
                case "J":
                    if spanStart == "F" {
                        inside = !inside
                   }
                default:
                    break
                }
            }
        }
        return insideCount
    }
    
    /// Find all pipe positions from start (S)
    func findRoute() -> [(Int, Int)] {
        let start = map.find("S")!
        
        /// Find a pipe element adjacent to start
        var first = start
        for l in surrounding(start) {
            if isConnected(from: l, to: start) {
                first = l
                break
            }
        }
        
        /// Determine the pipe elements
        var route: [(Int, Int)] = [first]
        var loc = first
        var prev = start
        while loc != start {
            let steps = exits[map[loc.0, loc.1]]!
            let first = step(from: loc, by: steps[0])!
            if first == prev {
                prev = loc
                loc = step(from: loc, by: steps[1])!
            } else {
                prev = loc
                loc = first
            }
            route.append(loc)
        }
        
        return route
    }
    
    /// Move by step if not at edges
    func step(from: (Int, Int), by: (Int, Int)) -> (Int, Int)? {
        let x = from.0 + by.0
        let y = from.1 + by.1
        guard x >= 0 && x < map.width && y >= 0 && y < map.height else { return nil }
        return (x, y)
    }
    
    /// Return true if pipe can flow from a to b (not necessarily in reverse)
    func isConnected(from: (Int, Int), to: (Int, Int)) -> Bool {
        for s in exits[map[from.0, from.1]]!.compactMap({ step(from: from, by: $0)}) {
            if s == to {
                return true
            }
        }
        return false
    }
    
    /// Return cells surrounding cell, which are within map
    func surrounding(_ from: (Int, Int)) -> [(Int, Int)] {
        [(1, 0), (0, 1), (-1, 0), (0, -1)].compactMap({ step(from: from, by: $0) })
    }
}
