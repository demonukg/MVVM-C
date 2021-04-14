import UIKit
import SnapKit

final class ValidationView: UIView {

  var onEnterTap: SingleActionBlock<String>?

  private let pinField: UITextField = {
    let textField = UITextField()
    textField.placeholder = "000000"
    return textField
  }()

  private let enterButton: UIButton = {
    let button = PrimaryButton()
    button.setTitle("Enter", for: .normal)
    button.addTarget(self, action: #selector(enterButtonTap), for: .touchUpInside)
    return button
  }()

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "Enter PIN"
    label.font = .regular18
    return label
  }()

  init() {
    super.init(frame: .zero)

    setupInitialLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupInitialLayout() {
    let stack = [
      titleLabel,
      pinField
    ]
    .toVerticalStackView()
    .spaced(Layout.Spacing.mediumBig)
    .with(alignment: .center)
    .build()

    addSubview(stack)

    stack.snp.makeConstraints { make in
      make.top.equalTo(safeAreaLayoutGuide).inset(Layout.Spacing.big)
      make.leading.trailing.equalToSuperview().inset(Layout.Spacing.medium)
    }

    addSubview(enterButton)

    enterButton.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(Layout.Spacing.big)
      make.bottom.equalToSuperview().inset(Layout.Spacing.mediumBig)
    }
  }
}

private extension ValidationView {

  @objc
  func enterButtonTap() {
    guard let text = pinField.text else { return }
    onEnterTap?(text)
  }
}
