import UIKit

extension UIView {

  private struct AssociatedKeys {
    static var errorView = "error_view_key"
  }

  private var errorView: UIView! {
    get {
      return objc_getAssociatedObject(self, &AssociatedKeys.errorView) as? UIView
    }
    set {
      objc_setAssociatedObject(self, &AssociatedKeys.errorView, newValue, .OBJC_ASSOCIATION_RETAIN)
    }
  }

  func showError(
    _ error: Error,
    font: UIFont = .regular14,
    retryAction: (() -> Void)? = nil
  ) {
    errorView?.removeFromSuperview()

    errorView = ErrorView(error: error, font: font, retryAction: retryAction)
    errorView.backgroundColor = backgroundColor
    addSubview(errorView)
    errorView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }

  func hideError() {
    errorView?.removeFromSuperview()
    errorView = nil
  }
}
