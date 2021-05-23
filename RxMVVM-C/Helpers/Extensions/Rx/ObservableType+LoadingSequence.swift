import RxSwift

extension ObservableType {

  func asLoadingSequence() -> Observable<LoadingSequence<Element>> {
    materialize()
      .map(LoadingSequence.init)
      .startWith(LoadingSequence(isLoading: true))
  }
}

extension ObservableType where Element: LoadingSequenceConvertible {

  var loading: Observable<Bool> {
    map { $0.isLoading }.distinctUntilChanged()
  }

  var errors: Observable<Error> {
    compactMap { $0.result?.error }
  }

  var element: Observable<Element.Element> {
    compactMap { $0.result?.element }
  }
}

private extension LoadingSequence {

  init(_ event: Event<Element>) {
    switch event {
    case let .error(error):
      self.init(result: .error(error))
    case let .next(element):
      self.init(result: .success(element))
    case .completed:
      self.init(isLoading: false)
    }
  }
}
