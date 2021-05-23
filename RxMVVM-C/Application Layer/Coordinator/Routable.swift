import UIKit

protocol Routable: Presentable {
  
  var topModule: Presentable? { get }
  
  func topViewController() -> UIViewController?
    
  func present(_ module: Presentable?)
  func present(_ module: Presentable?, animated: Bool)
  
  func push(_ module: Presentable?)
  func push(_ module: Presentable?, animated: Bool)
  func push(_ module: Presentable?, animated: Bool, completion: EmptyActionBlock?)
  
  func popModule()
  func popModule(animated: Bool)
  
  func popToModule(_ module: Presentable?)
  func popToModule(_ module: Presentable?, animated: Bool)
  
  func dismissModule()
  func dismissModule(animated: Bool, completion: EmptyActionBlock?)
  
  func setRootModule(_ module: Presentable?)
  func setRootModule(_ module: Presentable?, animated: Bool)
  
  func popToRootModule()
  func popToRootModule(animated: Bool)
}

extension Routable {

  func present(_ module: Presentable?) {
    present(module, animated: true)
  }

  func push(_ module: Presentable?) {
    push(module, animated: true, completion: nil)
  }
  
  func push(_ module: Presentable?, animated: Bool) {
    push(module, animated: animated, completion: nil)
  }

  func popModule() {
    popModule(animated: true)
  }

  func popToRootModule() {
    popToRootModule(animated: true)
  }

  func popToModule(_ module: Presentable?) {
    popToModule(module, animated: true)
  }

  func dismissModule() {
    dismissModule(animated: true, completion: nil)
  }

  func setRootModule(_ module: Presentable?) {
    setRootModule(module, animated: true)
  }
}
