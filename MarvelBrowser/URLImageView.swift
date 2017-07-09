import UIKit
import RxSwift
import RxCocoa

class URLImageView: UIImageView {
    private let imageService: ImageService

    private var disposeBag = DisposeBag()
    private var currentURL: URL?

    var placeholderImage: UIImage?

    init(frame: CGRect = .zero, imageService: ImageService) {
        self.imageService = imageService
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(with url: URL?) {
        guard url != currentURL else {
            return
        }

        image = placeholderImage
        currentURL = url
        disposeBag = DisposeBag()

        guard let url = url else {
            return
        }

        imageService.image(for: url)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] image in
                self?.image = image
            }).addDisposableTo(disposeBag)
    }
}
