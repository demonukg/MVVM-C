import UIKit

protocol ConfigurableViewData {
  
  var viewType: ConfigurableView.Type { get }
}

protocol ConfigurableView: UIView {

  func configure(with data: ConfigurableViewData)
}
