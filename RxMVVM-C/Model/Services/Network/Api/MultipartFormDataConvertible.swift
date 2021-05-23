import Alamofire

protocol MultipartFormDataConvertible {
  var multipartFormData: MultipartFormData { get }
}

extension MultipartFormData {

  func append(_ int: Int, withName name: String) {
    append(int.data, withName: name)
  }

  func append(_ int64: Int64, withName name: String) {
    append(int64.data, withName: name)
  }

  func append(_ string: String, withName name: String, encoding: String.Encoding = .utf8) {
    append(string.data(using: encoding) ?? Data(), withName: name)
  }
}

extension MultipartFormData: MultipartFormDataConvertible {
  var multipartFormData: MultipartFormData {
    self
  }
}

private extension Int {
  var data: Data {
    "\(self)".data(using: .utf8) ?? Data()
  }
}

private extension Int64 {
  var data: Data {
    "\(self)".data(using: .utf8) ?? Data()
  }
}
