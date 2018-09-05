
import UIKit

class FooterCell: UITableViewCell {

  var didPressEdit: (()->Void)?

  @IBAction func edit() {
    didPressEdit?()
  }
  
  
  
}
