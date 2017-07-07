import XCTest

extension XCTestCase {
    func loadJSON(named name: String,
                  file: StaticString = #file,
                  line: UInt = #line) -> [String: Any] {

        let bundle = Bundle(for: type(of: self))

        guard let path = bundle.path(forResource: name, ofType: "json") else {
            XCTFail("Invalid path for file: \(name)", file: file, line: line)
            return [:]
        }

        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            XCTFail("Invalid data for file: \(name)", file: file, line: line)
            return [:]
        }

        let json = try? JSONSerialization.jsonObject(with: data, options: [])

        guard let jsonDictionary = json as? [String: Any] else {
            XCTFail("Invalid JSON for file: \(name)", file: file, line: line)
            return [:]
        }
        
        return jsonDictionary
    }
}
