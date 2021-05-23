enum CustomResult<Element> {

  case success(Element)
  case error(Error)

  var element: Element? {
    if case let .success(element) = self {
      return element
    }
    return nil
  }

  var error: Error? {
    if case let .error(error) = self {
      return error
    }
    return nil
  }
}
