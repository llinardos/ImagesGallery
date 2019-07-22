import UIKit

public class App {
  private lazy var navController = UINavigationController()
  private var galleryVC: GalleryVC?
  private var imagesSource: ImagesSource
  
  public init(imagesSource: ImagesSource) {
    self.imagesSource = imagesSource
  }
  
  public func run(on window: UIWindow) {
    presentGallery()
    window.rootViewController = navController
  }
  
  private func presentGallery() {
    let galleryVC = self.galleryVC ?? GalleryVC(imagesSource: imagesSource)
    navController.setNavigationBarHidden(true, animated: false)
    navController.setViewControllers([galleryVC], animated: false)
  }
}
