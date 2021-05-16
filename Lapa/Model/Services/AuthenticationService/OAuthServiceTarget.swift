import Alamofire

enum OAuthServiceTarget: ApiTarget {
  
  case login(login: String)
  case validate(login: String, password: String)
  case refresh(refreshToken: String)

  var apiUrl: ApiUrl {
    .auth
  }

  var version: ApiVersion {
    .number(1)
  }
  
  var path: String {
    switch self {
    case .login:
      return "/login"
    case .validate:
      return "/validate"
    case .refresh:
      return "/refresh"
    }
  }
  
  var method: HTTPMethod {
    .post
  }
  
  var parameters: [String : Any]? {
    switch self {
    case .login(let login):
      return [
        "login": login,
        "scopes": ["client"]
      ]
    case let .validate(login, password):
      return [
        "device_description": "deviceID",
        "login": login,
        "password": password
      ]
    case .refresh(let refreshToken):
      return [
        "refresh_token": refreshToken
      ]
    }
  }
}
