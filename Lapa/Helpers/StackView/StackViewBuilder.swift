import UIKit

final class StackViewBuilder {

  private var stackView = UIStackView()

  func with(subviews: [UIView]) -> StackViewBuilder {
    stackView = UIStackView(arrangedSubviews: subviews)
    return self
  }

  func vertical() -> StackViewBuilder {
    stackView.axis = .vertical
    return self
  }

  func horizontal() -> StackViewBuilder {
    stackView.axis = .horizontal
    return self
  }

  func spaced(_ spacing: CGFloat) -> StackViewBuilder {
    stackView.spacing = spacing
    return self
  }

  func with(alignment: UIStackView.Alignment) -> StackViewBuilder {
    stackView.alignment = alignment
    return self
  }

  func with(distribution: UIStackView.Distribution) -> StackViewBuilder {
    stackView.distribution = distribution
    return self
  }

  func with(spacing: CGFloat, after view: UIView) -> StackViewBuilder {
    if #available(iOS 11.0, *) {
      stackView.setCustomSpacing(spacing, after: view)
    } else {
      // TODO: implement custom solution
    }
    return self
  }

  func build() -> UIStackView {
    stackView
  }
}

extension Array where Element: UIView {

  func toHorizontalStackView() -> StackViewBuilder {
    StackViewBuilder().with(subviews: self)
  }

  func toVerticalStackView() -> StackViewBuilder {
    StackViewBuilder().with(subviews: self)
      .vertical()
  }
}
