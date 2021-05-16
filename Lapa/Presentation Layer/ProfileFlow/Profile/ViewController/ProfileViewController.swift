import UIKit
import RxSwift

final class ProfileViewController: UIViewController, ProfileModule, ViewHolder {

  typealias RootViewType = ProfileView

  private let viewModel: ProfileViewModel

  init(viewModel: ProfileViewModel) {
    self.viewModel = viewModel

    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func loadView() {
    view = ProfileView()
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    let obtainData = PublishSubject<Void>()

    let output = viewModel.transform(input: .init(obtainData: obtainData))

    output.profile
      .subscribe(onNext: { profile in
        print("\(profile)")
      })
      .disposed(by: disposeBag)

    bindViewModelLoading(output.loading)
      .disposed(by: disposeBag)

    bindViewModelErrors(
      output.errors,
      retryAction: { obtainData.onNext(()) }
    )
    .disposed(by: disposeBag)

    obtainData.onNext(())
  }
}
