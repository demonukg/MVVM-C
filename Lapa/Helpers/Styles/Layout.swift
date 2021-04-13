import UIKit

struct Layout {

  struct Spacing {

    /// 4 points
    static let smallest: CGFloat = 4

    /// 8 points
    static let small: CGFloat = 8

    /// 12 points
    static let mediumSmall: CGFloat = 12

    /// 16 points
    static let medium: CGFloat = 16

    /// 24 points
    static let mediumBig: CGFloat = 24

    /// 32 points
    static let big: CGFloat = 32

    /// 48 points
    static let mediumBiggest: CGFloat = 48

    /// 64 points
    static let biggest: CGFloat = 64
  }

  struct Tappable {

    /// 44 points
    static let minHeight: CGFloat = 44

    /// 44 points
    static let minWidth: CGFloat = 44
  }

  struct Content {

    static let widthPercent: CGFloat = 0.8 // Content width in percent relative to parent

    static let lineHeight = 1 / UIScreen.main.scale

    /// 5 points
    static let cornerRadius: CGFloat = 5

    /// 240 points
    static let minButtonWidth: CGFloat = 240

    /// 38 points
    static let headerHeight: CGFloat = 38
  }

  private init() { }
}
