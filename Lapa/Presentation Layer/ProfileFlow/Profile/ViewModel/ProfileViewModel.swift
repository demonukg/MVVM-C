import RxSwift

final class ProfileViewModel: ViewModelTransform {

  struct Input {
    let obtainData: Observable<Void>
  }

  struct Output {
    let profile: Observable<Profile>
    let loading: Observable<VMLoadingType>
    let errors: Observable<VMErrorType>
  }

  private let profileService: ProfileService

  init(profileService: ProfileService) {
    self.profileService = profileService
  }

  func transform(input: Input) -> Output {
    let profile = input.obtainData
      .flatMap { self.profileService.getProfile().asLoadingSequence() }.share()

    return Output(
      profile: profile.element,
      loading: profile.loading.asBlockingActivity(),
      errors: profile.errors.asMessage()
    )
  }
}
