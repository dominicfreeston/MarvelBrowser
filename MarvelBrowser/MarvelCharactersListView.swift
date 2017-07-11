import UIKit
import PureLayout

class MarvelCharacterListView: UIView {
    let tableView = UITableView()
    let adapter = MarvelCharactersAdapter()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(with charactersList: MarvelCharactersList) {
        adapter.charactersList = charactersList
    }

    private func setup() {
        adapter.setup(tableView: tableView)

        addSubview(tableView)

        let extraLength: CGFloat = 3000
        tableView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .bottom)
        tableView.autoPinEdge(toSuperviewEdge: .bottom, withInset: -extraLength)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: extraLength, right: 0)
        tableView.scrollIndicatorInsets = tableView.contentInset

        clipsToBounds = true
    }
}

