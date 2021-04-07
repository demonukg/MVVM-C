import RxSwift

public extension Observable {

  func asVoid() -> Observable<Void> {
    map { _ in }
  }
}
