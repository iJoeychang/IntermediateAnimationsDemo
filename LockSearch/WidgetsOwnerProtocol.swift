
import UIKit

protocol WidgetsOwnerProtocol {
  var blurView: UIVisualEffectView {get}

  func startPreview(for: UIView)
  func updatePreview(percent: CGFloat)
  func finishPreview()
  func cancelPreview()
}

extension WidgetsOwnerProtocol {
  func startPreview(for forView: UIView) { }
  func updatePreview(percent: CGFloat) { }
  func finishPreview() { }
  func cancelPreview() { }
}
