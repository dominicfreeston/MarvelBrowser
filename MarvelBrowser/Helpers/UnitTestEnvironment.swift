#if DEBUG
    import RxSwift
    class EmptyImageService: ImageService {
        func image(for url: URL) -> Observable<UIImage> {
            return Observable.empty()
        }
    }

    func isRunningTests() -> Bool {
        return ProcessInfo.processInfo.environment["TEST_MODE"] != nil
    }
#endif
