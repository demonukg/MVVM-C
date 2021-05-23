import UIKit

protocol Presentable: class {
  
  var toPresent: UIViewController? { get }
}

extension Presentable {
  
  func withDisabledLargeTitle() -> Presentable? {
    guard let controllerToPresent = toPresent else { return nil }
    if #available(iOS 11, *) {
      controllerToPresent.navigationItem.largeTitleDisplayMode = .never
    }
    return controllerToPresent
  }
}
 
extension UIViewController: Presentable {
  
  var toPresent: UIViewController? {
    self
  }
}
