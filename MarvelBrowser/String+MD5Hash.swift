import Foundation

// Credits go to https://stackoverflow.com/questions/32163848/how-to-convert-string-to-md5-hash-using-ios-swift

extension String {
    func MD5() -> String {
        let originalData = data(using:.utf8)!
        var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))

        _ = digestData.withUnsafeMutableBytes { digestBytes in
            originalData.withUnsafeBytes { originalBytes in
                CC_MD5(originalBytes, CC_LONG(originalData.count), digestBytes)
            }
        }

        return digestData
            .map { String(format: "%02hhx", $0) }
            .joined()
    }
}
