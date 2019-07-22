public struct Image {
  public var id: Int
  public var photographerName: String
  public var imageURL: URL
  
  public init(id: Int, photographerName: String, imageURL: URL) {
    self.id = id
    self.photographerName = photographerName
    self.imageURL = imageURL
  }
}
