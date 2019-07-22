public protocol ImagesSource {
  var thereIsMoreToLoad: Bool { get }
  func getImages() -> [Image]
  func loadMore(_ callback: @escaping (ImagesSourceResult) -> Void)
}

public typealias ImagesSourceResult = Swift.Result<ImagesSource, ImagesSourceError>

public enum ImagesSourceError: Swift.Error {
  case unauthorized
  case noConnection
  case unexpected
}
