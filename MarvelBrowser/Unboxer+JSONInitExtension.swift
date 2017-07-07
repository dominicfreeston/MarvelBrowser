import Foundation
import Unbox

extension Unboxable {
    init(json: [String: Any]) throws {
        try self.init(unboxer: Unboxer(dictionary: json))
    }
}
