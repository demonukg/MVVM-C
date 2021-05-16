import Swinject

struct ProfileCoordinatorAssembly: Assembly {

  struct Input {

    let action: ProfileModule.Input.ActionType
  }

  func assemble(container: Container) {
    container.register(ProfileCoordinator.self) { (resolver, parentAssembler: Assembler, input: Input) in
      let assembler = Assembler(
        [
          ProfileModuleAssembly(),
          CreateProfileModuleAssembly()
        ],
        parent: parentAssembler
      )
      let router = resolver.resolve(AppRouter.self)!
      return ProfileCoordinatorImpl(assembler: assembler, router: router, input: input)
    }
  }
}

