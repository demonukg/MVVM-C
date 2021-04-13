import RxSwift

extension Observable {

  func asVoid() -> Observable<Void> {
    map { _ in }
  }
}
