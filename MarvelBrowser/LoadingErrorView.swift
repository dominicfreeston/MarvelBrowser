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
        imageView.image = Asset.cross.image
        imageView.contentMode = .center

        messageView.text = L10n.Allcharacters.errorMessage
        messageView.numberOfLines = 0
        messageView.textAlignment = .center

        tryAgainButton.setTitle(L10n.Allcharacters.tryAgain, for: .normal)
        tryAgainButton.tintColor = .marvelRed
        tryAgainButton.isUserInteractionEnabled = false

        backgroundColor = .appBackgroundColor

        setupLayout()
    }

    private func setupLayout() {
        let stackView = UIStackView(arrangedSubviews: [
            imageView, messageView, tryAgainButton
            ])
        stackView.axis = .horizontal
        stackView.spacing = .interItemSpacing

        addSubview(stackView)

        stackView.autoPinEdgesToSuperviewMargins()

        imageView.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        tryAgainButton.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
    }
}
