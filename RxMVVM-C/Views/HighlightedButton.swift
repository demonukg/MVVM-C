import UIKit

class HighlightedButton: UIButton {

  private var cornerRadius: CGFloat {
    if hasRoundCorners {
      return bounds.height * 0.5
    } else {
      return 0
    }
  }

  var normalColor: UIColor? = .white {
    didSet {
      if highlightColor == nil {
        highlightColor = normalColor?.brighter(-0.1)
      }
      updateBackgroundColor()
    }
  }

  var hasRoundCorners = true

  var highlightColor: UIColor? = nil {
    didSet {
      updateBackgroundColor()
    }
  }

  override var isHighlighted: Bool {
    didSet {
      updateBackgroundColor()
    }
  }

  var disabledColor: UIColor? = .lightGray {
    didSet {
      updateBackgroundColor()
    }
  }

  override var isEnabled: Bool {
    didSet {
      updateBackgroundColor()
    }
  }

  var shadowOffset: CGSize = .zero {
    didSet {
      updateShadow()
    }
  }

  var shadowOpacity: Float = 0 {
    didSet {
      updateShadow()
    }
  }

  var shadowColor: UIColor = .clear {
    didSet {
      updateShadow()
    }
  }

  var shadowRadius: CGFloat = 0 {
    didSet {
      updateShadow()
    }
  }

  var borderWidth: CGFloat = 0 {
    didSet {
      updateBorder()
    }
  }

  var borderColor: UIColor = .clear {
    didSet {
      updateBorder()
    }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)

    contentEdgeInsets = UIEdgeInsets(
      top: Layout.Spacing.small,
      left: Layout.Spacing.medium,
      bottom: Layout.Spacing.small,
      right: Layout.Spacing.medium
    )
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func sizeThatFits(_ size: CGSize) -> CGSize {
    return CGSize(width: size.width, height: Layout.Tappable.minHeight)
  }

  private func updateBackgroundColor() {
    let color = isEnabled ? normalColor : disabledColor
    clipLayer?.fillColor = (isHighlighted ? highlightColor : color)?.cgColor
  }

  private func updateShadow() {
    clipLayer?.shadowOffset = shadowOffset
    clipLayer?.shadowOpacity = shadowOpacity
    clipLayer?.shadowColor = shadowColor.cgColor
    clipLayer?.shadowRadius = shadowRadius
  }

  private func updateBorder() {
    clipLayer?.strokeColor = borderColor.cgColor
    clipLayer?.lineWidth = borderWidth
  }

  // MARK: Layout

  private var clipLayer: CAShapeLayer!

  private func clipBorders() {
    clipLayer?.removeFromSuperlayer()
    clipLayer = CAShapeLayer()
    clipLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
    clipLayer.backgroundColor = UIColor.white.cgColor
    updateBackgroundColor()
    updateShadow()
    updateBorder()
    layer.insertSublayer(clipLayer, at: 0)
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    clipBorders()
  }
}
