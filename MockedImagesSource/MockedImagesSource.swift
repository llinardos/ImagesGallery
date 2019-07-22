import Foundation
import ImageGallery

public class MockImagesSource: ImagesSource {
  public private(set) var thereIsMoreToLoad: Bool = true
  private var images: [Image] = []
  
  public init() {}
  
  public func getImages() -> [Image] {
    return images
  }
  
  private var page: Int = 0
  public func loadMore(_ callback: @escaping (ImagesSourceResult) -> Void) {
    guard thereIsMoreToLoad else { return }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
      self.page += 1
      self.images.append(contentsOf: [
        self.image(id: 1),
        self.image(id: 2),
        self.image(id: 3),
        self.image(id: 4),
        self.image(id: 5),
        self.image(id: 6)
        ])
      callback(.success(self))
      self.thereIsMoreToLoad = false
    }
  }
  
  func image(id: Int) -> Image {
    return Image(
      id: id,
      photographerName: "Photographer \(id) ",
      thumbnailURL: URL(string: "https://placehold.it/120x120&text=Mock_\(id)")!,
      fullResolutionURL: URL(string: "https://placehold.it/1200x1200&text=Mock_\(id)")!
    )
  }
}
