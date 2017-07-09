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

protocol MarvelCharactersCachingDataSource: MarvelCharactersDataSource {
    func cache(response: MarvelCharactersResponse)
}

class FakeMarvelCharactersDataSource: MarvelCharactersCachingDataSource {
    let scheduler = ConcurrentDispatchQueueScheduler(qos: .background)

    func characters(atOffset offset: Int) -> Observable<MarvelCharactersResponse> {
        if offset == 0 {
            return Observable.just(fakeData(offset: offset)).subscribeOn(scheduler).delay(0.1, scheduler: scheduler)
        }
        return Observable.empty()
    }

    func cache(response: MarvelCharactersResponse) {
        // noop
    }

    private func fakeData(offset: Int) -> MarvelCharactersResponse {
        guard let path = Bundle.main.path(forResource: "charactersResponse", ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
            let json = try? JSONSerialization.jsonObject(with: data, options: []),
            let jsonDict = json as? [String: Any],
            let response = try? MarvelCharactersResponse(json: jsonDict) else {
                preconditionFailure("No data available")
        }

        return response
    }
}
