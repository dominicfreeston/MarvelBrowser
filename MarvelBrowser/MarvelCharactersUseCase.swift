import Foundation
import RxSwift

protocol MarvelCharactersUseCase {
    func characters() -> Observable<[MarvelCharacter]>
}

class FakeMarvelCharactersUseCase: MarvelCharactersUseCase {
    func characters() -> Observable<[MarvelCharacter]> {
        guard let path = Bundle.main.path(forResource: "charactersResponse", ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
            let json = try? JSONSerialization.jsonObject(with: data, options: []),
            let jsonDict = json as? [String: Any],
            let response = try? CharactersResponse(json: jsonDict) else {
                return Observable.just([])
        }

        return Observable.just(response.characters)
    }
}
