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
    showMainModule()
  }
}

private extension AuthCoordinatorImpl {

  func showMainModule() {
    let module = assembler.resolver.resolve(
      AuthModule.self,
      argument: AuthModule.Input(authType: .login)
    )!
    module.onFinish = {
      print("qwer onFinish")
    }
    router.setRootModule(module)
  }
}
