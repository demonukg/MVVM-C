import UIKit
import RxSwift

protocol ViewHolder: class {
  associatedtype RootViewType: UIView
}

extension ViewHolder where Self: UIViewController {

  var rootView: RootViewType {
    guard let rootView = view as? RootViewType else {
      fatalError("Excpected \(RootViewType.description()) as rootView. Now \(type(of: view))")
    }
    return rootView
  }
}

extension ViewHolder where Self: UIViewController {

  var disposeBag: DisposeBag {
    guard let existingDisposeBag = objc_getAssociatedObject(self, &AssociatedKeys.disposeBag) as? DisposeBag else {
      let newDisposeBag = DisposeBag()
      objc_setAssociatedObject(self, &AssociatedKeys.disposeBag, newDisposeBag, .OBJC_ASSOCIATION_RETAIN)
      return newDisposeBag
    }

    return existingDisposeBag
  }
}

private struct AssociatedKeys {

  static var disposeBag = "dispose_bag_key"
}
