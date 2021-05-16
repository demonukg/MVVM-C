struct Profile: Codable {

  let id: String
  let name: String
  let nickname: String
  let phoneNumber: String


  enum CodingKeys: String, CodingKey {

    case id
    case name
    case nickname
    case phoneNumber = "phone_number"
  }
}

