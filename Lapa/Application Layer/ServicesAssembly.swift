import Swinject

struct ServicesAssembly: Assembly {

  func assemble(container: Container) {
    ApiServicesAssembly().assemble(container: container)
    AuthenticationServiceAssembly().assemble(container: container)
  }
}
