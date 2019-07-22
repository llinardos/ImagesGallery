import Foundation
import Alamofire

public class AlamofireWebServer : Server {
  private var serverURL: String
  
  public init(serverURL: String) {
    self.serverURL = serverURL
    
    let configuration = URLSessionConfiguration.default
    configuration.timeoutIntervalForRequest = 10
    configuration.timeoutIntervalForResource = 10
    _ = Alamofire.SessionManager(configuration: configuration)
  }
  
  public func process(_ request: Request) -> Response {
    if !Reachability.isConnectedToNetwork() {
      Thread.sleep(forTimeInterval: 0.2)
      return Response.init(request: request, result: .noConnnection)
    }
    
    let baseUrl = self.serverURL + "/"
    let url = baseUrl + request.endpoint.url
    var headerParams = HTTPHeaders()
    
    var params: [String: Any] = [:]
    request.queryParams.forEach { (k, v) in
      params[k] = v
    }
    request.body?.forEach { (k, v) in
      params[k] = v
    }
    
    switch request.auth {
    case .basic(let user, let pass):
      let userAndPassAsBase64 = "\(user):\(pass)".data(using: .utf8)?.base64EncodedString() ?? ""
      headerParams["Authorization"] = "Basic \(userAndPassAsBase64)"
    case .bearerToken(let token):
      headerParams["Authorization"] = "Bearer \(token)"
    case .apiKey(let key):
      headerParams["Authorization"] = "\(key)"
    case .none:
      break
    }
    
    let data = Alamofire.request(url,
                                 method: Alamofire.HTTPMethod(from: request.endpoint.verb),
                                 parameters: params.isEmpty ? nil : params,
                                 encoding: JSONEncoding.default,
                                 headers: headerParams).responseJSON()
    
    guard let httpResponse = data.response else {
      return Response(request: request, result: .notProcessed(data.result.error))
    }
    
    let statusCode = httpResponse.statusCode
    
    if let data = data.data {
      if let json = (try? JSONSerialization.jsonObject(with: data, options: [])).flatMap({ $0 as? [String : Any] }) {
        let jsonData = data
        return Response(request: request, result: .processed(statusCode: statusCode, .success(.json(jsonData, json))))
      }
      if let string = String(data: data, encoding: .utf8) {
        let stringData = data
        return Response(request: request, result: .processed(statusCode: statusCode, .success(.string(stringData, string))))
      }
      return Response(request: request, result: .processed(statusCode: statusCode, .success(.raw(data))))
    }
    return Response(request: request, result: .processed(statusCode: statusCode, .success(.empty)))    
  }
}


extension Alamofire.HTTPMethod {
  init(from verb: Endpoint.Verb) {
    switch verb {
    case .put: self = .put
    case .get: self = .get
    case .post: self = .post
    case .delete: self = .delete
    case .patch: self = .patch
    }
  }
}
