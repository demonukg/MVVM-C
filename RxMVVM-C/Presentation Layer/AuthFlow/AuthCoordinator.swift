import Swinject

protocol AuthCoordinator: Coordinatable {
  
  var onFinish: EmptyActionBlock? { get set }
}

final class AuthCoordinatorImpl: BaseCoordinator, AuthCoordinator {
  
  var onFinish: EmptyActionBlock?

  init(
    assembler: Assembler,
    router: Routable,
    input: AuthCoordinatorAssembly.Input
  ) {
    super.init(assembler: assembler, router: router)
  }

  func start() {
    showAuthModule()
  }
}

private extension AuthCoordinatorImpl {

  func showAuthModule() {
    let module = assembler.resolver.resolve(
      AuthModule.self,
      argument: AuthModule.Input(authType: .login)
    )!
    module.onSuccessPhone = { [weak self] in
      self?.showValidationModule(for: $0)
    }
    router.setRootModule(module)
  }

  func showValidationModule(for phoneNumber: String) {
    let module = assembler.resolver.resolve(
      ValidationModule.self,
      argument: ValidationModule.Input(phoneNumber: phoneNumber)
    )!

    module.onFinish = { [weak self] in
      self?.onFinish?()
    }
    router.push(module)
  }
}
