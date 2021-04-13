import UIKit
import RxSwift
import RxCocoa

final class ProgressView: UIView {

  private let progressWindow: UIWindow = {
    let window = UIWindow(frame: UIScreen.main.bounds)
    window.windowLevel = .alert
    return window
  }()

  private let blurredContainer: UIVisualEffectView = {
    let view = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
    view.layer.cornerRadius = 10
    view.clipsToBounds = true
    return view
  }()

  private let contentView = UIView()

  enum Status {
    case loading
    case success
  }

  private override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = UIColor(white: 0.2, alpha: 0.2)

    addSubview(blurredContainer)
    blurredContainer.snp.makeConstraints { make in
      make.center.equalToSuperview()
      make.size.equalTo(100)
    }
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  static var instance = ProgressView()

  func show(_ status: Status = .loading, animated: Bool = true) {
    progressWindow.makeKeyAndVisible()
    progressWindow.addSubview(self)
    snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    switch status {
    case .loading:
      let activityIndicator = UIActivityIndicatorView(style: .medium)
      activityIndicator.startAnimating()
      blurredContainer.contentView.addSubview(activityIndicator)
      activityIndicator.snp.makeConstraints { make in
        make.center.equalToSuperview()
      }
    case .success:
      let successView = ProgressSuccessView()
      blurredContainer.contentView.addSubview(successView)
      successView.snp.makeConstraints { make in
        make.edges.equalToSuperview()
      }
    }

    if animated {
      alpha = 0.0
      UIView.animate(withDuration: 0.25) {
        self.alpha = 1.0
      }
    }
  }

  private var isAnimating = false

  func hideWithSuccess(completion: EmptyActionBlock? = nil) {
    isAnimating = true
    UIView.animate(
      withDuration: 0.5,
      animations: {
        self.blurredContainer.contentView.subviews.forEach {
          $0.alpha = 0.0
        }
      }, completion: { _ in
        let successView = ProgressSuccessView()
        self.blurredContainer.contentView.addSubview(successView)
        successView.snp.makeConstraints { make in
          make.edges.equalToSuperview()
        }
        successView.showSuccessAnimated {
          DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.75) {
            self.isAnimating = false
            self.hide()
            completion?()
          }
        }
      }
    )
  }

  func hide(animated: Bool = false) {
    if !animated {
      hideNotAnimated()
      return
    }

    UIView.animate(
      withDuration: 0.25,
      animations: {
        self.alpha = 0.0
    }, completion: { _ in
      self.hideNotAnimated()
    })
  }

  func hideIfNotAnimating() {
    if isAnimating { return }

    hide(animated: true)
  }

  private func hideNotAnimated() {
    self.blurredContainer.contentView.subviews.forEach { $0.removeFromSuperview() }
    self.removeFromSuperview()
    self.progressWindow.isHidden = true
  }
}

extension Reactive where Base: ProgressView {

  var loading: Binder<Bool> {
    return Binder(base) { target, loading in
      if loading {
        target.show()
      } else {
        target.hide()
      }
    }
  }
}
