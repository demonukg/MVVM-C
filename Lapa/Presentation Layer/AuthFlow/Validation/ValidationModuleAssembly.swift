import Swinject

struct ValidationModuleAssembly: Assembly {

  func assemble(container: Container) {
    container.register(ValidationModule.self) { (resolver, input: ValidationModule.Input) in
      let authService = resolver.resolve(AuthenticationService.self)!
      let viewModel = ValidationViewModel(
        authService: authService,
        phoneNumber: input.phoneNumber
      )
      let controller = ValidationViewController(viewModel: viewModel)
      return controller
    }
  }
}
