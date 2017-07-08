import XCTest

extension XCTestCase {
    func loadData(named name: String,
                  type: String,
                  file: StaticString = #file,
                  line: UInt = #line) -> Data {
        let bundle = Bundle(for: type(of: self))

        guard let path = bundle.path(forResource: name, ofType: type) else {
            XCTFail("Invalid path for file: \(name)", file: file, line: line)
            return Data()
        }

        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            XCTFail("Invalid data for file: \(name)", file: file, line: line)
            return Data()
        }

        return data
    }

    func loadImage(named name: String,
                   type: String = "jpg",
                  file: StaticString = #file,
                  line: UInt = #line) -> UIImage {
        let data = loadData(named: name, type: type, file: file, line: line)

        guard let image = UIImage(data: data) else {
            XCTFail("Invalid Image for file: \(name)", file: file, line: line)
            return UIImage()
        }

        return image
    }

    func loadJSON(named name: String,
                  file: StaticString = #file,
                  line: UInt = #line) -> [String: Any] {
        let data = loadData(named: name, type: "json", file: file, line: line)

        let json = try? JSONSerialization.jsonObject(with: data, options: [])

        guard let jsonDictionary = json as? [String: Any] else {
            XCTFail("Invalid JSON for file: \(name)", file: file, line: line)
            return [:]
        }
        
        return jsonDictionary
    }
}
