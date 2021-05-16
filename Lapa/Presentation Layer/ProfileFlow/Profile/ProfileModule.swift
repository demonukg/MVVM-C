struct ProfileModuleInput {
  
  enum ActionType {
    case login
    case registration
  }
}

protocol ProfileModule: Presentable {

  typealias Input = ProfileModuleInput
}
