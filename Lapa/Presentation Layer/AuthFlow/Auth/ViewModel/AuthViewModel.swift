import RxSwift

final class AuthViewModel: ViewModelTransform {

  struct Input {
    let onEnterPhone: Observable<String>
    let onPhoneChanged: Observable<String>
  }

  struct Output {
    let onSuccessPhone: Observable<String>
    let onIsValidChanged: Observable<Bool>
    let loading: Observable<VMLoadingType>
    let errors: Observable<VMErrorType>
  }

  private let authService: AuthenticationService

  init(authService: AuthenticationService) {
    self.authService = authService
  }

  func transform(input: Input) -> Output {

    let isValid = input.onEnterPhone
      .map { number -> Bool in
        let regEx = "^\\+(?:[0-9]?){6,14}[0-9]$"
        let phoneCheck = NSPredicate(format: "SELF MATCHES[c] %@", regEx)
        return phoneCheck.evaluate(with: number)
      }

    let phoneIsInvalid = isValid
      .filter { !$0 }
      .map { $0 }

    let enterResult = isValid
      .filter { $0 }
      .withLatestFrom(input.onEnterPhone)
      .flatMap { self.authService.login($0).asLoadingSequence() }
      .share()

    let onSuccessPhone = enterResult.element.withLatestFrom(input.onEnterPhone)

    let onIsValidChanged = Observable.merge(phoneIsInvalid, input.onPhoneChanged.map { _ in true })
    
    return Output(
      onSuccessPhone: onSuccessPhone,
      onIsValidChanged: onIsValidChanged.distinctUntilChanged(),
      loading: enterResult.loading.asBlockingActivity(),
      errors: enterResult.errors.asMessage()
    )
  }
}
