import UIKit

extension UIView {

  private struct AssociatedKeys {
    static var activityKey = "activityKey"
  }

  private var activity: ActivityIndicatorView? {
    get {
      return objc_getAssociatedObject(self, &AssociatedKeys.activityKey) as? ActivityIndicatorView
    }
    set {
      objc_setAssociatedObject(self, &AssociatedKeys.activityKey, newValue, .OBJC_ASSOCIATION_RETAIN)
    }
  }

  func showActivity(
    style: UIActivityIndicatorView.Style = .medium,
    backgroundColor: UIColor = .red
  ) {
    if activity != nil { return }
    let activity = ActivityIndicatorView(style: style, backgroundColor: backgroundColor)
    activity.startAnimating()
    addSubview(activity)
    activity.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    self.activity = activity
  }

  func hideActivity(animated: Bool = true) {
    let hideActivityAnimation: EmptyActionBlock = { [weak self] in
      self?.activity?.alpha = 0
    }

    let completion: (Bool) -> Void = { [weak self] _ in
      self?.activity?.stopAnimating()
      self?.activity?.removeFromSuperview()
      self?.activity = nil
    }

    if animated {
      UIView.animate(
        withDuration: 0.25,
        animations: hideActivityAnimation,
        completion: completion
      )
    } else {
      hideActivityAnimation()
      completion(true)
    }
  }
}
