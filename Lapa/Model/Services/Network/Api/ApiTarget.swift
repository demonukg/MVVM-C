import Alamofire

protocol ApiTarget {

  var version: ApiVersion { get }
  var path: String { get }
  var method: HTTPMethod { get }
  var parameters: [String: Any]? { get }
  var multipartFormDataBody: MultipartFormDataConvertible? { get }
  var headers: HTTPHeaders? { get }
  var apiUrl: ApiUrl { get }
  var requestParameterType: RequestParameterType { get }
}

enum ApiVersion {

  case number(Int)
  case custom(String)

  public var stringValue: String {
    switch self {
    case .number(let value):
      return "v\(value)"
    case .custom(let value):
      return value
    }
  }
}

enum ApiUrl {

  case standard
  case new
}

enum RequestParameterType {
  case queryString
  case bodyJSON
  case multipartFormData
}

extension ApiTarget {

  var defaultHeaders: HTTPHeaders {
    var headers = HTTPHeaders()
    headers.add(name: "X-User-Platform", value: "ios_app")
    headers.add(name: "X-User-Language", value: Bundle.main.localizationCode)
    switch self.requestParameterType {
    case .bodyJSON, .queryString:
      headers.add(name: "Content-Type", value: "application/json")
      headers.add(name: "Accept", value: "application/json")
    case .multipartFormData:
      //multipartFormData headers depend on its content, so it is set in ApiRequest
      break
    }
    return headers
  }

   var headers: HTTPHeaders? {
     defaultHeaders
   }

   var requestParameterType: RequestParameterType {
     method == .get ? .queryString : .bodyJSON
   }
  
  var apiUrl: ApiUrl {
    .standard
  }
  
  var multipartFormDataBody: MultipartFormDataConvertible? {
    nil
  }
}
