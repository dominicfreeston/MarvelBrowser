import UIKit

class MarvelCharactersAdapter: NSObject, UITableViewDataSource, UITableViewDelegate {
    var charactersList = MarvelCharactersList.empty
    var loadMoreAction: (() -> Void)?

    func setup(tableView: UITableView) {
        tableView.register(TableViewCell<MarvelCharacterView>.self)
        tableView.register(TableViewCell<LoadingMoreView>.self)

        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none

        tableView.dataSource = self
        tableView.delegate = self
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return charactersList.characters.count
        case 1: return 1
        default: preconditionFailure("Unexpected Section")
        }

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell: TableViewCell<MarvelCharacterView> = tableView.dequeueReusableCell(for: indexPath)
            let character = charactersList.characters[indexPath.row]
            cell.view.update(with: character)
            return cell
        case 1:
            let cell: TableViewCell<LoadingMoreView> = tableView.dequeueReusableCell(for: indexPath)
            return cell
        default:
            preconditionFailure("Unexpected Section")
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? TableViewCell<LoadingMoreView> {
            cell.view.start()
            loadMoreAction?()
        }
    }
}
