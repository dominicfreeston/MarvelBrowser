import XCTest
@testable import MarvelBrowser

class MarvelRequestFactoryTests: XCTestCase {

    func testItCreatesTheExpectedCharactersRequest() {
        let factory = MarvelRequestFactory(
            publicKey: "1234",
            privateKey: "abcd",
            baseURLString: "http://gateway.marvel.com/"
        )

        let charactersRequest = factory.charactersRequest(offset: 20, timestamp: 1)

        XCTAssertEqual(charactersRequest.url?.absoluteString,
                       "http://gateway.marvel.com/v1/public/characters?offset=20&limit=100&ts=1&apikey=1234&hash=ffd275c5130566a2916217b101f26150")
    }
    
}
