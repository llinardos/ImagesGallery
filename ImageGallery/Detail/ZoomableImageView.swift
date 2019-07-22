import UIKit
import Layout
import SDWebImage

class ZoomableImageView: UIScrollView, UIScrollViewDelegate {
  fileprivate var imageView: UIImageView = UIImageView()
  fileprivate var imageAspectRatioConstraint: NSLayoutConstraint?
  
  typealias IsZoomed = Bool
  var onZoom: (IsZoomed) -> Void = { _ in }
  var onDoubleTap: () -> Void = { }
  
  private(set) var image: UIImage?
  
  func setImage(_ image: UIImage?) {
    self.image = image
    imageView.image = image
    
    if let constraint = imageAspectRatioConstraint {
      imageView.removeConstraint(constraint)
    }
    
    if let image = image {
      let aspectRatio = image.size.height / image.size.width
      imageAspectRatioConstraint = imageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: aspectRatio, constant: 0)
      imageAspectRatioConstraint?.isActive = true
    }
    
    centerContentOnScrollView()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    delegate = self
    addSubview(imageView)
    
    imageView.contentMode = .scaleAspectFill
    imageView.isUserInteractionEnabled = true
    self.maximumZoomScale = 10.0
    
    imageView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    Layout().allign(.all, of: imageView, and: self)
    
    self.alwaysBounceVertical = true
    self.alwaysBounceHorizontal = true
    self.contentInsetAdjustmentBehavior = .never
    
    let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(doubleTap))
    doubleTapGesture.numberOfTapsRequired = 2
    doubleTapGesture.numberOfTouchesRequired = 1
    self.addGestureRecognizer(doubleTapGesture)
  }
  
  @objc func doubleTap() {
    self.onDoubleTap()
  }
  
  required init?(coder aDecoder: NSCoder) { return nil }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    centerContentOnScrollView()
  }
  
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return imageView
  }
  
  func scrollViewDidZoom(_ scrollView: UIScrollView) {
    centerContentOnScrollView()
    let isZoomed = scrollView.zoomScale != 1.0
    onZoom(isZoomed)
  }
  
  fileprivate func centerContentOnScrollView() {
    let offsetX = max((bounds.width - contentSize.width) * 0.5, 0)
    let offsetY = max((bounds.height - contentSize.height) * 0.5, 0)
    contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: 0, right: 0)
  }
}

class ZoomableRemoteImageView: UIView {
  required override init(frame: CGRect = CGRect.zero) { super.init(frame: frame); commonInit() }
  required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder); commonInit() }
  
  let zoomableImageView = ZoomableImageView()
  var spinner = UIActivityIndicatorView(style: .whiteLarge)
  private var isLoading: Bool = false
  
  internal func commonInit() {
    self.backgroundColor = .black
    
    zoomableImageView.clipsToBounds = true
    zoomableImageView.maximumZoomScale = 10.0
    
    self.addSubview(zoomableImageView)
    Layout().allign(.all, of: zoomableImageView, and: self)
    
    self.addSubview(spinner)
    Layout().center(spinner, in: self)
    
    spinner.startAnimating()
  }
  
  func setImage(_ image: Image) {
    zoomableImageView.setZoomScale(1.0, animated: false)
    
    guard zoomableImageView.image == nil, !isLoading else {
      return
    }
    
    SDWebImageManager.shared.loadImage(with: image.imageURL, options: [], progress: nil) { (image, _, error, _, _, _) in
      self.isLoading = false
      if let image = image {
        self.spinner.isHidden = true
        self.zoomableImageView.setImage(image)
      } else {
        // TODO: do something in case of error, show error and offer retry?
      }
    }
  }
}

