import XCTest
@testable import MarvelBrowser

class CharactersResponseJSONParsingTests: XCTestCase {

    func testCharacterReponseHasExpectedNumberOfCharacters() {
        let json = loadJSON(named: "charactersResponse")
        let charactersResponse = try? CharactersResponse(json: json)

        XCTAssertEqual(charactersResponse?.characters.count, 20)
    }

}
