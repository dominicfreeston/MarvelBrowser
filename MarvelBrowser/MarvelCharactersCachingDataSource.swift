import Foundation
import RxSwift

protocol MarvelCharactersCachingDataSource: MarvelCharactersDataSource {
    func cache(response: MarvelCharactersResponse)
}

class MarvelCharactersDiskDataSource: MarvelCharactersCachingDataSource {
    let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    static let folderName = "responses"

    init() {
        let url = URL(fileURLWithPath: documentsPath).appendingPathComponent(MarvelCharactersDiskDataSource.folderName)
        try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
    }

    func characters(atOffset offset: Int) -> Observable<MarvelCharactersResponse> {
        return Observable.create { observer in
            if let data = try? Data(contentsOf: MarvelCharactersDiskDataSource.fileURL(forOffset: offset)),
                let json = try? data.toJSON(),
                let response = try? MarvelCharactersResponse(json: json) {
                observer.onNext(response)
            }
            observer.onCompleted()

            return Disposables.create()
        }
    }

    func cache(response: MarvelCharactersResponse) {
        if let data = try? JSONSerialization.data(withJSONObject: response.originalResponse, options: []) {
            let url = MarvelCharactersDiskDataSource.fileURL(forOffset: response.offset)
            try? data.write(to: url)
        }
    }

    private static func fileURL(forOffset offset: Int) -> URL {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        return URL(fileURLWithPath: paths[0]).appendingPathComponent("\(folderName)/response-\(offset).json")
    }
}
