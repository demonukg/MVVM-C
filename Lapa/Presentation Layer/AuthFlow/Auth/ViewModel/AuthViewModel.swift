import RxSwift

final class AuthViewModel: ViewModelTransform {

  struct Input {
    let onEnter: Observable<String>
  }

  struct Output {
    let onSuccess: Observable<Void>
    let loading: Observable<VMLoadingType>
    let errors: Observable<VMErrorType>
  }

  private let authService: AuthenticationService

  init(authService: AuthenticationService) {
    self.authService = authService
  }

  func transform(input: Input) -> Output {
    let enterResult = input.onEnter
      .flatMap { self.authService.login($0).asLoadingSequence() }
      .share()

    return Output(
      onSuccess: enterResult.element,
      loading: enterResult.loading.asBlockingActivity(),
      errors: enterResult.errors.asMessage()
    )
  }
}
