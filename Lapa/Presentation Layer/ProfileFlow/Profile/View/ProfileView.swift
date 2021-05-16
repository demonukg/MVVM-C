import UIKit
import SnapKit

final class ProfileView: UIView {

  // MARK: - Properties

  let stackScrollView = StackScrollView()

  // MARK: - Initialization

  public init() {
    super.init(frame: .zero)
    backgroundColor = .white
    setupInitialLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupInitialLayout() {
    addSubview(stackScrollView)
    
    stackScrollView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
}
