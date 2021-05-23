import Swinject

struct AuthenticationServiceAssembly: Assembly {

  private let mocked: Bool = false

  func assemble(container: Container) {
    container.register(AuthenticationService.self) { resolver in
      let apiService = resolver.resolve(ApiService.self)!
      return AuthenticationServiceImpl(apiService: apiService)
    }.inObjectScope(.container)
  }
}
