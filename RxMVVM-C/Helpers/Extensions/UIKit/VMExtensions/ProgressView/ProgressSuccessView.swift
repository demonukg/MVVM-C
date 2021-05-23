import UIKit

final class ProgressSuccessView: UIView {

  var animationDuration: CFTimeInterval {
    return 0.3
  }

  override var intrinsicContentSize: CGSize {
    return CGSize(width: 100, height: 100)
  }

  private let pathLayer = CAShapeLayer()

  override init(frame: CGRect) {
    super.init(frame: frame)

    let successPath = UIBezierPath()
    let sizeForAnimation = intrinsicContentSize
    successPath.move(to: CGPoint(x: sizeForAnimation.width * 0.3, y: sizeForAnimation.height * 0.6))
    successPath.addLine(to: CGPoint(x: sizeForAnimation.width * 0.4, y: sizeForAnimation.height * 0.7))
    successPath.addLine(to: CGPoint(x: sizeForAnimation.width * 0.7, y: sizeForAnimation.height * 0.3))
    pathLayer.path = successPath.cgPath
    pathLayer.strokeColor = UIColor.red.cgColor
    pathLayer.fillColor = UIColor.clear.cgColor
    pathLayer.lineCap = CAShapeLayerLineCap.round
    pathLayer.lineWidth = 5.0
    layer.addSublayer(pathLayer)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func showSuccessAnimated(completion: @escaping () -> Void) {
    let pathAnimation = CABasicAnimation(keyPath: "strokeEnd")
    pathAnimation.fromValue = 0.0
    pathAnimation.toValue = 1.0
    pathAnimation.duration = animationDuration
    pathAnimation.fillMode = CAMediaTimingFillMode.forwards
    pathLayer.add(pathAnimation, forKey: "path")
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + animationDuration) {
      completion()
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    pathLayer.frame = layer.bounds
  }
}
