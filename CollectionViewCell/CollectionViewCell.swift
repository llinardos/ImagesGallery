public protocol IdentificableCell: NSObject {
  static var reuseId: String { get }
}

public protocol RegistrableOnUICollectionView {
  static func register(on collectionView: UICollectionView)
}

public protocol DequeuebableFromUICollectionView {
  static func dequeue(from collectionView: UICollectionView, for indexPath: IndexPath) -> Self
}

public extension RegistrableOnUICollectionView where Self: IdentificableCell {
  static func register(on collectionView: UICollectionView) {
    collectionView.register(Self.self, forCellWithReuseIdentifier: self.reuseId)
  }
}

public extension DequeuebableFromUICollectionView where Self: IdentificableCell {
  static func dequeue(from collectionView: UICollectionView, for indexPath: IndexPath) -> Self {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuseId, for: indexPath)
    return cell as! Self
  }
}

public extension IdentificableCell {
  static var reuseId: String { return String(describing: Self.self) }
}
