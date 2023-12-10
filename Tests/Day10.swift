import XCTest

@testable import AdventOfCode

final class Day10Tests: XCTestCase {
    
    
    func testPart1() throws {
        let testData = """
        ..F7.
        .FJ|.
        SJ.L7
        |F--J
        LJ...
        """
        let challenge = Day10(data: testData)
        XCTAssertEqual(String(describing: challenge.part1()), "8")
    }
    
    func testPart2() throws {
        let testData = """
        ...........
        .S-------7.
        .|F-----7|.
        .||.....||.
        .||.....||.
        .|L-7.F-J|.
        .|..|.|..|.
        .L--J.L--J.
        ...........
        """
        let challenge = Day10(data: testData)
        XCTAssertEqual(String(describing: challenge.part2()), "4")
    }
}
