struct ValidationModuleInput {
  let phoneNumber: String
}

protocol ValidationModule: Presentable {

  typealias Input = ValidationModuleInput

  var onFinish: EmptyActionBlock? { get set }
}
