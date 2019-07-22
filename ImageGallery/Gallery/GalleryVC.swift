import UIKit
import Layout
import ErrorVC

public class GalleryVC: UIViewController {
  private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
  private var imagesSource: ImagesSource
  private var layout = ByDeviceOrientationColumnsCollectionViewLayout()
  
  public init(imagesSource: ImagesSource) {
    self.imagesSource = imagesSource
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) { return nil }
  
  public var didSelectImage: (Image) -> Void = { _ in }
  
  public override func loadView() {
    super.loadView()
    self.view.backgroundColor = UIColor.black
    
    self.view.addSubview(collectionView)
    Layout().allign(.all, of: self.collectionView, and: self.view, toSafeArea: false, insets: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8))
    
    self.collectionView.backgroundView = UIView()
    self.collectionView.backgroundColor = UIColor.black
    self.collectionView.alwaysBounceVertical = true
    
    self.collectionView.delegate = self
    self.collectionView.dataSource = self
    self.collectionView.contentInsetAdjustmentBehavior = .always
    
    LoadingMoreCollectionCell.register(on: collectionView)
    ImageInGalleryCell.register(on: collectionView)
    
    layout.orientationChange()
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
        case .success:
          self.collectionView.reloadData()
        case .failure(let error):
          switch error {
          case .noConnection: self.presentError(.noConnection(error))
          case .unauthorized: self.presentError(.unautorized(error))
          case .unexpected: self.presentError(.unknown(error))
          }
        }
      }
    }
  }
  
  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return layout.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath)
  }
  
  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard indexPath.row < self.imagesSource.getImages().count else { return }
    let image = self.imagesSource.getImages()[indexPath.row]
    didSelectImage(image)
  }
  
  public override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  private func presentError(_ error: ErrorVC.ErrorType) {
    ErrorVC.presentModally(for: error, over: self, onDismiss: { [unowned self] in
      self.dismiss(animated: true, completion: nil)
    })
  }
}

extension GalleryVC {
  public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    self.layout.orientationChange()
    self.layout.invalidateLayout()
  }
}
