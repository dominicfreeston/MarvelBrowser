import UIKit

class MarvelCharactersAdapter: NSObject, UITableViewDataSource, UITableViewDelegate {
    var characters = [MarvelCharacter]()

    func setup(tableView: UITableView) {
        tableView.register(TableViewCell<MarvelCharacterView>.self)

        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none

        tableView.dataSource = self
        tableView.delegate = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TableViewCell<MarvelCharacterView> = tableView.dequeueReusableCell(for: indexPath)
        let character = characters[indexPath.row]
        cell.view.update(with: character)
        return cell
    }
}
