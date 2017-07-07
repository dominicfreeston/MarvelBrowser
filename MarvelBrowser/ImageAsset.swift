import Foundation
import Unbox

struct ImageAsset {
    let path: URL
    let fileExtension: String
}

extension ImageAsset: Unboxable {
    init(unboxer: Unboxer) throws {
        self.path = try unboxer.unbox(key: "path")
        self.fileExtension = try unboxer.unbox(key: "extension")
    }
}
