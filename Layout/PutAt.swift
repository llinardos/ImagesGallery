extension Layout {
  public enum Position {
    case top, bottom, leading, trailing
  }
  public func put(_ view: UIView, at position: Position, of otherview: UIView, spacing: CGFloat = 0.0) {
    view.translatesAutoresizingMaskIntoConstraints = false
    otherview.translatesAutoresizingMaskIntoConstraints = false
    
    switch position {
    case .top: view.bottomAnchor.constraint(equalTo: otherview.topAnchor, constant: -spacing).isActive = true
    case .bottom: view.topAnchor.constraint(equalTo: otherview.bottomAnchor, constant: spacing).isActive = true
    case .leading: view.trailingAnchor.constraint(equalTo: otherview.leadingAnchor, constant: spacing).isActive = true
    case .trailing: view.leadingAnchor.constraint(equalTo: otherview.trailingAnchor, constant: -spacing).isActive = true
    }
  }
}
