import Foundation
import RxSwift

protocol MarvelCharactersUseCaseType {
    func characters() -> Observable<MarvelCharactersList>
    func loadMoreCharacters()
}

class MarvelCharactersUseCase: MarvelCharactersUseCaseType {
    private let apiDataSource: MarvelCharactersDataSource
    private let charactersCache = Variable(MarvelCharactersList.empty)
    private var currentlyLoading = false
    private let disposeBag = DisposeBag()

    init(apiDataSource: MarvelCharactersDataSource) {
        self.apiDataSource = apiDataSource
    }

    func characters() -> Observable<MarvelCharactersList> {
        return charactersCache.asObservable()
    }

    func loadMoreCharacters() {
        guard !currentlyLoading else {
            return
        }

        currentlyLoading = true
        let stopLoading = { self.currentlyLoading = false }

        let count = charactersCache.value.characters.count
        apiDataSource
            .characters(atOffset: count)
            .subscribe(
                onNext: updateCharactersList,
                onCompleted: stopLoading)
            .addDisposableTo(disposeBag)
    }

    private func updateCharactersList(response: CharactersResponse) {
        let currentCharacters = charactersCache.value.characters
        let allCharacters = currentCharacters + response.characters
        let moreAvailable = response.total > allCharacters.count

        charactersCache.value = MarvelCharactersList(
            characters: allCharacters,
            moreAvailable: moreAvailable
        )
    }
}

class FakeMarvelCharactersUseCase: MarvelCharactersUseCaseType {
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
