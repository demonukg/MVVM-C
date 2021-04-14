import RxSwift

final class AuthViewModel: ViewModelTransform {

  struct Input {
    let onEnterPhone: Observable<String>
  }

  struct Output {
    let onSuccessPhone: Observable<String>
    let loading: Observable<VMLoadingType>
    let errors: Observable<VMErrorType>
  }

  private let authService: AuthenticationService

  init(authService: AuthenticationService) {
    self.authService = authService
  }

  func transform(input: Input) -> Output {
    let enterResult = input.onEnterPhone
      .flatMap { self.authService.login($0).asLoadingSequence() }
      .share()

    let onSuccessPhone = enterResult.element.withLatestFrom(input.onEnterPhone)

    return Output(
      onSuccessPhone: onSuccessPhone,
      loading: enterResult.loading.asBlockingActivity(),
      errors: enterResult.errors.asMessage()
    )
  }
}
