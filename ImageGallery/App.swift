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
    let galleryVC = self.galleryVC ?? GalleryVC()
    navController.setViewControllers([galleryVC], animated: false)
  }
}
