import Foundation

struct Grid: CustomDebugStringConvertible {
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
    
    init(repeating: String, width: Int, height: Int) {
        grid = [String](repeating: repeating, count: width*height)
        self.width = width
        self.height = height
    }
    
    var debugDescription: String {
        (0..<height).map({ y in
            (0..<width).map({ self[$0, y] }).joined()
        }).joined(separator: "\n")
    }

    subscript(col: Int, row: Int) -> String {
        get {
            let i = row * width + col
            if i < 0 || i >= grid.count {
                print("Bad coords: \((col, row))")
            }
            return grid[row*width+col]
        }
        set {
            grid[row*width+col] = newValue
        }
    }
    
    /// Return the location of a string as (x, y)
    func find(_ s: String) -> (Int, Int)? {
        for x in 0..<width {
            for y in 0..<height {
                if self[x, y] == s {
                    return (x, y)
                }
            }
        }
        return nil
    }
}

