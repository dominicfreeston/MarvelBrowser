import Foundation
import Unbox

typealias CharacterIdentifier = Int

struct Character {
    let identifier: CharacterIdentifier
    let name: String
    let description: String
    let thumbnail: ImageAsset
}

extension Character: Unboxable {
    init(json: [String: Any]) throws {
        try self.init(unboxer: Unboxer(dictionary: json))
    }

    init(unboxer: Unboxer) throws {
        self.identifier = try unboxer.unbox(key: "id")
        self.name = try unboxer.unbox(key: "name")
        self.description = try unboxer.unbox(key: "description")
        self.thumbnail = ImageAsset(path: URL(fileURLWithPath: ""), fileExtension: "")
    }
}
