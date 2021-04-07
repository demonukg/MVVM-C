import Foundation

enum ApiResponseError: LocalizedError {

  case badServerResponse
  case dateDecoding

  public var errorDescription: String? {
    switch self {
    case .badServerResponse:
      return "Bad server response"
    case .dateDecoding:
      return "Date decoding error"
    }
  }
}
