
import UIKit

class IconEffectView: UIVisualEffectView {

  convenience init(blur: UIBlurEffectStyle) {

    self.init(effect: UIBlurEffect(style: blur))

    clipsToBounds = true
    layer.cornerRadius = 16.0

    let label = UILabel()
    label.text = "Customize Actions..."
    label.font = UIFont.systemFont(ofSize: 16.0)
    label.sizeToFit()
    label.center = CGPoint(x: 90, y: 30)
    contentView.addSubview(label)
  }
}
