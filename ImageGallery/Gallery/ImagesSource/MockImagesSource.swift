import Foundation

class MockImagesSource: ImagesSource {
  private(set) var thereIsMoreToLoad: Bool = true
  private var images: [Image] = []
  func getImages() -> [Image] {
    return images
  }
  
  private var page: Int = 0
  func loadMore(_ callback: @escaping (ImagesSourceResult) -> Void) {
    guard thereIsMoreToLoad else { return }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
      self.page += 1
      self.images.append(contentsOf: [
        self.image(id: "Mock_One"),
        self.image(id: "Mock_Two"),
        self.image(id: "Mock_Three"),
        self.image(id: "Mock_Four"),
        self.image(id: "Mock_Five"),
        self.image(id: "Mock_Six")
        ])
      callback(.success(self))
      self.thereIsMoreToLoad = false
    }
  }
  
  func image(id: String) -> Image {
    return Image(
      name: "\(id) name",
      photographerName: "\(id) photographer",
      camera: "\(id) camera",
      imageURL: URL(string: "https://placehold.it/120x120&text=\(id)")!
    )
  }
}
