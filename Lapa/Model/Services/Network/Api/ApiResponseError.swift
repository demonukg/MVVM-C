import Foundation

enum ApiResponseError: Error {

  case badServerResponse
  case responseDecoding
  case dateDecoding
}

extension ApiResponseError: LocalizedError {

  var errorDescription: String? {
    switch self {
    case .badServerResponse:
      return "Bad server response"
    case .responseDecoding:
      return "Response decoding"
    case .dateDecoding:
      return "Date decoding error"
    }
  }
}
