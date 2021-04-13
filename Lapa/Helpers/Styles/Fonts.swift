import UIKit

extension UIFont {

  static var regular12: UIFont { regular(12) }
  static var regular14: UIFont { regular(14) }
  static var regular16: UIFont { regular(16) }
  static var regular18: UIFont { regular(18) }
  static var regular20: UIFont { regular(20) }
  static var regular22: UIFont { regular(22) }
  static var regular24: UIFont { regular(24) }
  static var regular38: UIFont { regular(38) }

  static var semibold12: UIFont { semibold(12) }
  static var semibold14: UIFont { semibold(14) }
  static var semibold16: UIFont { semibold(16) }
  static var semibold18: UIFont { semibold(18) }
  static var semibold20: UIFont { semibold(20) }
  static var semibold22: UIFont { semibold(22) }

  static var medium14: UIFont { medium(14) }

  static var bold12: UIFont { bold(12) }
  static var bold14: UIFont { bold(14) }
  static var bold16: UIFont { bold(16) }
  static var bold18: UIFont { bold(18) }
  static var bold20: UIFont { bold(20) }
  static var bold22: UIFont { bold(22) }
  static var bold24: UIFont { bold(24) }
  static var bold32: UIFont { bold(32) }
  static var bold42: UIFont { bold(42) }

  private static func regular(_ size: CGFloat) -> UIFont {
    return systemFont(ofSize: size, weight: .regular)
  }

  private static func medium(_ size: CGFloat) -> UIFont {
    return systemFont(ofSize: size, weight: .medium)
  }

  private static func bold(_ size: CGFloat) -> UIFont {
    return systemFont(ofSize: size, weight: .bold)
  }

  private static func light(_ size: CGFloat) -> UIFont {
    return systemFont(ofSize: size, weight: .light)
  }

  private static func semibold(_ size: CGFloat) -> UIFont {
    return systemFont(ofSize: size, weight: .semibold)
  }
}
