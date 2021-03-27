import Swinject

protocol AppCoordinator: Coordinatable {
  
}

final class AppCoordinatorImpl: BaseCoordinator, AppCoordinator {
  
  enum AppCoordinatorStep {
    
    case auth
    case main
  }
  
  private lazy var currentSteps: [AppCoordinatorStep] = [.auth, .main]
  
  //private var mainCoordinator: MainCoordinator?
  
  override init(
    assembler: Assembler,
    router: Routable
  ) {
    super.init(assembler: assembler, router: router)

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(logout),
      name: .forceLogoutNotificationName,
      object: nil
    )
  }
  
  @objc
  private func logout() {
    currentSteps = [.auth, .main]
    //authService.logout()
    //mainCoordinator = nil
    start()
  }
  
  func start() {
    startScenario(with: .auth)
  }
}

private extension AppCoordinatorImpl {
  
  func startScenario(with step: AppCoordinatorStep) {
    switch step {
    case .auth:
      runAuthFlow(authType: .login)
    case .main:
      break
      //runMainFlow(with: option)
    }
  }
  
  func runAuthFlow(
    authType: AuthModule.Input.AuthType
  ) {
    let input = AuthCoordinatorAssembly.Input(authType: authType)

    let coordinator = assembler.resolver.resolve(
      AuthCoordinator.self,
      arguments: assembler,
      input
    )!
    
    coordinator.onFinish = { [weak self, weak coordinator] in
      self?.removeDependency(coordinator)
      //self?.runMainFlow(with: option)
    }
    addDependency(coordinator)
    coordinator.start()
  }
}
