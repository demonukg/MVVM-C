import UIKit
import RxSwift

final class AuthViewController: UIViewController, AuthModule, ViewHolder {

  typealias RootViewType = AuthView

  var onFinish: EmptyActionBlock?

  private let viewModel: AuthViewModel

  init(viewModel: AuthViewModel) {
    self.viewModel = viewModel

    super.init(nibName: nil, bundle: nil)
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

    let output = viewModel.transform(input: .init(onEnter: onEnterSubject))

    output.onSuccess
      .subscribe(onNext: { [weak self] in
        self?.onFinish?()
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
