import RxAlamofire
import RxSwift
import Alamofire

struct ApiRequest: ApiRequestable {

  private let request: Alamofire.DataRequest

  init(
    url: URL,
    target: ApiTarget,
    manager: Session
  ) {

    let requestUrl = url
      .appendingPathComponent(target.version.stringValue)
      .appendingPathComponent(target.path)

    switch target.requestParameterType {
    case .bodyJSON, .queryString:

      let method = target.method
      let encoding: ParameterEncoding
      switch target.requestParameterType {
      case .queryString:
        encoding = URLEncoding.queryString
      case .bodyJSON:
        encoding = JSONEncoding.default
      case .multipartFormData:
        //sanity check - this case should not be reached; .multipartFormData is handled below
        assertionFailure()
        encoding = JSONEncoding.default
      }

      request = manager.request(
        requestUrl,
        method: method,
        parameters: target.parameters,
        encoding: encoding,
        headers: target.headers
      ).response {
        print(
          """
            code: \($0.response?.statusCode ?? 0),
            path: \($0.response?.url?.absoluteString ?? "")
          """
        )
      }
    case .multipartFormData:

      //due to weird Alamofire implementation, multipart/form-data requests are not created by usual `encoding` parameter.
      //Instead, you have to create a separate entity, MultipartFormData, and either send it with SessionManger, or
      //use MultipartFormData.encode() to create URLRequest manually.
      //We use the 2nd option

      var urlRequest = URLRequest(url: requestUrl)
      urlRequest.httpMethod = target.method.rawValue
      do {
        if let multipartFormData = target.multipartFormDataBody?.multipartFormData {
          urlRequest.httpBody = try multipartFormData.encode()
          target.headers?.forEach { header in
            urlRequest.setValue(header.value, forHTTPHeaderField: header.name)
          }
          urlRequest.setValue(multipartFormData.contentType, forHTTPHeaderField: "Content-Type")
        } else {
          print("No multipartFormDataBody parameter for ApiTarget \(target) that uses multipart/form-data encoding.")
        }
      } catch {
        print("Error while encoding multipart/form-data: " + error.localizedDescription)
      }
      request = manager.request(urlRequest)
    }
  }

  func cancel() {
    request.cancel()
  }

  func run() -> Observable<Data> {
    print(
      """
        method: \(request.request?.httpMethod ?? ""),
        path: \(request.request?.url?.absoluteString ?? ""),
      """
    )
    request.resume()
    return request
      .validate { _, response, data in
        guard let _ = data else { return .failure(ApiResponseError.badServerResponse) }

        if 200...299 ~= response.statusCode { return .success(()) }

        return .failure(ApiResponseError.badServerResponse)
//        guard let apiError = try? JSONDecoder().decode(ApiError.self, from: data) else {
//          return .failure(ApiResponseError.badServerResponse)
//        }
//
//        guard case let .exception(exception) = apiError else { return .failure(apiError) }
//
//        var errorDescription = exception.error.errorDescription
//        if response.statusCode >= 500 {
//          errorDescription = ApiResponseError.badServerResponse.localizedDescription
//        }
//
//        return .failure(NSError(
//          domain: apiErrorDomain,
//          code: exception.code,
//          userInfo: [NSLocalizedDescriptionKey: errorDescription])
//        )
    }
    .rx.responseJSON()
    .do(onError: { error in print("\(error)") })
    .map { (response: DataResponse) -> Data in
      switch response.result {
      case .failure(let error):
        throw error
      case .success:
        guard let data = response.data else { throw ApiResponseError.badServerResponse }
        return data
      }
    }
  }
}
