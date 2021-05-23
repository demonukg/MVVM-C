import Swinject

class BaseCoordinator {
    
  private(set) var childCoordinators: [Coordinatable] = []
  
  let router: Routable
  let assembler: Assembler

  init(
    assembler: Assembler,
    router: Routable
  ) {
    self.assembler = assembler
    self.router = router
  }
  
  func addDependency(_ coordinator: Coordinatable) {
    guard !childCoordinators.contains(where: { $0 === coordinator }) else { return }
    
    childCoordinators.append(coordinator)
  }
  
  func removeDependency(_ coordinator: Coordinatable?) {
    childCoordinators.removeAll(where: { $0 === coordinator })
  }
  
  func removeAllDependencies() {
    childCoordinators.removeAll()
  }
}
