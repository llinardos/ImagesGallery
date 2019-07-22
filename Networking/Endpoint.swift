open class Endpoint {
  public enum Verb {
    case get
    case post
    case put
    case delete
    case patch
  }
  
  public let verb: Verb
  public let url: String
  public init(_ verb: Verb, _ url: String) {
    self.verb = verb
    self.url = url
  }
}
