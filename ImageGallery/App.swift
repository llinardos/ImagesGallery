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
    let galleryVC = GalleryVC(imagesSource: imagesSource)
    self.galleryVC = galleryVC
    navController.setNavigationBarHidden(true, animated: false)
    navController.setViewControllers([galleryVC], animated: false)
    navController.navigationBar.barStyle = .blackTranslucent
    navController.navigationBar.tintColor = UIColor.white
    
    galleryVC.didSelectImage = { [unowned self] image in
      self.presentDetail(for: image)
    }
  }
  
  private func presentDetail(for image: Image) {
    let imageViewerVC = ImageViewerVC(image: image, in: navController)
    self.imageViewerVC = imageViewerVC
    
    imageViewerVC.onShare = { [unowned self] image in
      self.shareImage(image)
    }
    
    navController.pushViewController(imageViewerVC, animated: true)
  }
  
  private func shareImage(_ image: Image) {
    let shareText = "Check out the image that I discovered on Image Gallery: \(image.fullResolutionURL)"
    let items = [shareText]
    let shareVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
    self.navController.present(shareVC, animated: true, completion: nil)
  }
}
