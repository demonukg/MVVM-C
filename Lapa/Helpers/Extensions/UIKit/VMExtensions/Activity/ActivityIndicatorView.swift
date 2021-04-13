import UIKit

final class ActivityIndicatorView: UIView {

  private let activityIndicator: UIActivityIndicatorView

  init(
    style: UIActivityIndicatorView.Style = .medium,
    backgroundColor: UIColor = .red
  ) {
    activityIndicator = UIActivityIndicatorView(style: style)

    super.init(frame: .zero)
    self.backgroundColor = backgroundColor
    addSubview(activityIndicator)
    activityIndicator.snp.makeConstraints { make in
      make.edges.lessThanOrEqualToSuperview().inset(Layout.Spacing.medium).priority(.low)
      make.center.equalToSuperview()
    }
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func startAnimating() {
    activityIndicator.startAnimating()
  }

  func stopAnimating() {
    activityIndicator.stopAnimating()
  }
}
