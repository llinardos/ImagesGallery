import UIKit
import SDWebImage
import Layout

class ImageViewerVC: UIViewController {
  private var imageView = ZoomableRemoteImageView()
  private var overlayView = OverlayView()
  private var navController: UINavigationController
  
  init(image: Image, in navController: UINavigationController) {
    self.navController = navController
    
    super.init(nibName: nil, bundle: nil)
    
    view.backgroundColor = UIColor.black
    
    view.addSubview(imageView)
    Layout().allign(.all, of: imageView, and: view, insets: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8))
    
    view.addSubview(overlayView)
    Layout().allign([.left, .right, .bottom], of: overlayView, and: view, toSafeArea: true)
    
    imageView.backgroundColor = .black
    
    imageView.zoomableImageView.onZoom = { [unowned self] isZooming in
      self.showNavBarAndOverlay(!isZooming, animated: true)
    }
    imageView.zoomableImageView.onDoubleTap = { [unowned self] in
      let currentZoomScale = self.imageView.zoomableImageView.zoomScale
      if currentZoomScale == 1.0 {
        if navController.isNavigationBarHidden {
          self.showNavBarAndOverlay(true, animated: true)
        } else {
          self.showNavBarAndOverlay(false, animated: true)
        }
      } else {
        self.imageView.zoomableImageView.setZoomScale(1.0, animated: true)
      }
    }
    
    imageView.setImage(image)
    overlayView.setLines(image.photographerName, String(describing: image.id))
  }
  
  private func showNavBarAndOverlay(_ show: Bool, animated: Bool) {
    self.navigationController?.setNavigationBarHidden(!show, animated: animated)
    self.showOverlay(show, animated: animated)
  }
  
  func showOverlay(_ show: Bool, animated: Bool) {
    func _showOverlay(_ show: Bool) {
      if show {
        overlayView.transform = .identity
        overlayView.alpha = 1.0
      } else {
        self.overlayView.transform = CGAffineTransform(translationX: 0, y: 100)
        self.overlayView.alpha = 0.0
      }
    }
    
    if animated {
      UIView.animate(withDuration: 0.2, delay: 0, options: .beginFromCurrentState, animations: {
        _showOverlay(show)
      }, completion: nil)
    } else {
      _showOverlay(show)
    }
  }
  
  required init?(coder aDecoder: NSCoder) { return nil }
  
  private var showingNavbarBeforePresenting: Bool!
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    showingNavbarBeforePresenting = navController.isNavigationBarHidden
    self.navigationController?.setNavigationBarHidden(false, animated: true)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    if let showingNavbarBeforePresenting = showingNavbarBeforePresenting {
      navController.setNavigationBarHidden(showingNavbarBeforePresenting, animated: true)
    }
  }
  
  public override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
}

