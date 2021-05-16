import UIKit
import SnapKit

class StackScrollView: UIScrollView {

  let stackView: UIStackView = {
    let view = UIStackView()
    view.axis = .vertical
    return view
  }()

  init() {
    super.init(frame: .zero)

    setupInitialLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupInitialLayout() {
    addSubview(stackView)
    stackView.snp.makeConstraints { make in
      make.edges.width.equalToSuperview()
    }
  }

  func configure(viewDatas: [ConfigurableViewData]) {
    stackView.arrangedSubviews.forEach {
      $0.removeFromSuperview()
    }
    viewDatas.forEach {
      let view = $0.viewType.init()
      view.configure(with: $0)
      stackView.addArrangedSubview(view)
    }
  }
}
