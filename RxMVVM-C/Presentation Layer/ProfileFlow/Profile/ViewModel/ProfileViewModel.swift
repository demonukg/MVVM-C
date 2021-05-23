import RxSwift

final class ProfileViewModel: ViewModelTransform {

  struct Input {
    let obtainData: Observable<Void>
  }

  struct Output {
    let data: Observable<[ConfigurableViewData]>
    let onEditTap: Observable<Profile>
    let loading: Observable<VMLoadingType>
    let errors: Observable<VMErrorType>
  }

  private let profileService: ProfileService

  init(profileService: ProfileService) {
    self.profileService = profileService
  }

  func transform(input: Input) -> Output {
    let onEditTapSubject = PublishSubject<Void>()

    let composer = ProfileViewDataComposer()

    composer.onEditTap = {
      onEditTapSubject.onNext(())
    }

    let profile = input.obtainData
      .flatMap { self.profileService.getProfile().asLoadingSequence() }
      .share()

    let onEdit = onEditTapSubject.withLatestFrom(profile.element)

    let viewData = profile.element.map { composer.makeViewDataArray(with: $0) }

    return Output(
      data: viewData,
      onEditTap: onEdit,
      loading: profile.loading.asBlockingActivity(),
      errors: profile.errors.asMessage()
    )
  }
}
