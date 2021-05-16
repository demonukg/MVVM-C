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
      createProfile()
    }
  }
}

private extension ProfileCoordinatorImpl {

  func showProfile() {
    let module = assembler.resolver.resolve(
      ProfileModule.self,
      argument: ProfileModule.Input()
    )!
    router.setRootModule(module)
  }

  func createProfile() {
    let module = assembler.resolver.resolve(
      CreateProfileModule.self,
      argument: CreateProfileModule.Input()
    )!

    module.onFinish = { [weak self] in
      self?.showProfile()
    }
    router.setRootModule(module)
  }
}
