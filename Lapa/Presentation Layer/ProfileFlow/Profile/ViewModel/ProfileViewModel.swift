import RxSwift

final class ProfileViewModel: ViewModelTransform {

  struct Input {
    let obtainData: Observable<Void>
  }

  struct Output {
    let data: Observable<[ConfigurableViewData]>
    let loading: Observable<VMLoadingType>
    let errors: Observable<VMErrorType>
  }

  private let profileService: ProfileService

  init(profileService: ProfileService) {
    self.profileService = profileService
  }

  func transform(input: Input) -> Output {
    let composer = ProfileViewDataComposer()

    let profile = input.obtainData
      .flatMap { self.profileService.getProfile().asLoadingSequence() }
      .share()

    let viewData = profile.element.map { composer.makeViewDataArray(with: $0) }

    return Output(
      data: viewData,
      loading: profile.loading.asBlockingActivity(),
      errors: profile.errors.asMessage()
    )
  }
}
