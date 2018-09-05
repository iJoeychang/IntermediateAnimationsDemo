
import UIKit

class WidgetCell: UITableViewCell {
  
  private var showsMore = false
  @IBOutlet weak var widgetHeight: NSLayoutConstraint!

  weak var tableView: UITableView?
  var toggleHeightAnimator: UIViewPropertyAnimator?
  
  @IBOutlet weak var widgetView: WidgetView!
  
  var owner: WidgetsOwnerProtocol? {
    didSet {
      if let owner = owner {
        widgetView.owner = owner
      }
    }
  }
  
  @IBAction func toggleShowMore(_ sender: UIButton) {

    self.showsMore = !self.showsMore

//    self.widgetHeight.constant = self.showsMore ? 230 : 130
//    self.tableView?.reloadData()
//
//    widgetView.expanded = showsMore
//    widgetView.reload()
    
    let animations = {
      self.widgetHeight.constant = self.showsMore ? 230 : 130
      if let tableView = self.tableView {
        // call beginUpdates() and endUpdates() on the table view. Doing this will ask all cells about their height and adjust the layout as needed. If any of your cells says it wants to be higher or shorter, UIKit will adjust its frame accordingly.
        tableView.beginUpdates()
        tableView.endUpdates()
        tableView.layoutIfNeeded()
        
      }
    }
    
    let textTransition = {
      UIView.transition(with: sender, duration: 0.25, options: .transitionCrossDissolve,// .transitionFlipFromTop
          animations: { sender.setTitle( self.showsMore ? "Show Less" : "Show More", for: .normal) }, completion: nil )
      
    }
    
    let spring = UISpringTimingParameters(mass: 30, stiffness: 1000, damping: 300, initialVelocity: CGVector(dx: 5, dy: 0))
    
    if let toggleHeightAnimator = toggleHeightAnimator,toggleHeightAnimator.isRunning {
      toggleHeightAnimator.pauseAnimation()
      toggleHeightAnimator.addAnimations(animations)
      toggleHeightAnimator.addAnimations(textTransition, delayFactor: 0.5)
      toggleHeightAnimator.continueAnimation(withTimingParameters: nil, durationFactor: 1.0)
    } else {
      toggleHeightAnimator = UIViewPropertyAnimator(duration: 0.0, timingParameters: spring)
      toggleHeightAnimator?.addAnimations(textTransition, delayFactor: 0.5)
      toggleHeightAnimator?.addAnimations(animations)
      toggleHeightAnimator?.startAnimation()
    }
    widgetView.expanded = showsMore
    widgetView.reload()
  }
}
