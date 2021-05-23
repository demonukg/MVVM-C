import UIKit

public extension UIView {

  var safeOrMarginLayoutGuide: UILayoutGuide {
    if #available(iOS 11, *) {
      return safeAreaLayoutGuide
    } else {
      return layoutMarginsGuide
    }
  }
}
