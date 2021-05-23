import UIKit
import RxSwift

extension ViewHolder where Self: UIViewController {

  func bindViewModelErrors(
    _ errors: Observable<VMErrorType>,
    retryAction: EmptyActionBlock? = nil
  ) -> Disposable {
    errors.subscribe(onNext: { [unowned self] type in
      switch type {
      case .message(let error):
        self.showErrorInAlert(error)
      case .info(let error):
        self.rootView.showError(error) { [unowned self] in
          self.rootView.hideError()
          retryAction?()
        }
      }
    })
  }
}
