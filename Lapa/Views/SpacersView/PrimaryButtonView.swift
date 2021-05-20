import UIKit
import SnapKit

final class PrimaryButtonView: UIView {

  private var onTap: EmptyActionBlock?

  private let button: UIButton = {
    let button = PrimaryButton()
    button.addTarget(self, action: #selector(buttonTap), for: .touchUpInside)
    return button
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)

    setupInitialLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupInitialLayout() {
    addSubview(button)

    button.snp.makeConstraints { make in
      make.top.bottom.equalToSuperview()
      make.leading.trailing.equalToSuperview().inset(Layout.Spacing.medium)
    }
  }
}

private extension PrimaryButtonView {

  @objc func buttonTap() {
    onTap?()
  }
}

extension PrimaryButtonView: ConfigurableView {

  struct ViewData: ConfigurableViewData {
    var viewType: ConfigurableView.Type { PrimaryButtonView.self }

    let buttonTitle: String
    let onTap: EmptyActionBlock?
  }

  func configure(with data: ConfigurableViewData) {
    guard let viewData = data as? ViewData else {
      return
    }
    button.setTitle(viewData.buttonTitle, for: .normal)
    onTap = {
      viewData.onTap?()
    }
  }
}

