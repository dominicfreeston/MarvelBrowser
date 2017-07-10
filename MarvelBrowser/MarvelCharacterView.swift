import UIKit
import PureLayout

class MarvelCharacterView: UIView {
    let nameLabel = UILabel()
    let descriptionLabel = UILabel()
    let imageView: URLImageView

    override convenience init(frame: CGRect) {
        #if DEBUG
            if isRunningTests() {
                self.init(frame: frame, imageService: EmptyImageService())
                return
            }
        #endif
        self.init(frame: frame, imageService: HTTPImageService.shared)
    }

    init(frame: CGRect = .zero, imageService: ImageService) {
        self.imageView = URLImageView(frame: .zero, imageService: imageService)

        super.init(frame: frame)

        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(with character: MarvelCharacter) {
        self.nameLabel.text = character.name
        self.descriptionLabel.text = character.description
        self.imageView.update(with: character.thumbnail.url(for: .squareMedium))
    }

    private func setup() {
        imageView.placeholderImage = #imageLiteral(resourceName: "placeholder")

        nameLabel.numberOfLines = 0
        descriptionLabel.numberOfLines = 0

        nameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)

        backgroundColor = .appBackgroundColor

        setupLayout()
    }

    private func setupLayout() {
        let verticalStackView = UIStackView(arrangedSubviews: [nameLabel, descriptionLabel])
        verticalStackView.axis = .vertical
        verticalStackView.distribution = .equalCentering

        let imageViewWrapper = UIView()
        imageViewWrapper.addSubview(imageView)

        let horizontalStackView = UIStackView(arrangedSubviews: [imageViewWrapper, verticalStackView])
        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = .interItemSpacing

        addSubview(horizontalStackView)

        horizontalStackView.autoPinEdgesToSuperviewMargins()
        imageView.autoSetDimensions(to: CGSize(width: .thumbnailSize, height: .thumbnailSize))

        imageView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .bottom)
        imageView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0, relation: .greaterThanOrEqual)
    }
}
