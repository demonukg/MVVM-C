import RxSwift

final class CreateProfileViewModel: ViewModelTransform {

  struct Input {
    let name: Observable<String>
    let city: Observable<String>
    let nickname: Observable<String>
    let phoneNumber: Observable<String>
    let onSaveTap: Observable<Void>
  }

  struct Output {
    let isValid: Observable<Bool>
    let onFinish: Observable<Void>
    let loading: Observable<VMLoadingType>
    let errors: Observable<VMErrorType>
  }

  private let profileService: ProfileService

  init(profileService: ProfileService) {
    self.profileService = profileService
  }

  func transform(input: Input) -> Output {

    let onChange = Observable
      .merge(
        input.city,
        input.name,
        input.nickname,
        input.phoneNumber
      )

    let fields = Observable
      .combineLatest(
        input.city,
        input.name,
        input.nickname,
        input.phoneNumber
      )

    let isValid = input.onSaveTap
      .withLatestFrom(fields).map { !$0.0.isEmpty && !$0.1.isEmpty && !$0.2.isEmpty && !$0.3.isEmpty }

    let result = isValid
      .filter { $0 == true }
      .withLatestFrom(fields)
      .flatMap { self.profileService.createProfile(city: $0.0, name: $0.1, nickname: $0.2, phoneNumber: $0.3).asLoadingSequence() }
      .share()

    return Output(
      isValid: Observable.merge(isValid, onChange.map { _ in true } ),
      onFinish: result.element.asVoid(),
      loading: result.loading.asBlockingActivity(),
      errors: result.errors.asMessage()
    )
  }
}
