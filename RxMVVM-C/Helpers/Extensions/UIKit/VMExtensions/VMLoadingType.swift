import RxSwift

struct VMLoadingType {
  enum `Type` {
    case request
    case blockingActivity
  }

  let loading: Bool
  let type: Type
}

extension ObservableType where Element == Bool {

  func asRequest() -> Observable<VMLoadingType> {
    map { VMLoadingType(loading: $0, type: .request) }
  }

  func asBlockingActivity() -> Observable<VMLoadingType> {
    map { VMLoadingType(loading: $0, type: .blockingActivity) }
  }
}
