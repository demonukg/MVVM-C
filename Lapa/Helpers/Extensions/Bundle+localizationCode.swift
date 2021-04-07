import Foundation

extension Bundle {

  var localizationCode: String {
    let localizationCode = Bundle.main.preferredLocalizations.first
    return localizationCode ?? "en"
  }
}
