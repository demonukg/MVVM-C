import UIKit
import RxSwift

final class ValidationViewController: UIViewController, ValidationModule, ViewHolder {

  typealias RootViewType = ValidationView

  var onFinish: EmptyActionBlock?

  private let viewModel: ValidationViewModel

  init(viewModel: ValidationViewModel) {
    self.viewModel = viewModel

    super.init(nibName: nil, bundle: nil)
    title = "Validation"
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func loadView() {
    view = ValidationView()
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    let onEnterPinSubject = PublishSubject<String>()

    let output = viewModel.transform(input: .init(onEnterPin: onEnterPinSubject))

    output.onSuccess
      .subscribe(onNext: { [weak self] in
        self?.onFinish?()
      })
      .disposed(by: disposeBag)

    rootView.onEnterTap = {
      onEnterPinSubject.onNext($0)
    }

    bindViewModelLoading(output.loading)
      .disposed(by: disposeBag)

    bindViewModelErrors(output.errors)
      .disposed(by: disposeBag)
  }
}
