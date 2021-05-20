import UIKit
import SnapKit

final class VerticalSpacerView: UIView {

  private var spacerHeightConstraint: Constraint?
  private let spacerView = UIView()

  override init(frame: CGRect) {
    super.init(frame: frame)

    setupInitialLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupInitialLayout() {
    addSubview(spacerView)
    spacerView.snp.makeConstraints { make in
      spacerHeightConstraint = make.height.equalTo(Layout.Spacing.mediumBig).constraint
      make.edges.equalToSuperview()
    }
  }
}

extension VerticalSpacerView: ConfigurableView {

  struct ViewData: ConfigurableViewData {
    var viewType: ConfigurableView.Type { VerticalSpacerView.self }

    let color: UIColor?
    let height: CGFloat

    init(
      color: UIColor? = .clear,
      height: CGFloat = Layout.Spacing.mediumBig
    ) {
      self.color = color
      self.height = height
    }
  }

  func configure(with data: ConfigurableViewData) {
    guard let viewData = data as? ViewData else {
      return
    }

    spacerHeightConstraint?.update(offset: viewData.height)
    spacerView.backgroundColor = viewData.color
  }
}
