import Swinject

struct ProfileModuleAssembly: Assembly {

  func assemble(container: Container) {
    container.register(ProfileModule.self) { (resolver, _: ProfileModule.Input) in
      let service = resolver.resolve(ProfileService.self)!
      let viewModel = ProfileViewModel(profileService: service)
      let controller = ProfileViewController(viewModel: viewModel)
      return controller
    }
  }
}
