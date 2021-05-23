struct Token: Codable {

  let accessToken: String

  enum CodingKeys: String, CodingKey {

    case accessToken = "access_token"
  }
}
