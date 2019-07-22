extension Layout {
  public enum Size {
    case width, height
  }
  public func same(_ size: Size, for view: UIView, and otherView: UIView, ratio: CGFloat = 1.0) {
    view.translatesAutoresizingMaskIntoConstraints = false
    switch size {
    case .width: view.widthAnchor.constraint(equalTo: otherView.widthAnchor, multiplier: ratio).isActive = true
    case .height: view.heightAnchor.constraint(equalTo: otherView.heightAnchor, multiplier: ratio).isActive = true
    }
  }
  
  public func size(_ size: Size, of view: UIView, is constant: CGFloat) {
    switch size {
    case .width: view.widthAnchor.constraint(equalToConstant: constant).isActive = true
    case .height: view.heightAnchor.constraint(equalToConstant: constant).isActive = true
    }
  }
}
