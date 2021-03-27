//import UIKit
//import RxSwift
//
//final class AuthViewController: UIViewController, AuthModule, ViewHolder {
//
//  typealias RootViewType = AuthView
//
//  private let viewModel: AuthViewModel
//  private let disposeBag = DisposeBag()
//
//  init(viewModel: AuthViewModel) {
//    self.viewModel = viewModel
//
//    super.init(nibName: nil, bundle: nil)
//  }
//
//  required init?(coder: NSCoder) {
//    fatalError("init(coder:) has not been implemented")
//  }
//
//  override func loadView() {
//    view = AuthView()
//  }
//
//  override func viewDidLoad() {
//    super.viewDidLoad()
//
//    let obtainData = PublishSubject<Void>()
//
//    let output = viewModel.transform(input: .init(obtainData: obtainData))
//
//    // TODO: Implement binding with AuthViewModel
//
//    bindViewModelLoading(output.loading)
//      .disposed(by: disposeBag)
//
//    bindViewModelErrors(
//      output.errors,
//      retryAction: { obtainData.onNext(()) }
//    )
//    .disposed(by: disposeBag)
//  }
//}
//
//extension AuthViewController: ScreenTrackable {
//
//  // TODO: Fix temporary name on real
//  var screenName: ScreenName {
//    "Auth"
//  }
//}
