open class Request {
  public enum Auth {
    case basic(String, String)
    case bearerToken(String)
    case apiKey(String)
    case none
  }
  
  public let endpoint: Endpoint
  public let body: [String: Any]?
  public let queryParams: [String: Any]
  public let auth: Auth
  
  public init(endpoint: Endpoint, auth: Auth, queryParams: [String: Any] = [:], body: [String: Any]? = [:]) {
    self.endpoint = endpoint
    self.queryParams = queryParams
    self.body = body
    self.auth = auth
  }
}
