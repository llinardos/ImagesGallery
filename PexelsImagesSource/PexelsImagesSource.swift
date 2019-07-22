import Networking
import ImageGallery
import Async

public class PexelsImagesSource: ImagesSource {
  private var server: PexelsServer
  private var apiKey: String
  private var pageNumber: Int = 1
  private var resultsPerPage: Int = 1
  private var isLoadingMore: Bool = false
  
  public init(apiKey: String, resultsPerPage: Int = 15) {
    self.apiKey = apiKey
    self.resultsPerPage = resultsPerPage
    self.server = PexelsServer()
  }
  
  private var images: [Image] = []
  
  public func getImages() -> [Image] {
    return images
  }
  
  public var thereIsMoreToLoad: Bool = true
  
  public func loadMore(_ callback: @escaping (ImagesSourceResult) -> Void) {
    guard !isLoadingMore else { return }
    
    onMainDo({}, onBackgroundDo: { () -> Result<[Image], ImagesSourceError> in
      let request = GetRandomPhotos.Request(apiKey: self.apiKey, imagesPerPage: self.resultsPerPage, pageNumber: self.pageNumber)
      let response = self.server.process(request)
      return GetRandomPhotos.ResponseHandler().handle(response)
    }, thenOnMainDo: { (result) -> Void in
      self.isLoadingMore = false
      switch result {
      case .success(let newImages):
        self.pageNumber += 1
        self.images.append(contentsOf: newImages)
        callback(.success(self))
      case .failure(let error):
        print(error)
        callback(.failure(error))
      }
    })
  }
}

class PexelsServer: Server {
  private let innerServer: AlamofireWebServer
  
  public init() {
    self.innerServer = AlamofireWebServer(serverURL: "https://api.pexels.com/v1/")
  }
  
  func process(_ request: Request) -> Response {
    return self.innerServer.process(request)
  }
}

class GetRandomPhotos {
  class Request: Networking.Request {
    init(apiKey: String, imagesPerPage: Int, pageNumber: Int) {
      super.init(endpoint: Endpoint(.get, "curated?per_page=\(imagesPerPage)&page=\(pageNumber)"), auth: .apiKey(apiKey))
    }
  }
  
  class ResponseHandler {
    func handle(_ response: Networking.Response) -> Result<[Image], ImagesSourceError> {
      switch response.result {
      case .noConnnection:
        return .failure(.noConnection(nil))
      case .notProcessed(let error):
        return .failure(.unexpected(error))
      case .processed(200, .success(.json(let jsonData, _))):
        return Result(catching: { try JSONDecoder().decode(Response.self, from: jsonData) })
          .map({ $0.photos.map { $0.toImage() } })
          .mapError({ error in return .unexpected(error) })
      case .processed(403, _):
        return .failure(.unauthorized)
      case .processed:
        return .failure(.unexpected(nil))
      case .unauthorized(let error):
        return .failure(.unexpected(error))
      }
    }
  }
  
  class Response: Decodable {
    class Photo: Decodable {
      class SRC: Decodable {
        let medium: URL
        let original: URL
      }
      
      let photographer: String
      let id: Int
      let src: SRC
    }
    
    var photos: [Photo]
  }
}

extension GetRandomPhotos.Response.Photo {
  func toImage() -> Image {
    return Image(
      id: self.id,
      photographerName: self.photographer,
      thumbnailURL: src.medium,
      fullResolutionURL: src.original
    )
  }
}
