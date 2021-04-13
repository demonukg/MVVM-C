import UIKit
import SnapKit

final class ErrorView: UIView {

  private let retryButton: UIButton = {
    let button = UIButton()
    button.setTitle("Retry", for: .normal)
    return button
  }()

  private let errorLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.lineBreakMode = .byWordWrapping
    label.textAlignment = .center
    return label
  }()

  private let retryAction: (() -> Void)?

  init(
    error: Error,
    font: UIFont,
    textColor: UIColor = .red,
    retryAction: EmptyActionBlock? = nil
  ) {
    self.retryAction = retryAction

    super.init(frame: .zero)

    errorLabel.text = error.localizedDescription
    errorLabel.font = font
    errorLabel.textColor = textColor
    retryButton.titleLabel?.font = font
    if retryAction == nil {
      retryButton.isHidden = true
    } else {
      retryButton.addTarget(self, action: #selector(retry), for: .touchUpInside)
    }

    let stackView = UIStackView(arrangedSubviews: [errorLabel, retryButton])
    stackView.axis = .vertical
    stackView.alignment = .center
    addSubview(stackView)
    stackView.snp.makeConstraints { make in
      make.center.equalToSuperview()

      make.top.greaterThanOrEqualToSuperview()
      make.leading.greaterThanOrEqualToSuperview()
      make.trailing.lessThanOrEqualToSuperview()
      make.bottom.lessThanOrEqualToSuperview()
    }
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  @objc
  private func retry() {
    retryAction?()
  }
}
