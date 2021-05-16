import Alamofire

enum ProfileServiceTarget: ApiTarget {

  case getProfile
  case createProfile(city: String, name: String, nickname: String, phoneNumber: String)
  case updateProfile(city: String, name: String, nickname: String, phoneNumber: String)

  var apiUrl: ApiUrl {
    .profile
  }

  var version: ApiVersion {
    .number(1)
  }

  var path: String {
    switch self {
    case .getProfile:
      return "/profile/"
    case .createProfile:
      return "/profile/"
    case .updateProfile:
      return "/profile/"
    }
  }

  var method: HTTPMethod {
    switch self {
    case .getProfile:
      return .get
    case .createProfile:
      return .post
    case .updateProfile:
      return .patch
    }
  }

  var parameters: [String : Any]? {
    switch self {
    case .getProfile:
      return nil
    case let .createProfile(city, name, nickname, phoneNumber):
      return [
        "city": city,
        "name": name,
        "nickname": nickname,
        "phone_number": phoneNumber
      ]
    case let .updateProfile(city, name, nickname, phoneNumber):
      return [
        "city": city,
        "name": name,
        "nickname": nickname,
        "phone_number": phoneNumber
      ]
    }
  }
}

