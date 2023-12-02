import Foundation

print("sample: \(ballgame("sample.txt"))")
print("input: \(ballgame("input.txt"))")

struct Game {
    let id: Int
    var red: Int
    var green: Int
    var blue: Int
}

func ballgame(_ filename: String) -> (Int, Int) {
    let contents = try! String(contentsOfFile: filename)
    let lines = contents.split(separator:"\n").map { String($0) }
  
    var sum1 = 0
    var sum2 = 0
    for line in lines {
        if let game = parseGame(line) {
            if game.red <= 12 && game.green <= 13 && game.blue <= 14 {
                sum1 += game.id
            }
            sum2 += game.red * game.green * game.blue
        }
    }

    return (sum1, sum2)
}

///  Parse game summary, e.g. "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green"
func parseGame(_ summary: String) -> Game? {
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
