import UIKit
import CollectionViewCell
import SDWebImage
import Layout

class ImageInGalleryCell: UICollectionViewCell, IdentificableCell, RegistrableOnUICollectionView, DequeuebableFromUICollectionView {
  private lazy var imageView = UIImageView()
  private lazy var spinner = UIActivityIndicatorView(style: .white)
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    
    contentView.addSubview(spinner)
    Layout().center(spinner, in: contentView)
    
    contentView.addSubview(imageView)
    Layout().allign(.all, of: imageView, and: contentView)
  }
  
  func setup(_ image: Image) {
    spinner.startAnimating()
    self.imageView.sd_setImage(with: image.thumbnailURL) { (_, error, _, _) in
      if error == nil {
        self.spinner.stopAnimating()
      } else {
        // TODO: handle fail
      }
    }
  }
  
  required init?(coder aDecoder: NSCoder) { return nil }
}

