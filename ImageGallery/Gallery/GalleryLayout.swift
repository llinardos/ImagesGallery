class ColumnsCollectionViewLayout: UICollectionViewFlowLayout {
  private var numberOfColumns: Int
  
  init(margins: CGFloat, numberOfColumns: Int) {
    self.numberOfColumns = numberOfColumns
    
    super.init()
    
    self.scrollDirection = .vertical
    self.minimumLineSpacing = margins
    self.minimumInteritemSpacing = margins
    self.sectionInset = UIEdgeInsets(top: margins/2.0, left: margins/2.0, bottom: margins/2.0, right: margins/2.0)
  }
  
  required init?(coder aDecoder: NSCoder) { return nil }
  
  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let layout = collectionViewLayout as! UICollectionViewFlowLayout
    var size = CGSize(width: 0.0, height: 0.0)
    var availableWidth = collectionView.frame.width
    availableWidth -= CGFloat(numberOfColumns - 1)*layout.minimumInteritemSpacing
    size.width = availableWidth/CGFloat(numberOfColumns)
    size.height = size.width
    return size
  }
}
