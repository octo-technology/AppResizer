import UIKit

class ResizingWindow: UIWindow {
  struct Constants {
    static let backgroundColor = UIColor(red: 0.56, green: 0.35, blue: 0.71, alpha: 1.0)
    static let defaultMargin = CGFloat(8)
    static let animationDuration = Double(0.3)
  }
  var windowDidRotate:((_ size: CGSize) -> Void)?
  var resizingValueDidChange:((_ size: CGSize) -> Void)?
  var descriptionLabel: UILabel!

  func shouldAnimate() -> Bool {
    return false
  }

  func enable() { }
  func updateView() { }
}
