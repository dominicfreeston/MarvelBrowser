import UIKit

extension UITableViewCell {
    static var defaultReuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableView {
    func register<T: UITableViewCell>(_ type: T.Type) {
        let reuseIdentifier = type.defaultReuseIdentifier
        self.register(type.self, forCellReuseIdentifier: reuseIdentifier)
    }

    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(
            withIdentifier: T.defaultReuseIdentifier,
            for: indexPath) as? T else {
                fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
        }

        return cell
    }
}

class TableViewCell<ContentView>: UITableViewCell where ContentView: UIView {
    let view = ContentView()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("This view is not designed to be used with xib or storyboard files")
    }

    private func setup() {
        contentView.addSubview(view)
        view.autoPinEdgesToSuperviewEdges()
    }
}
