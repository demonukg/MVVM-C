import UIKit

extension UIColor {

  static let x38CCCC = UIColor(hex: 0x38CCCC)
}

// MARK: Hex colors

extension UIColor {

  convenience init(hex: UInt32) {
    self.init(
      red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
      green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
      blue: CGFloat(hex & 0x0000FF) / 255.0,
      alpha: CGFloat(1.0)
    )
  }
}

// MARK: Brighter

extension UIColor {

  func brighter(_ val: CGFloat) -> UIColor {
    var h: CGFloat = 0.0, s: CGFloat = 0.0, b: CGFloat = 0.0, a: CGFloat = 0.0
    getHue(&h, saturation: &s, brightness: &b, alpha: &a)
    return UIColor(hue: h, saturation: s, brightness: max(0.0, min(b + val, 1.0)), alpha: a)
  }
}
