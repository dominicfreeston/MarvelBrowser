import UIKit
import PureLayout

class MarvelCharacterListViewController: UIViewController {
    let listView = MarvelCharacterListView()

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "All Characters"

        view.addSubview(listView)
        listView.autoPinEdgesToSuperviewEdges()

        loadCharacters()
    }

    func loadCharacters() {
        guard let path = Bundle.main.path(forResource: "charactersResponse", ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
            let json = try? JSONSerialization.jsonObject(with: data, options: []),
            let jsonDict = json as? [String: Any],
            let response = try? CharactersResponse(json: jsonDict) else {
                return
        }

        listView.update(with: response.characters)
    }
}
