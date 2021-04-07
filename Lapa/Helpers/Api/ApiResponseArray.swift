struct ResponseArray<T: Decodable>: Decodable {

  let items: [T?]

  enum CodingKeys: CodingKey {
    case items
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    // Safe decoding: items == null -> self.items = []
    guard var itemsArrayContainer = try? container.nestedUnkeyedContainer(forKey: .items) else {
      items = []
      return
    }

    var result = [T?]()
    while !itemsArrayContainer.isAtEnd {
      let item = try itemsArrayContainer.decode(SafeDecodable<T>.self)
      result.append(item.value)
    }
    items = result
  }
}
