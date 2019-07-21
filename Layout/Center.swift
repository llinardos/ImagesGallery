import Foundation

public extension Layout {
  public enum CenterRelation {
    case horizontally
    case vertically
  }
  
  public func center(_ subview: UIView, _ relation: CenterRelation, in superview: UIView) {
    subview.translatesAutoresizingMaskIntoConstraints = false
    switch relation {
    case .horizontally:
      subview.centerXAnchor.constraint(equalTo: superview.centerXAnchor).isActive = true
    case .vertically:
      subview.centerYAnchor.constraint(equalTo: superview.centerYAnchor).isActive = true
    }
  }
  
  public func center(_ subview: UIView, in superview: UIView) {
    center(subview, .horizontally, in: superview)
    center(subview, .vertically, in: superview)
  }
  
}
