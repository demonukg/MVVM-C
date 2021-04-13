import RxSwift

enum VMErrorType {
  case message(error: Error)
  case info(error: Error)
}

extension ObservableType where Element: Error {

  func asInfo() -> Observable<VMErrorType> {
    map { VMErrorType.info(error: $0) }
  }

  func asMessage() -> Observable<VMErrorType> {
    map { VMErrorType.message(error: $0) }
  }
}
