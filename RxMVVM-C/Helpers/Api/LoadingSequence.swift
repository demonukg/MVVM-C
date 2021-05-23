protocol LoadingSequenceConvertible {

  associatedtype Element

  var result: CustomResult<Element>? { get }
  var isLoading: Bool { get }
}

struct LoadingSequence<Element>: LoadingSequenceConvertible {

  let result: CustomResult<Element>?
  let isLoading: Bool

  init(isLoading: Bool) {
    self.result = nil
    self.isLoading = isLoading
  }

  init(result: CustomResult<Element>) {
    self.result = result
    self.isLoading = false
  }

  func convertElement<R>(_ transform: (Element) -> R) -> LoadingSequence<R> {
    guard let result = result else {
      return LoadingSequence<R>(isLoading: isLoading)
    }
    switch result {
    case .error(let error):
      return LoadingSequence<R>(result: .error(error))
    case .success(let element):
      return LoadingSequence<R>(result: .success(transform(element)))
    }
  }
}
