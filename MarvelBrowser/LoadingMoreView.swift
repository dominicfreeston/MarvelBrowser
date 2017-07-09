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

        activityIndicator.color = UIColor(red: 0.88, green: 0.21, blue: 0.21, alpha: 1)
    }

    func start() {
        activityIndicator.startAnimating()
    }
}
