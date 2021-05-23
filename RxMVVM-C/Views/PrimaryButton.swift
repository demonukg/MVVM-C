import UIKit

class PrimaryButton: HighlightedButton {

  override var intrinsicContentSize: CGSize {
    return CGSize(width: super.intrinsicContentSize.width, height: Layout.Tappable.minHeight)
  }

  init() {
    super.init(frame: .zero)

    normalColor = .x38CCCC
    disabledColor = .gray

    titleLabel?.font = .regular16
    titleLabel?.lineBreakMode = .byWordWrapping
    titleLabel?.textAlignment = .center
    setTitleColor(.white, for: .normal)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
