struct LoginResponse: Decodable {

  let scopes: [Scopes]
}

enum Scopes: String, Decodable {

  case unregistered
  case client
}
