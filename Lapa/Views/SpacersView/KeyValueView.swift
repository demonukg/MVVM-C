import UIKit
import SnapKit

final class KeyValueView: UIView {

  private let keyLable: UILabel = {
    let label = UILabel()
    label.font = .regular14
    label.textColor = .lightGray
    return label
  }()

  private let valueLable: UILabel = {
    let label = UILabel()
    label.font = .regular16
    return label
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)

    setupInitialLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupInitialLayout() {
    let stack = [
      keyLable,
      valueLable
    ]
    .toVerticalStackView()
    .spaced(Layout.Spacing.smallest)
    .build()

    addSubview(stack)

    stack.snp.makeConstraints { make in
      make.top.bottom.equalToSuperview()
      make.leading.trailing.equalToSuperview().inset(Layout.Spacing.medium)
    }
  }
}

extension KeyValueView: ConfigurableView {

  struct ViewData: ConfigurableViewData, Equatable {
    var viewType: ConfigurableView.Type { KeyValueView.self }

    let keyText: String
    let valueText: String
  }

  func configure(with data: ConfigurableViewData) {
    guard let viewData = data as? ViewData else {
      return
    }

    keyLable.text = viewData.keyText
    valueLable.text = viewData.valueText
  }
}
