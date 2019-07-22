public protocol Server {
  func process(_ request: Request) -> Response
}

