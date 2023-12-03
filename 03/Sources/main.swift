import Foundation

print("sample: \(gondola("sample.txt"))")
print("input: \(gondola("input.txt"))")

extension String {
    var isNumber: Bool {
        self.first!.isNumber
    }
}

struct Grid {
    var grid: [String]
    let width: Int
    let height: Int
    
    init(_ s: String) {
        let lines = s.split(separator:"\n").map { String($0) }
        height = lines.count
        width = lines.first?.count ?? 0
        grid = []
        for line in lines {
            grid.append(contentsOf: line.map({String($0)}))
        }
    }
    
    subscript(col: Int, row: Int) -> String {
        let i = row * width + col
        if i < 0 || i >= grid.count {
            print("Bad coords: \((col, row))")
        }
        return grid[row*width+col]
    }
    
    /// Return the location of all locations surrounding a span
    func boundary(x: Int, y: Int, length: Int) -> [(Int, Int)] {
        var coords: [(Int, Int)] = []
        for b in [y-1, y+1] {
            for a in x-1..<x+length+1 {
                if a >= 0 && a < width && b >= 0 && b < height {
                    coords.append((a, b))
                }
            }
        }
        if x > 0 {
            coords.append((x-1, y))
        }
        if x+length < width {
            coords.append((x+length, y))
        }
        return coords
    }
}

func gondola(_ filename: String) -> (Int, Int) {
    let contents = try! String(contentsOfFile: filename)
    let schematic = Grid(contents)

    var parts: [(String, [(Int, Int)])] = []
    var sum1 = 0
    for y in 0..<schematic.height {
        var x = 0
        while x < schematic.width {
            if schematic[x, y].isNumber {
                var partNumber = ""
                while x < schematic.width && schematic[x, y].isNumber  {
                    partNumber = partNumber.appending(schematic[x, y])
                    x += 1
                }
                let boundary = schematic.boundary(x: x-partNumber.count, y: y, length: partNumber.count)
                for (x, y) in boundary {
                    let s = schematic[x, y]
                    if !(s.isNumber || s == ".") {
                        parts.append((partNumber, boundary))
                        sum1 += Int(partNumber)!
                        break
                    }
                }
            } else {
                x += 1
            }
        }
    }

    var sum2 = 0
    for row in 0..<schematic.height {
        for col in 0..<schematic.width {
            if schematic[col, row] == "*" {
                var matchingParts: [String] = []
                for (partNumber, boundary) in parts {
                    if boundary.contains(where: { $0 == (col, row) }) {
                        matchingParts.append(partNumber)
                    }
                }
                if matchingParts.count == 2 {
                    sum2 += Int(matchingParts[0])! * Int(matchingParts[1])!
                }
            }
        }
    }
    return (sum1, sum2)
}
