import UIKit
import Layout

public class GalleryVC: UIViewController {
  private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
  
  public init() {
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
  }
}

extension GalleryVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 1
  }
  
  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = LoadingMoreCollectionCell.dequeue(from: collectionView, for: indexPath)
    return cell
  }
}
