import RxSwift

final class ValidationViewModel: ViewModelTransform {

  struct Input {
    let onEnterPin: Observable<String>
  }

  struct Output {
    let onSuccess: Observable<Void>
    let loading: Observable<VMLoadingType>
    let errors: Observable<VMErrorType>
  }

  private let authService: AuthenticationService
  private let phoneNumber: String

  init(
    authService: AuthenticationService,
    phoneNumber: String
  ) {
    self.authService = authService
    self.phoneNumber = phoneNumber
  }

  func transform(input: Input) -> Output {
    let validationResult = input.onEnterPin
      .flatMap { self.authService.validate(login: self.phoneNumber, password: $0).asLoadingSequence() }
      .share()

    return Output(
      onSuccess: validationResult.element.asVoid(),
      loading: validationResult.loading.asBlockingActivity(),
      errors: validationResult.errors.asMessage()
    )
  }
}
