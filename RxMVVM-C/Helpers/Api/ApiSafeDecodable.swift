struct SafeDecodable<Base: Decodable>: Decodable {

  let value: Base?

  init(from decoder: Decoder) throws {
    do {
      let container = try decoder.singleValueContainer()
      value = try container.decode(Base.self)
    } catch {
      print("Can not decode value with error: \(error)")
      value = nil
    }
  }
}
