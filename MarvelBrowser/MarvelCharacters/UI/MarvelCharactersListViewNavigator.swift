import UIKit

protocol MarvelCharacterListViewNavigator {
    func goToMarvel()
}

class SimpleMarvelCharacterListViewNavigator: MarvelCharacterListViewNavigator {
    func goToMarvel() {
        UIApplication.shared.open(
            URL(string: "http://www.marvel.com")!,
            options: [:],
            completionHandler: nil
        )
    }
}
