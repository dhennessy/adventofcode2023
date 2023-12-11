import Algorithms

struct Day11: AdventDay {
    var data: String
    
    func part1() -> Any {
        let map = Grid(data)
        let galaxies = expandPoints(map.findAll("#"), cols: blankCols(map), rows: blankRows(map), by: 1)
        let routes = findRoutes(galaxies)
        return routes.keys.reduce(0) { sum, src in
            let destinations: [Int: Int] = routes[src]!
            return sum + destinations.keys.reduce(0) { $0 + destinations[$1]! }
        }
    }
    
    func part2() -> Any {
        let map = Grid(data)
        let galaxies = expandPoints(map.findAll("#"), cols: blankCols(map), rows: blankRows(map), by: 999999)
        let routes = findRoutes(galaxies)
        return routes.keys.reduce(0) { sum, src in
            let destinations: [Int: Int] = routes[src]!
            return sum + destinations.keys.reduce(0) { $0 + destinations[$1]! }
        }
    }
    
    func blankCols(_ map: Grid) -> [Int] {
        var blankCols: [Int] = []
        for x in 0..<map.width {
            if (0..<map.height).allSatisfy({ map[x, $0] == "." }) {
                blankCols.append(x)
            }
        }
        return blankCols
    }
    
    func blankRows(_ map: Grid) -> [Int] {
        var blankRows: [Int] = []
        for y in 0..<map.height {
            if (0..<map.width).allSatisfy({ map[$0, y] == "." }) {
                blankRows.append(y)
            }
        }
        return blankRows
    }
    
    func expandPoints(_ pts: [Point], cols: [Int], rows: [Int], by: Int) -> [Point] {
        var exp: [(Int, Int)] = []
        for p in pts {
            let blanksToLeft = cols.filter({ $0 < p.x }).count
            let blanksAbove = rows.filter({ $0 < p.y }).count
            exp.append((p.x+blanksToLeft*by, p.y+blanksAbove*by))
        }
        return exp
    }
    
    func expandMap(_ map: Grid) -> Grid {
        var blankCols: [Int] = []
        var blankRows: [Int] = []
        for x in 0..<map.width {
            if (0..<map.height).allSatisfy({ map[x, $0] == "." }) {
                blankCols.append(x)
            }
        }
        for y in 0..<map.height {
            if (0..<map.width).allSatisfy({ map[$0, y] == "." }) {
                blankRows.append(y)
            }
        }
        var newMap = map
        for i in 0..<blankRows.count {
            newMap.insertRow(repeating: ".", at: blankRows[i]+i)
        }
        for i in 0..<blankCols.count {
            newMap.insertColumn(repeating: ".", at: blankCols[i]+i)
        }
        return newMap
    }
    
    /// Build a mapping from source index to destination index -> length
    func findRoutes(_ galaxies: [Point]) -> [Int: [Int: Int]] {
        var routes: [Int: [Int: Int]] = [:]
        for i1 in 0..<galaxies.count {
            let g1 = galaxies[i1]
            var g1Routes: [Int: Int] = [:]
            for i2 in 0..<galaxies.count {
                if i1 != i2 && routes[i2] == nil {
                    let g2 = galaxies[i2]
                    g1Routes[i2] = distance(from: g1, to: g2)
                }
            }
            routes[i1] = g1Routes
        }
        return routes
    }
    
    func distance(from: Point, to: Point) -> Int {
        abs(to.y-from.y) + abs(to.x-from.x)
    }
}
