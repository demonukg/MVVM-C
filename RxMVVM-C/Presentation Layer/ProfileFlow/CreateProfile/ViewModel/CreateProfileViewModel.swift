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
  private let currentAction: CreateProfileModuleInput.ActionType
  let profile: Profile?

  init(
    profileService: ProfileService,
    input: CreateProfileModule.Input
  ) {
    self.profileService = profileService
    currentAction = input.currentAction
    profile = input.profile
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

    let createResult = isValid
      .filter { $0 == true }
      .filter { _ in self.currentAction == .create }
      .withLatestFrom(fields)
      .flatMap { self.profileService.createProfile(city: $0.0, name: $0.1, nickname: $0.2, phoneNumber: $0.3).asLoadingSequence() }
      .share()

    let updateResult = isValid
      .filter { $0 == true }
      .filter { _ in self.currentAction == .update }
      .withLatestFrom(fields)
      .flatMap { self.profileService.updateProfile(city: $0.0, name: $0.1, nickname: $0.2, phoneNumber: $0.3).asLoadingSequence() }
      .share()

    let error = Observable.merge(
      createResult.errors.asMessage(),
      updateResult.errors.asMessage()
    )

    let loading = Observable.merge(
      createResult.loading.asBlockingActivity(),
      updateResult.loading.asBlockingActivity()
    )

    let result = Observable.merge(
      createResult.element.asVoid(),
      updateResult.element.asVoid()
    )

    return Output(
      isValid: Observable.merge(isValid, onChange.map { _ in true } ),
      onFinish: result,
      loading: loading,
      errors: error
    )
  }
}
