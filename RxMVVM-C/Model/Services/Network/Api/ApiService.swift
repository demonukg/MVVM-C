typealias ApiRequestFactory = (ApiTarget) -> ApiRequestable

protocol ApiService {
  
  func makeRequest(to target: ApiTarget) -> ApiRequestable
}

struct ApiServiceImpl: ApiService {

  private let requestFactory: ApiRequestFactory

  init(requestFactory: @escaping ApiRequestFactory) {
    self.requestFactory = requestFactory
  }

  func makeRequest(to target: ApiTarget) -> ApiRequestable {
    return requestFactory(target)
  }
}
