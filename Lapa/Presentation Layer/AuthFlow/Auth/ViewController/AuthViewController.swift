import UIKit
import RxSwift

final class AuthViewController: UIViewController, AuthModule, ViewHolder {

  typealias RootViewType = AuthView

  var onSuccessPhone: SingleActionBlock<String>?

  private let viewModel: AuthViewModel

  init(viewModel: AuthViewModel) {
    self.viewModel = viewModel

    super.init(nibName: nil, bundle: nil)
    title = "Authorization"
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func loadView() {
    view = AuthView()
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    let onEnterSubject = PublishSubject<String>()

    let output = viewModel.transform(input: .init(onEnterPhone: onEnterSubject))

    output.onSuccessPhone
      .subscribe(onNext: { [weak self] in
        self?.onSuccessPhone?($0)
      })
      .disposed(by: disposeBag)

    bindViewModelLoading(output.loading)
      .disposed(by: disposeBag)

    bindViewModelErrors(output.errors)
      .disposed(by: disposeBag)

    rootView.onEnterTap = {
      onEnterSubject.onNext($0)
    }
  }
}
