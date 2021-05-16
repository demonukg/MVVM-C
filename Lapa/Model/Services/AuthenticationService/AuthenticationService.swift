import RxSwift

protocol AuthenticationService {

  var scopes: [Scopes] { get }
  var token: OAuthToken? { get }
  var authenticated: Bool { get }

  func login(_ login: String) -> Observable<Void>
  func validate(login: String, password: String) -> Observable<OAuthToken>
  func refreshToken() -> Observable<Void>
  func logout()
  func addLogoutListener(_ logoutListener: LogoutListener)
}

protocol LogoutListener {
  
  func cleanUpAfterLogout()
}

final class AuthenticationServiceImpl: AuthenticationService {

  var scopes: [Scopes] = []
  
  var token: OAuthToken?
  
  var authenticated: Bool {
    token != nil
  }
  
  private let apiService: ApiService
  
  private var logoutListeners = [LogoutListener]()
  
  init(apiService: ApiService) {
    self.apiService = apiService
  }
  
  func login(_ login: String) -> Observable<Void> {
    apiService.makeRequest(to: OAuthServiceTarget.login(login: login))
      .result()
      .do(onNext: { [unowned self] (response: LoginResponse) in
        self.scopes = response.scopes
      })
      .asVoid()
  }
  
  func validate(login: String, password: String) -> Observable<OAuthToken> {
    apiService.makeRequest(to: OAuthServiceTarget.validate(login: login, password: password))
      .result()
      .do(onNext: { [unowned self] (token: OAuthToken) in
        self.token = token
      })
  }

  func refreshToken() -> Observable<Void> {
    guard let refreshToken = token?.refreshToken else {
      return Observable.error(OAuthError.noRefreshToken)
    }
    return apiService.makeRequest(to: OAuthServiceTarget.refresh(refreshToken: refreshToken))
      .result()
      .do(onNext: { [unowned self] (token: Token) in
        self.token = OAuthToken(accessToken: token.accessToken, refreshToken: refreshToken)
      })
      .asVoid()
  }
  
  func logout() {
    token = nil
    logoutListeners.forEach { $0.cleanUpAfterLogout() }
  }
  
  func addLogoutListener(_ logoutListener: LogoutListener) {
    logoutListeners.append(logoutListener)
  }
}

private extension AuthenticationServiceImpl {

  enum OAuthError: Error {
    case noRefreshToken
  }
}
