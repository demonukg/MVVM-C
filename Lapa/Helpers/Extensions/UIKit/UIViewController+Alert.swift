import UIKit

extension UIViewController {

  func showErrorInAlert(_ error: Error, title: String = AlertTitles.errorTitle) {
    let controller = UIAlertController(
      title: title,
      message: error.localizedDescription,
      preferredStyle: .alert
    )
    let action = UIAlertAction(title: AlertTitles.errorDismiss, style: .cancel) { _ in
      controller.dismiss(animated: true, completion: nil)
    }
    controller.addAction(action)

    present(controller, animated: true, completion: nil)
  }
}

struct AlertTitles {
  static let errorTitle = "Error"
  static let errorDismiss = "Dismiss"
}
