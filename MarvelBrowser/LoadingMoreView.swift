import UIKit
import PureLayout

class LoadingMoreView: UIView {
    let activityIndicator = UIActivityIndicatorView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addSubview(activityIndicator)

        autoSetDimension(.height, toSize: 64)
        activityIndicator.autoCenterInSuperview()

        activityIndicator.color = .marvelRed
        backgroundColor = .appBackgroundColor
    }

    func start() {
        activityIndicator.startAnimating()
    }
}
