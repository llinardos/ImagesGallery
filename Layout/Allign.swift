extension Layout {
  public enum Side {
    case left, right, top, bottom
  }
  
  public enum Sides {
    case all
  }
  
  public func allign(_ side: Side, of subview: UIView, and superview: UIView, toSafeArea: Bool = false, offset: CGFloat = 0.0) {
    subview.translatesAutoresizingMaskIntoConstraints = false
    if toSafeArea {
      switch side {
      case .bottom: subview.bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor, constant: -offset).isActive = true
      case .top: subview.topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor, constant: offset).isActive = true
      case .left: subview.leadingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.leadingAnchor, constant: offset).isActive = true
      case .right: subview.trailingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.trailingAnchor, constant: -offset).isActive = true
      }
    } else {
      switch side {
      case .bottom: subview.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -offset).isActive = true
      case .top: subview.topAnchor.constraint(equalTo: superview.topAnchor, constant: offset).isActive = true
      case .left: subview.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: offset).isActive = true
      case .right: subview.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -offset).isActive = true
      }
    }
  }
  
  public func allign(_ sides: [Side], of subview: UIView, and superview: UIView, toSafeArea: Bool = false, insets: UIEdgeInsets = .zero) {
    sides.forEach {
      switch $0 {
      case .top: allign(.top, of: subview, and: superview, toSafeArea: toSafeArea, offset: insets.top)
      case .bottom: allign(.bottom, of: subview, and: superview, toSafeArea: toSafeArea, offset: insets.bottom)
      case .left: allign(.left, of: subview, and: superview, toSafeArea: toSafeArea, offset: insets.left)
      case .right: allign(.right, of: subview, and: superview, toSafeArea: toSafeArea, offset: insets.right)
      }
    }
  }
  
  public func allign(_ sides: Sides, of subview: UIView, and superview: UIView, toSafeArea: Bool = false, insets: UIEdgeInsets = .zero) {
    switch sides {
    case .all:
      allign([.left, .right, .top, .bottom], of: subview, and: superview, toSafeArea: toSafeArea, insets: insets)
    }
  }
  
}
