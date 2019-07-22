public struct Image {
  public var id: Int
  public var photographerName: String
  public var thumbnailURL: URL
  public var fullResolutionURL: URL
  
  public init(id: Int, photographerName: String, thumbnailURL: URL, fullResolutionURL: URL) {
    self.id = id
    self.photographerName = photographerName
    self.thumbnailURL = thumbnailURL
    self.fullResolutionURL = fullResolutionURL
  }
}
