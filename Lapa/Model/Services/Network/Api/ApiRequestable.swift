import RxSwift

protocol Requestable {

  func result<T: Decodable>() -> Observable<T>
  func result<T: Decodable>(ignoreNils: Bool) -> Observable<[T]>
  func result() -> Observable<Void>
  func run() -> Observable<Data>
}

protocol ApiRequestable: Requestable {
  
}

extension ApiRequestable {

  func result<T: Decodable>() -> Observable<T> {
    mapResult { json in
      do {
        return try decoder.decode(T.self, from: json)
      } catch {
        let jsonString = String(data: json, encoding: .utf8) ?? ""
        print(
          """
            Decoding error in `\(T.self)`:
            Error:
            \(error)
            Encountered in JSON:
            \(jsonString)
          """
        )
        throw ApiResponseError.badServerResponse
      }
    }
  }

  func result<T: Decodable>(ignoreNils: Bool = false) -> Observable<[T]> {
    mapResult { json -> [T] in
      let items = try decoder.decode(ResponseArray<T>.self, from: json).items
      let notNilItems = items.compactMap { $0 }
      if !ignoreNils && items.count != notNilItems.count {
        throw ApiResponseError.badServerResponse
      }
      return notNilItems
    }
  }

  @discardableResult
  func result() -> Observable<Void> {
    mapResult { _ in return }
  }

  private func mapResult<O>(mapper: @escaping (Data) throws -> O) -> Observable<O> {
    run()
      .observe(on: runQueueScheduler)
      .map(mapper)
      .observe(on: MainScheduler.instance)
  }
}

private let dateStrategy: JSONDecoder.DateDecodingStrategy = {

  func decodeTimestamp(decoder: Decoder) throws -> Date {
    let container = try decoder.singleValueContainer()
    if let timestampDate = try? container.decode(Int64.self) {
      return Date(timeIntervalSince1970: TimeInterval(timestampDate))
    }
    throw ApiResponseError.dateDecoding
  }
  return .custom(decodeTimestamp)
}()

private let decoder: JSONDecoder = {
  
  let decoder = JSONDecoder()
  decoder.dateDecodingStrategy = dateStrategy
  return decoder
}()

private let runQueueScheduler: SchedulerType = {
  
  let queue = DispatchQueue(label: "run_queue", qos: .default)
  return ConcurrentDispatchQueueScheduler(queue: queue)
}()
