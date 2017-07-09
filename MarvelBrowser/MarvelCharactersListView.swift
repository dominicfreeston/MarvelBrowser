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
        tableView.reloadData()
    }

    private func setup() {
        adapter.setup(tableView: tableView)

        addSubview(tableView)
        tableView.autoPinEdgesToSuperviewEdges()
    }
}

