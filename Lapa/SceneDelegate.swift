import UIKit
import Swinject

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?
  
  private lazy var coordinator = makeAppCoordinator()
  
  private let rootContainer = Container()

  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    
    let window = UIWindow(windowScene: windowScene)
    window.makeKeyAndVisible()
    self.window = window
    coordinator.start()
  }
}

private extension SceneDelegate {
  
  func makeAppCoordinator() -> Coordinatable {
    let navController = UINavigationController()
    window?.rootViewController = navController
    rootContainer.register(AppRouter.self) { _ in
      AppRouterImpl(rootController: navController)
    }
    let rootAssembler = Assembler(
      [
        ServicesAssembly(),
        AppCoordinatorAssembly()
      ],
      container: rootContainer
    )
    return rootAssembler.resolver.resolve(AppCoordinator.self, argument: rootAssembler)!
  }
}
