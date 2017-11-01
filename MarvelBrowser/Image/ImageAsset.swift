import Foundation
import Unbox

struct ImageAsset {
    enum Size: String {
        case squareMedium = "standard_medium"
    }

    let path: URL
    let fileExtension: String

    func url(for size: ImageAsset.Size) -> URL {
        return path
            .appendingPathComponent(size.rawValue)
            .appendingPathExtension(fileExtension)
    }
}

extension ImageAsset: Unboxable {
    init(unboxer: Unboxer) throws {
        self.path = try unboxer.unbox(key: "path")
        self.fileExtension = try unboxer.unbox(key: "extension")
    }
}
