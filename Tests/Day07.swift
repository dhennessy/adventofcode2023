import XCTest

@testable import AdventOfCode

final class Day07Tests: XCTestCase {
    let testData = """
    32T3K 765
    T55J5 684
    KK677 28
    KTJJT 220
    QQQJA 483
    """
    
    func testPart1() throws {
        let challenge = Day07(data: testData)
        XCTAssertEqual(String(describing: challenge.part1()), "6440")
    }
    
    func testHandWithJoker() throws {
        XCTAssertEqual(String(describing: Hand("32T3K 1", useJoker: true).trick), "pair")
        XCTAssertEqual(String(describing: Hand("T55J5 1", useJoker: true).trick), "fourOfAKind")
        XCTAssertEqual(String(describing: Hand("KK677 1", useJoker: true).trick), "twoPair")
        XCTAssertEqual(String(describing: Hand("KTJJT 1", useJoker: true).trick), "fourOfAKind")
        XCTAssertEqual(String(describing: Hand("QQQJA 1", useJoker: true).trick), "fourOfAKind")
    }
    
    func testPart2() throws {
        let challenge = Day07(data: testData)
        XCTAssertEqual(String(describing: challenge.part2()), "5905")
    }
}
