import Swinject

struct CreateProfileModuleAssembly: Assembly {

  func assemble(container: Container) {
    container.register(CreateProfileModule.self) { (resolver, input: CreateProfileModule.Input) in
      let service = resolver.resolve(ProfileService.self)!
      let viewModel = CreateProfileViewModel(profileService: service, input: input)
      let controller = CreateProfileViewController(viewModel: viewModel)
      return controller
    }
  }
}
