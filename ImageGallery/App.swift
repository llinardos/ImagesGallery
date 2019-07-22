import UIKit

public class App {
  private lazy var navController = UINavigationController()
  private var galleryVC: GalleryVC?
  private var imageViewerVC: ImageViewerVC?
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
    
    galleryVC.didSelectImage = { [unowned self] image in
      self.presentDetail(for: image)
    }
  }
  
  private func presentDetail(for image: Image) {
    let imageViewerVC = ImageViewerVC(image: image, in: navController)
    navController.pushViewController(imageViewerVC, animated: true)
  }
}
