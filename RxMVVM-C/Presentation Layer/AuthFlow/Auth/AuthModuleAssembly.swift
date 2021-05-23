import Swinject

struct AuthModuleAssembly: Assembly {

  func assemble(container: Container) {
    container.register(AuthModule.self) { (resolver, _: AuthModule.Input) in
      let authService = resolver.resolve(AuthenticationService.self)!
      let viewModel = AuthViewModel(authService: authService)
      let controller = AuthViewController(viewModel: viewModel)
      return controller
    }
  }
}
