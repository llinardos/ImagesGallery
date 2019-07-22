import UIKit

public class App {
  private lazy var navController = UINavigationController()
  private var galleryVC: GalleryVC?
  
  public init() {
  }
  
  public func run(on window: UIWindow) {
    presentGallery()
    window.rootViewController = navController
  }
  
  private func presentGallery() {
    let mockedImagesSource = MockImagesSource()
    let galleryVC = self.galleryVC ?? GalleryVC(imagesSource: mockedImagesSource)
    navController.setViewControllers([galleryVC], animated: false)
  }
}
