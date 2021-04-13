import UIKit
import SnapKit

final class AuthView: UIView {

  var onEnterTap: SingleActionBlock<String>?

  private let phoneNumberField: UITextField = {
    let textField = UITextField()
    textField.placeholder = "+73616751221"
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
    label.text = "Enter your phone number"
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
      phoneNumberField
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

private extension AuthView {

  @objc
  func enterButtonTap() {
    guard let text = phoneNumberField.text else { return }
    onEnterTap?(text)
  }
}
