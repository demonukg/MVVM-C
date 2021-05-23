import Swinject

struct ProfileServiceAssembly: Assembly {

  private let mocked: Bool = false

  func assemble(container: Container) {
    container.register(ProfileService.self) { resolver in
      let apiService = resolver.resolve(ApiService.self)!
      return ProfileServiceImpl(apiService: apiService)
    }.inObjectScope(.container)
  }
}
