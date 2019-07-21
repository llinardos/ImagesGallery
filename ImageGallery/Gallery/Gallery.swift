import UIKit

public class GalleryVC: UIViewController {
  public init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) { return nil }
  
  public override func loadView() {
    super.loadView()
    self.view.backgroundColor = UIColor.black
  }
}
