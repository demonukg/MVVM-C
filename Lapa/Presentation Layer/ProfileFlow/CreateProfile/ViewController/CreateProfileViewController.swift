import UIKit
import RxSwift

final class CreateProfileViewController: UIViewController, CreateProfileModule, ViewHolder {

  typealias RootViewType = CreateProfileView

  var onFinish: EmptyActionBlock?

  private let viewModel: CreateProfileViewModel

  init(viewModel: CreateProfileViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    
    title = "Create profile"
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func loadView() {
    view = CreateProfileView()
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    let output = viewModel.transform(
      input: .init(
        name: rootView.nameField.rx.text.orEmpty.asObservable(),
        city: rootView.cityField.rx.text.orEmpty.asObservable(),
        nickname: rootView.nicknameField.rx.text.orEmpty.asObservable(),
        phoneNumber: rootView.phoneNumberField.rx.text.orEmpty.asObservable(),
        onSaveTap: rootView.saveButton.rx.tap.asObservable()
      )
    )

    output.isValid
      .bind(to: rootView.errorLabel.rx.isHidden)
      .disposed(by: disposeBag)

    output.onFinish
      .subscribe(onNext: { [weak self] in
        self?.onFinish?()
      })
      .disposed(by: disposeBag)

    bindViewModelLoading(output.loading)
      .disposed(by: disposeBag)

    bindViewModelErrors(output.errors)
      .disposed(by: disposeBag)
  }
}
