import Foundation
import RxSwift

protocol MarvelCharactersDataSource {
    func characters(atOffset: Int) -> Observable<MarvelCharactersResponse>
}

class MarvelAPICharactersDataSource: MarvelCharactersDataSource {
    let requestFactory: MarvelRequestFactory
    let session: URLSession
    
    init(requestFactory: MarvelRequestFactory = MarvelRequestFactory.defaultFactory,
         session: URLSession = URLSession.shared) {
        self.requestFactory = requestFactory
        self.session = session
    }

    func characters(atOffset offset: Int) -> Observable<MarvelCharactersResponse> {
        let request = requestFactory.charactersRequest(offset: offset)
        return session.rx
            .data(request: request)
            .map(toJSON)
            .map(MarvelCharactersResponse.init)
    }
}
