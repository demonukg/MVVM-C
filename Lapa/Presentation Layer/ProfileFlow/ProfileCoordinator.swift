import Swinject

protocol ProfileCoordinator: Coordinatable {

  var onFinish: EmptyActionBlock? { get set }
}

final class ProfileCoordinatorImpl: BaseCoordinator, ProfileCoordinator {

  var onFinish: EmptyActionBlock?

  private let input: ProfileCoordinatorAssembly.Input

  init(
    assembler: Assembler,
    router: Routable,
    input: ProfileCoordinatorAssembly.Input
  ) {
    self.input = input
    
    super.init(assembler: assembler, router: router)
  }

  func start() {
    switch input.action {
    case .login:
      showProfile()
    case .registration:
      createProfile(input: .init(currentAction: .create, profile: nil))
    }
  }
}

private extension ProfileCoordinatorImpl {

  func showProfile() {
    let module = assembler.resolver.resolve(
      ProfileModule.self,
      argument: ProfileModule.Input()
    )!

    module.onEditProfile = { [weak self] in
      self?.createProfile(input: .init(currentAction: .update, profile: $0))
    }

    router.setRootModule(module)
  }

  func createProfile(input: CreateProfileModule.Input) {
    let module = assembler.resolver.resolve(
      CreateProfileModule.self,
      argument: input
    )!

    module.onFinish = { [weak self, weak router] in
      switch input.currentAction {
      case .create:
        self?.showProfile()
      case .update:
        router?.popModule()
      }
    }

    switch input.currentAction {
    case .create:
      router.setRootModule(module)
    case .update:
      router.push(module)
    }
  }
}
