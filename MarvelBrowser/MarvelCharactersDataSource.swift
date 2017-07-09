import Foundation
import RxSwift

protocol MarvelCharactersDataSource {
    func characters(atOffset: Int) -> Observable<CharactersResponse>
}

class FakeMarvelCharactersDataSource: MarvelCharactersDataSource {
    let scheduler = ConcurrentDispatchQueueScheduler(qos: .background)

    func characters(atOffset: Int) -> Observable<CharactersResponse> {
        return Observable.just(fakeData()).subscribeOn(scheduler).delay(0.1, scheduler: scheduler)
    }

    func fakeData() -> CharactersResponse {
        guard let path = Bundle.main.path(forResource: "charactersResponse", ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
            let json = try? JSONSerialization.jsonObject(with: data, options: []),
            let jsonDict = json as? [String: Any],
            let response = try? CharactersResponse(json: jsonDict) else {
                preconditionFailure("No data available")
        }

        let limitedResponse = CharactersResponse(
            total: 80,
            characters: response.characters
        )

        return limitedResponse
    }
}
