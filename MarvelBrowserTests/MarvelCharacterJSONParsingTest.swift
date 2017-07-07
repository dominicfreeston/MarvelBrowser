import XCTest
@testable import MarvelBrowser

class MarvelCharacterJSONParsingTest: XCTestCase {

    var character: MarvelCharacter? {
        let json = loadJSON(named: "character")
        return try? MarvelCharacter(json: json)
    }

    func testCharacterHasCorrectIdentifier() {
        XCTAssertEqual(character?.identifier, 1009144)
    }

    func testCharacterHasCorrectName() {
        XCTAssertEqual(character?.name, "A.I.M.")
    }

    func testCharacterHasCorrectDescription() {
        XCTAssertEqual(
            character?.description,
            "AIM is a terrorist organization bent on destroying the world."
        )
    }
}
