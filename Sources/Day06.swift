import Algorithms

struct Race {
    let time: Int
    let distance: Int
}

struct Day06: AdventDay {
    var races: [Race]

    init(data: String) {
        let lines = data.split(separator: "\n")
        let times = lines[0].split(separator: " ").compactMap { Int($0) }
        let distances = lines[1].split(separator: " ").compactMap { Int($0) }
        races = zip(times, distances).map { Race(time: $0.0, distance: $0.1) }
    }
    
    func part1() -> Any {
        races.map { race in
            (1..<race.time)
                .map { (race.time-$0) * $0 }
                .filter { $0 > race.distance }
                .count
        }.reduce(1, *)
    }
    
    func part2() -> Any {
        let time = Int(races.map { $0.time }.reduce("", { $0.appending(String($1))}))!
        let distance = Int(races.map { $0.distance }.reduce("", { $0.appending(String($1))}))!
        return (1..<time)
            .map { (time-$0) * $0 }
            .filter { $0 > distance }
            .count
    }
}
