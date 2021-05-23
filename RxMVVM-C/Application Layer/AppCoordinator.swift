import Swinject

protocol AppCoordinator: Coordinatable {
  
}

final class AppCoordinatorImpl: BaseCoordinator, AppCoordinator {
  
  enum AppCoordinatorStep {
    
    case initial
    case auth
    case profile
    case main
  }
  
  private lazy var currentSteps = steps()

  private let authService: AuthenticationService
  
  init(
    assembler: Assembler,
    router: Routable,
    authService: AuthenticationService
  ) {
    self.authService = authService

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
    currentSteps = [.auth, .profile, .main]
    //authService.logout()
    //mainCoordinator = nil
    start()
  }
  
  func start() {
    startScenario(with: .initial)
  }
}

private extension AppCoordinatorImpl {

  private func steps() -> [AppCoordinatorStep] {
    var steps: [AppCoordinatorStep] = [.initial]

    if !authService.authenticated {
      steps.append(contentsOf: [.auth, .profile])
    }
    steps.append(.main)

    return steps
  }
  
  func startScenario(with step: AppCoordinatorStep) {
    switch step {
    case .auth:
      runAuthFlow(authType: .login)
    case .profile:
      let action: ProfileModule.Input.ActionType = authService.scopes.contains(.unregistered) ? .registration : .login
      runProfileFlow(action: action)
    case .main:
      break
    //runMainFlow(with: option)
    case .initial:
      showInitialLoadingModule()
    }
  }

  func startNextStep(afterStep: AppCoordinatorStep) {
    let nextSteps = currentSteps.filter { $0 != afterStep }
    guard let nextStep = nextSteps.first else { fatalError("Steps is over, your flow is bad") }
    currentSteps = nextSteps
    startScenario(with: nextStep)
  }

  func runProfileFlow(action: ProfileModule.Input.ActionType) {
    let coordinator = assembler.resolver.resolve(
      ProfileCoordinator.self,
      arguments: assembler,
      ProfileCoordinatorAssembly.Input(action: action)
    )!

    coordinator.onFinish = { [weak self, weak coordinator] in
      self?.removeDependency(coordinator)
      self?.startNextStep(afterStep: .auth)
    }
    addDependency(coordinator)
    coordinator.start()
  }
  
  func runAuthFlow(authType: AuthModule.Input.AuthType) {
    let input = AuthCoordinatorAssembly.Input(authType: authType)

    let coordinator = assembler.resolver.resolve(
      AuthCoordinator.self,
      arguments: assembler,
      input
    )!
    
    coordinator.onFinish = { [weak self, weak coordinator] in
      self?.removeDependency(coordinator)
      self?.startNextStep(afterStep: .auth)
    }
    addDependency(coordinator)
    coordinator.start()
  }

  func showInitialLoadingModule() {
    startNextStep(afterStep: .initial)
  }
}
