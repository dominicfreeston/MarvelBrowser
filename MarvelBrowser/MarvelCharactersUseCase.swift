import Foundation
import RxSwift

protocol MarvelCharactersUseCase {
    func characters() -> Observable<MarvelCharactersList>
    func loadMoreCharacters()
}

class FakeMarvelCharactersUseCase: MarvelCharactersUseCase {
    private let charactersCache = Variable([MarvelCharacter]())
    private var currentlyLoading = false

    func characters() -> Observable<MarvelCharactersList> {
        return charactersCache.asObservable().map(MarvelCharactersList.init)
    }

    func loadMoreCharacters() {
        guard !currentlyLoading else {
            return
        }

        // Fake an API call
        currentlyLoading = true
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(2))  {
            let new = self.fakeData()
            let current = self.charactersCache.value

            self.charactersCache.value = current + new

            self.currentlyLoading = false
        }

    }
    func fakeData() -> [MarvelCharacter] {
        guard let path = Bundle.main.path(forResource: "charactersResponse", ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
            let json = try? JSONSerialization.jsonObject(with: data, options: []),
            let jsonDict = json as? [String: Any],
            let response = try? CharactersResponse(json: jsonDict) else {
                return []
        }

        return response.characters
    }
}
