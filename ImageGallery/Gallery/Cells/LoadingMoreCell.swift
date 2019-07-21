import UIKit
import CollectionViewCell
import Layout

class LoadingMoreCollectionCell: UICollectionViewCell, IdentificableCell, RegistrableOnUICollectionView, DequeuebableFromUICollectionView {
  private lazy var spinner = UIActivityIndicatorView(style: .white)
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    contentView.addSubview(spinner)
    Layout().center(spinner, in: contentView)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    spinner.startAnimating()
  }
  
  required init?(coder aDecoder: NSCoder) { return nil }
}
