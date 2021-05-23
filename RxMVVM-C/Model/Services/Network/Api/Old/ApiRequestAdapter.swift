import Alamofire

final class ApiRequestAdapter: RequestAdapter {
  
  private let authService: AuthenticationService

  init(authService: AuthenticationService) {
    self.authService = authService
  }

  func adapt(
    _ urlRequest: URLRequest,
    for session: Session,
    completion: @escaping (Result<URLRequest, Error>
    ) -> Void) {
    var resultRequest = urlRequest
    if let authHeader = urlRequest.value(forHTTPHeaderField: "Authorization"),
      authHeader.contains("Basic") || authHeader.contains("Social") {
      // Its OAuth request, shouldn't add Authentication header
      completion(.success(resultRequest))
      return
    }
    if let token = authService.token {
      resultRequest.setValue("Bearer \(token.accessToken)", forHTTPHeaderField: "Authorization")
    }
    completion(.success(resultRequest))
  }
}
