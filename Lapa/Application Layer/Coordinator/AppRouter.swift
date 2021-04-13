import UIKit

protocol AppRouter: Routable {
  
}

final class AppRouterImpl: NSObject, AppRouter {
  
  typealias RouterCompletions = [UIViewController : EmptyActionBlock]
  
  var topModule: Presentable? {
    rootController
  }
  
  var toPresent: UIViewController? {
    rootController
  }
  
  private var completions: RouterCompletions
  
  private let rootController: UINavigationController
  
  init(rootController: UINavigationController) {
    self.rootController = rootController
    self.rootController.modalPresentationStyle = .fullScreen
    self.rootController.view.backgroundColor = .white
    completions = [:]
  }
  
  func topViewController() -> UIViewController? {
    rootController.viewControllers.last
      ?? rootController.presentedViewController
      ?? rootController
  }
  
  func present(_ module: Presentable?, animated: Bool) {
    guard let controller = module?.withDisabledLargeTitle()?.toPresent else { return }
    rootController.present(controller, animated: animated, completion: nil)
  }
  
  func dismissModule(animated: Bool, completion: EmptyActionBlock?) {
    rootController.dismiss(animated: animated, completion: completion)
  }

  func push(_ module: Presentable?, animated: Bool, completion: EmptyActionBlock?) {
    var moduleToPresent = module
    if !rootController.viewControllers.isEmpty {
      moduleToPresent = moduleToPresent?.toPresent?.withDisabledLargeTitle()
    }
    
    guard let controller = moduleToPresent?.toPresent else { return }
    if let completion = completion {
      completions[controller] = completion
    }
    controller.navigationItem.backBarButtonItem = UIBarButtonItem(
      title: " ",
      style: .plain,
      target: nil,
      action: nil
    )
    rootController.pushViewController(controller, animated: animated)
  }
  
  func popModule(animated: Bool) {
    if let controller = rootController.popViewController(animated: animated) {
      runCompletion(for: controller)
    }
  }
  
  func popToRootModule(animated: Bool) {
    if let controllers = rootController.popToRootViewController(animated: animated) {
      controllers.forEach { controller in
        runCompletion(for: controller)
      }
    }
  }
  
  func popToModule(_ module: Presentable?, animated: Bool) {
    guard let module = module else {
      popToRootModule(animated: animated)
      return
    }
    guard let viewController = module.toPresent else {
      return
    }
    if let controllers = rootController.popToViewController(viewController, animated: animated) {
      controllers.forEach { controller in
        runCompletion(for: controller)
      }
    }
  }
  
  func setRootModule(_ module: Presentable?, animated: Bool) {
    guard let controller = module?.toPresent else { return }
    rootController.setViewControllers([controller], animated: animated)
  }
}

private extension AppRouterImpl {
  
  func runCompletion(for controller: UIViewController) {
    guard let completion = completions[controller] else { return }
    completion()
    completions.removeValue(forKey: controller)
  }
}
