import Swinject

struct CreateProfileModuleAssembly: Assembly {

  func assemble(container: Container) {
    container.register(CreateProfileModule.self) { (resolver, _: CreateProfileModule.Input) in
      let service = resolver.resolve(ProfileService.self)!
      let viewModel = CreateProfileViewModel(profileService: service)
      let controller = CreateProfileViewController(viewModel: viewModel)
      return controller
    }
  }
}
