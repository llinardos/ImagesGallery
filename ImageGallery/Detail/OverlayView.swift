import UIKit
import Layout

class OverlayView: UIView {
  private let line1 = UILabel()
  private let line2 = UILabel()
  private let shareButton = UIButton(type: .custom)
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    line1.font = UIFont.systemFont(ofSize: 18, weight: .medium)
    line1.textColor = UIColor.white
    line1.numberOfLines = 1
    line1.lineBreakMode = .byTruncatingTail
    
    line2.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    line2.textColor = UIColor.white
    line2.numberOfLines = 1
    line2.lineBreakMode = .byTruncatingTail
    
    let image = UIImage(named: "share_icon", in: Bundle(for: OverlayView.self), compatibleWith: nil)
    shareButton.setImage(image, for: .normal)
    Layout().size(.width, of: shareButton, is: 44.0)
    Layout().size(.height, of: shareButton, is: 44.0)
    
    let lines = UIStackView(arrangedSubviews: [line1, line2])
    lines.alignment = .leading
    lines.axis = .vertical
    lines.spacing = 4
    
    let content = UIStackView(arrangedSubviews: [lines, shareButton])
    content.alignment = .center
    content.axis = .horizontal
    
    addSubview(content)
    Layout().allign(.all, of: content, and: self, toSafeArea: true, insets: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
    
    shareButton.addTarget(self, action: #selector(onShareButtonTap), for: .touchUpInside)
    
    let bg = UIView()
    bg.backgroundColor = UIColor.black
    bg.alpha = 0.7
    addSubview(bg)
    sendSubviewToBack(bg)
    Layout().allign(.all, of: bg, and: self)
  }
  
  func setLines(_ line1: String, _ line2: String) {
    self.line1.text = line1
    self.line2.text = line2
  }
  
  @objc private func onShareButtonTap() {
    self.onShare()
  }
  
  var onShare: () -> Void = {}
  
  required init?(coder aDecoder: NSCoder) { return nil }
}
