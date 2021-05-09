import UIKit
import SnapKit

final class AuthView: UIView {

  var onEnterTap: SingleActionBlock<String>?

  let phoneNumberField: UITextField = {
    let textField = PrimaryTextField()
    textField.attributedPlaceholder = NSAttributedString(string: "+73616751221", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    textField.keyboardType = .phonePad
    textField.layer.borderColor = UIColor.red.cgColor
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
      phoneNumberField,
      enterButton
    ]
    .toVerticalStackView()
    .spaced(Layout.Spacing.mediumBig)
    .with(spacing: Layout.Spacing.mediumBiggest, after: phoneNumberField)
    .with(alignment: .center)
    .build()

    addSubview(stack)

    stack.snp.makeConstraints { make in
      make.top.equalTo(safeOrMarginLayoutGuide).inset(Layout.Spacing.big)
      make.leading.trailing.equalToSuperview().inset(Layout.Spacing.medium)
    }

    phoneNumberField.snp.makeConstraints { make in
      make.width.equalToSuperview()
    }

    enterButton.snp.makeConstraints { make in
      make.width.equalToSuperview()
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
