import RxSwift

protocol ProfileService {

  func getProfile() -> Observable<Profile>
  func createProfile(city: String, name: String, nickname: String, phoneNumber: String) -> Observable<Profile>
  func updateProfile(city: String, name: String, nickname: String, phoneNumber: String) -> Observable<Void>
}

final class ProfileServiceImpl: ProfileService {

  private let apiService: ApiService

  init(apiService: ApiService) {
    self.apiService = apiService
  }
  
  func getProfile() -> Observable<Profile> {
    apiService.makeRequest(to: ProfileServiceTarget.getProfile)
      .result()
  }

  func createProfile(city: String, name: String, nickname: String, phoneNumber: String) -> Observable<Profile> {
    apiService.makeRequest(
      to: ProfileServiceTarget.createProfile(
        city: city,
        name: nickname,
        nickname: nickname,
        phoneNumber: phoneNumber
      )
    )
    .result()
  }

  func updateProfile(city: String, name: String, nickname: String, phoneNumber: String) -> Observable<Void> {
    apiService.makeRequest(
      to: ProfileServiceTarget.updateProfile(
        city: city,
        name: name,
        nickname: nickname,
        phoneNumber: phoneNumber
      )
    )
    .result()
  }
}
