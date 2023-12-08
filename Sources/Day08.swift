import Algorithms

struct Ghost {
    var stepCount = 0
    var initialRoutes: [Int]
    var repeatingRoutes: [Int]
    var routeIndex = 0
    
    init(initialRoutes: [Int], repeatingRoutes: [Int]) {
        self.initialRoutes = initialRoutes
        self.repeatingRoutes = repeatingRoutes
        walkToNextEnd()
    }
    
    mutating func walkToNextEnd() {
        var step: Int
        if routeIndex < initialRoutes.count {
            step = initialRoutes[routeIndex]
        } else {
            step = repeatingRoutes[(routeIndex-initialRoutes.count) % repeatingRoutes.count]
        }
        routeIndex += 1
        stepCount += step
    }
}

struct Day08: AdventDay {
    let instructions: String
    var map: [String: (String, String)] = [:]
    
    init(data: String) {
        let parts = data.split(separator: "\n\n").map { String($0) }
        instructions = parts[0]
        
        let locRegex = #/(...) = \((...), (...)\)/#
        for loc in parts[1].split(separator: "\n") {
            if let match = loc.firstMatch(of: locRegex) {
                map[String(match.1)] = (String(match.2), String(match.3))
            }
        }
    }
    
    func part1() -> Any {
        walk(from: "AAA").0
    }
    
    func part2() -> Any {
        var ghosts = map.keys.filter { $0.hasSuffix("A") }.map { start in
            var here = start
            var phase = 0
            var trips: [(String, Int, Int)] = []
            while true {
                let (len, end) = walk(from: here, phase: phase)
                trips.append((here, len, phase))
                here = end
                phase = (phase + len) % instructions.count
                
                // Stop once we find a repeating route
                for t in 0..<trips.count {
                    for u in t+1..<trips.count {
                        if trips[t].0 == trips[u].0 && trips[t].2 == trips[u].2 {
                            let initialRoutes = trips[0..<t].map { $0.1 }
                            let repeatingRoutes = trips[t..<trips.count].map { $0.1 }
                            return Ghost(initialRoutes: initialRoutes, repeatingRoutes: repeatingRoutes)
                        }
                    }
                }
            }
        }

        while !ghosts.allSatisfy({ $0.stepCount == ghosts[0].stepCount }) {
            let max = ghosts.map({ $0.stepCount}).max()!
            for i in 0..<ghosts.count {
                while ghosts[i].stepCount < max {
                    ghosts[i].walkToNextEnd()
                }
            }
        }
        
        return ghosts[0].stepCount
    }
    
    // Given a starting point and instruction phase, return the number of
    // steps to the end, and the ending key
    func walk(from: String, phase: Int = 0) -> (Int, String) {
        var here = from
        var count = 0
        while count == 0 || !here.hasSuffix("Z") {
            let step = instructions[(count+phase) % instructions.count]
            here = step == "L" ? map[here]!.0 : map[here]!.1
            count += 1
        }
        return (count, here)
    }

}
