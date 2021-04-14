struct AuthModuleInput {
  
  enum AuthType {
    case login
    case registration
  }

  let authType: AuthType
}

protocol AuthModule: Presentable {

  typealias Input = AuthModuleInput

  var onSuccessPhone: SingleActionBlock<String>? { get set }
}
