import UIKit
import Layout

public class GalleryVC: UIViewController {
  private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
  private var imagesSource: ImagesSource
  
  public init(imagesSource: ImagesSource) {
    self.imagesSource = imagesSource
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) { return nil }
  
  public override func loadView() {
    super.loadView()
    self.view.backgroundColor = UIColor.black
    
    self.view.addSubview(collectionView)
    Layout().allign(.all, of: self.collectionView, and: self.view, toSafeArea: false, insets: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8))
    
    self.collectionView.backgroundView = UIView()
    self.collectionView.backgroundColor = UIColor.black
    
    self.collectionView.delegate = self
    self.collectionView.dataSource = self
    
    LoadingMoreCollectionCell.register(on: collectionView)
    ImageInGalleryCell.register(on: collectionView)
  }
}

extension GalleryVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.imagesSource.getImages().count + (self.imagesSource.thereIsMoreToLoad ? 1 : 0)
  }
  
  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if indexPath.row < self.imagesSource.getImages().count {
      let cell = ImageInGalleryCell.dequeue(from: collectionView, for: indexPath)
      let image = self.imagesSource.getImages()[indexPath.row]
      cell.setup(image)
      return cell
    } else {
      return LoadingMoreCollectionCell.dequeue(from: collectionView, for: indexPath)
    }
  }
  
  
  public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    if cell is LoadingMoreCollectionCell {
      self.imagesSource.loadMore { [unowned self] (result) in
        switch result {
        case .success(_): self.collectionView.reloadData()
        case .failure(_): break
        }
      }
    }
  }
}
