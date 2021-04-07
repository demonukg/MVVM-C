import Alamofire
import RxSwift

protocol ApiRequestInterceptor: RequestInterceptor {

  typealias RetryCompletion = (RetryResult) -> Void
}

final class ApiRequestInterceptorImpl: ApiRequestInterceptor {

  private var lock = NSLock()
  private var isRefreshing = false
  private var requestsToRetry = [RetryCompletion]()
  private var requestsToRetryCounts = [Request: Int]()

  private let disposeBag = DisposeBag()

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
      completion(.success(resultRequest))
      return
    }
    if let token = authService.token {
      resultRequest.setValue("Bearer \(token.accessToken)", forHTTPHeaderField: "Authorization")
    }
    completion(.success(resultRequest))
  }

  func retry(
    _ request: Request,
    for session: Session,
    dueTo error: Error,
    completion: @escaping (RetryResult) -> Void
  ) {
    lock.lock()
    defer {
      lock.unlock()
    }
    guard
      let asAFError = error.asAFError,
      let statusCode = asAFError.responseCode
    else {
      return completion(.doNotRetry)
    }

    guard statusCode == Constants.badToken else {
      completion(.doNotRetry)
      return
    }
    refreshToken(completion: completion)
  }
}

private extension ApiRequestInterceptorImpl {

  func refreshToken(completion: @escaping RetryCompletion) {
    requestsToRetry.append(completion)
    guard !isRefreshing else {
      return
    }
    isRefreshing = true
    authService.refreshToken()
      .subscribe(
        onNext: { [weak self] in
          guard let self = self else { return }
          self.lock.lock()
          defer {
            self.lock.unlock()
          }
          self.requestsToRetry.forEach { $0(.retryWithDelay(Constants.timeout)) }
          self.requestsToRetry = []
        },
        onError: { [weak self] error in
          self?.requestsToRetry.forEach { $0(.doNotRetry) }
          NotificationCenter.default.post(name: .forceLogoutNotificationName, object: nil)
        },
        onDisposed: { [weak self] in
          self?.isRefreshing = false
        }
      )
      .disposed(by: disposeBag)
  }

  enum Constants {
    static let timeout: TimeInterval = 0.1
    static let badToken = 401
  }
}
