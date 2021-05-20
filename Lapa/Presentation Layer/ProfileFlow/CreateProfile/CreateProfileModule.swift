struct CreateProfileModuleInput {

  enum ActionType {
    case create
    case update
  }

  let currentAction: ActionType
  let profile: Profile?
}

protocol CreateProfileModule: Presentable {

  typealias Input = CreateProfileModuleInput

  var onFinish: EmptyActionBlock? { get set }
}
