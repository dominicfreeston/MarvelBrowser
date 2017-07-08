import UIKit
import RxSwift

protocol ImageService {
    func image(for url: URL) -> Observable<UIImage>
}
