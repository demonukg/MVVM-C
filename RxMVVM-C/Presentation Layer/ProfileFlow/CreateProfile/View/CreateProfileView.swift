import UIKit
import SnapKit

final class CreateProfileView: UIView {

  // MARK: - Properties

  let nameField: UITextField = {
    let textField = PrimaryTextField()
    textField.placeholder = "Ivan"
    textField.keyboardType = .alphabet
    return textField
  }()

  let cityField: UITextField = {
    let textField = PrimaryTextField()
    textField.placeholder = "New York"
    textField.keyboardType = .alphabet
    return textField
  }()

  let nicknameField: UITextField = {
    let textField = PrimaryTextField()
    textField.placeholder = "Ivanator666"
    return textField
  }()

  let phoneNumberField: UITextField = {
    let textField = PrimaryTextField()
    textField.placeholder = "+73616751221"
    textField.keyboardType = .phonePad
    textField.layer.borderColor = UIColor.red.cgColor
    return textField
  }()

  let saveButton: UIButton = {
    let button = PrimaryButton()
    button.setTitle("Enter", for: .normal)
    return button
  }()

  let errorLabel: UILabel = {
    let label = UILabel()
    label.textColor = .red
    label.text = "All fields required"
    label.font = .regular12
    label.isHidden = true
    label.textAlignment = .center
    return label
  }()

  // MARK: - Initialization

  init() {
    super.init(frame: .zero)
    backgroundColor = .white
    setupInitialLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupInitialLayout() {
    let scrollView = UIScrollView()
    addSubview(scrollView)
    scrollView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    let stack = [
      createLabel(for: "Name"),
      nameField,
      createLabel(for: "City"),
      cityField,
      createLabel(for: "Nickname"),
      nicknameField,
      createLabel(for: "Phone number"),
      phoneNumberField,
      saveButton,
      errorLabel
    ]
    .toVerticalStackView()
    .spaced(Layout.Spacing.medium)
    .build()

    scrollView.addSubview(stack)
    stack.snp.makeConstraints { make in
      make.top.equalToSuperview().inset(Layout.Spacing.mediumBig)
      make.width.bottom.equalToSuperview().inset(Layout.Spacing.medium)
      make.centerX.equalToSuperview()
    }
  }
}

private extension CreateProfileView {

  func createLabel(for text: String) -> UILabel {
    let label = UILabel()
    label.text = text
    label.textAlignment = .center
    return label
  }
}
