import Swinject

struct AuthCoordinatorAssembly: Assembly {
  
  struct Input {
    let authType: AuthModule.Input.AuthType
  }

  func assemble(container: Container) {
    container.register(AuthCoordinator.self) { (resolver, parentAssembler: Assembler, input: Input) in
      let assembler = Assembler(
        [
        ],
        parent: parentAssembler
      )
      let router = resolver.resolve(AppRouter.self)!
      return AuthCoordinatorImpl(assembler: assembler, router: router, input: input)
    }
  }
}
