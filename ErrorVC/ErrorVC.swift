import UIKit
import Layout

public class ErrorVC: UIViewController {
  public enum ErrorType {
    case noConnection(Error?)
    case unknown(Error?)
    case unautorized(Error?)
  }
  
  private lazy var label = UILabel()
  private lazy var dismissButton = UIButton()
  
  public static func presentModally(for error: ErrorType,
                             over vc: UIViewController,
                             onDismiss callback: @escaping () -> Void) {
    let errorVC = ErrorVC(error, onRetry: callback)
    vc.present(errorVC, animated: true, completion: nil)
  }
  
  private var onDismissCallback: () -> Void = { }
  public init(_ error: ErrorType, onRetry callback: @escaping () -> Void) {
    self.onDismissCallback = callback
    
    super.init(nibName: nil, bundle: nil)
    
    switch error {
    case .noConnection: label.text = "No internet connection."
    case .unautorized: label.text = "Not authorized."
    case .unknown: label.text = "Unexpected error."
    }
    
    dismissButton.setTitle("Dismiss", for: .normal)
    dismissButton.addTarget(self, action: #selector(onDismiss), for: .touchUpInside)
  }
  
  @objc func onDismiss() {
    self.onDismissCallback()
  }
  
  required init?(coder aDecoder: NSCoder) { return nil }
  
  public override func loadView() {
    super.loadView()
    
    view.backgroundColor = .white
    label.textAlignment = .center
    label.numberOfLines = 0
    
    dismissButton.setTitleColor(UIColor.black, for: .normal)
    
    let content = UIView()
    content.addSubview(label)
    content.addSubview(dismissButton)
    
    Layout().allign([.left, .right, .top], of: label, and: content)
    Layout().put(dismissButton, at: .bottom, of: label, spacing: 16)
    Layout().allign(.bottom, of: dismissButton, and: content)
    Layout().center(dismissButton, .horizontally, in: content)
    
    view.addSubview(content)
    Layout().center(content, in: view)
    Layout().allign(.left, of: content, and: view, toSafeArea: true)
  }
}
