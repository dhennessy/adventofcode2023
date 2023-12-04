import Algorithms

struct Day02: AdventDay {
    var data: String
    
    struct Game {
        let id: Int
        var red: Int
        var green: Int
        var blue: Int
    }

    var games: [Game] {
        data.split(separator: "\n").compactMap { summary in
            let gameIdRegex = #/Game (\d+): /#
            if let match = summary.firstMatch(of: gameIdRegex) {
                var game = Game(id: Int(match.1)!, red: 0, green: 0, blue: 0)
                for gameSummary in summary.replacing(gameIdRegex, with: "").split(separator: "; ") {
                    let scores = gameSummary.split(separator: ", ")
                    for score in scores {
                        let scoreRegex = #/(\d+) (.+)/#
                        if let match = String(score).firstMatch(of: scoreRegex) {
                            let count = Int(match.1)!
                            switch match.2 {
                            case "red":
                                game.red = max(game.red, count)
                            case "green":
                                game.green = max(game.green, count)
                            case "blue":
                                game.blue = max(game.blue, count)
                            default:
                                print("Failed to match \(match.2)")
                            }
                        } else {
                            print("Unable to parse score from \(score)")
                        }
                    }
                }
                return game
            }
            return nil
        }
    }
    
    func part1() -> Any {
        games.reduce(0) { sum, game in
            if game.red <= 12 && game.green <= 13 && game.blue <= 14 {
                return sum + game.id
            } else {
                return sum
            }
        }
    }
    
    // Replace this with your solution for the second part of the day's challenge.
    func part2() -> Any {
        games.reduce(0, { $0 + $1.red*$1.green*$1.blue })
    }
}
