import Swinject

struct AppCoordinatorAssembly: Assembly {

  func assemble(container: Container) {
    container.register(AppCoordinator.self) { (resolver, parentAssembler: Assembler) in
      let assembler = Assembler(
        [
          AuthCoordinatorAssembly(),
          MainCoordinatorAssembly()
        ],
        parent: parentAssembler
      )
      let router = resolver.resolve(AppRouter.self)!
      let authService = resolver.resolve(AuthenticationService.self)!
      let coordinator = AppCoordinatorImpl(
        assembler: assembler,
        router: router,
        authService: authService
      )
      return coordinator
    }
  }
}
