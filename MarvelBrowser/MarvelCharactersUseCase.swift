import Foundation
import RxSwift

protocol MarvelCharactersUseCase {
    func characters() -> Observable<[MarvelCharacter]>
}

class FakeMarvelCharactersUseCase: MarvelCharactersUseCase {
    func characters() -> Observable<[MarvelCharacter]> {
        return Observable.just([])
    }
}
