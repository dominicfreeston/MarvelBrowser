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

class FakeMarvelCharactersDataSource: MarvelCharactersDataSource {
    let scheduler = ConcurrentDispatchQueueScheduler(qos: .background)

    func characters(atOffset: Int) -> Observable<MarvelCharactersResponse> {
        return Observable.just(fakeData()).subscribeOn(scheduler).delay(0.1, scheduler: scheduler)
    }

    func fakeData() -> MarvelCharactersResponse {
        guard let path = Bundle.main.path(forResource: "charactersResponse", ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
            let json = try? JSONSerialization.jsonObject(with: data, options: []),
            let jsonDict = json as? [String: Any],
            let response = try? MarvelCharactersResponse(json: jsonDict) else {
                preconditionFailure("No data available")
        }

        let limitedResponse = MarvelCharactersResponse(
            total: 80,
            characters: response.characters
        )

        return limitedResponse
    }
}
