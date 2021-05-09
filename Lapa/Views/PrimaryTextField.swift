import UIKit

class PrimaryTextField: UITextField {

  override var intrinsicContentSize: CGSize {
    CGSize(width: super.intrinsicContentSize.width + Layout.Spacing.mediumBig * 2, height: Layout.Tappable.minHeight)
  }

  init() {
    super.init(frame: .zero)

    textAlignment = .center
    backgroundColor = .xF4F4F4
    layer.cornerRadius = Layout.Content.cornerRadius
    clipsToBounds = true
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

