open class Response {
  public enum Result {
    case noConnnection
    case notProcessed(Error?)
    case processed(statusCode: Int, Swift.Result<ResponseData, Error>)
    case unauthorized(Error?)
  }
  
  public private(set) var result: Result
  public private(set) var request: Request
  
  public init(request: Request, result: Result) {
    self.result = result
    self.request = request
  }
}

public enum ResponseData {
  case json(Data, [String: Any])
  case string(Data, String)
  case raw(Data)
  case empty
}

