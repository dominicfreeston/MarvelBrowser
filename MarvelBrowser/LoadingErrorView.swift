import UIKit
import PureLayout

class LoadingErrorView: UIView {
    let imageView = UIImageView()
    let messageView = UILabel()
    let tryAgainButton = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        imageView.image = #imageLiteral(resourceName: "cross")
        imageView.contentMode = .center

        messageView.text = "Loading failed!\nMaybe it's Magneto?"
        messageView.numberOfLines = 0
        messageView.textAlignment = .center

        tryAgainButton.setTitle("Try Again", for: .normal)
        tryAgainButton.tintColor = .marvelRed

        backgroundColor = .appBackgroundColor

        setupLayout()
    }

    private func setupLayout() {
        let stackView = UIStackView(arrangedSubviews: [
            imageView, messageView, tryAgainButton
            ])
        stackView.axis = .horizontal
        stackView.spacing = 10

        addSubview(stackView)

        stackView.autoPinEdgesToSuperviewMargins()

        imageView.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        tryAgainButton.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
    }
}
