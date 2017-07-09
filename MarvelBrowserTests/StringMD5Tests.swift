import XCTest
@testable import MarvelBrowser

class StringMD5Tests: XCTestCase {
    func testMD5ReturnsExpectedValue() {
        let originalString = "1abcd1234"
        let md5Hash = originalString.MD5()

        XCTAssertEqual(md5Hash, "ffd275c5130566a2916217b101f26150")
    }
}
