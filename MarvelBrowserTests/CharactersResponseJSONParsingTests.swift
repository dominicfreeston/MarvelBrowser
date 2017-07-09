import XCTest
@testable import MarvelBrowser

class CharactersResponseJSONParsingTests: XCTestCase {

    func testCharacterResponseIncludesTotalNumberOfAvailableCharacters() {
        let json = loadJSON(named: "charactersResponse")
        let charactersResponse = try? CharactersResponse(json: json)

        XCTAssertEqual(charactersResponse?.total, 1485)
    }

    func testCharacterReponseHasExpectedNumberOfCharacters() {
        let json = loadJSON(named: "charactersResponse")
        let charactersResponse = try? CharactersResponse(json: json)

        XCTAssertEqual(charactersResponse?.characters.count, 20)
    }

}
