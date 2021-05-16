struct CreateProfileModuleInput {
    
}

protocol CreateProfileModule: Presentable {

  typealias Input = CreateProfileModuleInput

  var onFinish: EmptyActionBlock? { get set }
}
