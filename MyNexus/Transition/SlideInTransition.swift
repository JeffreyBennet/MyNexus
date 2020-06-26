
import UIKit
import Foundation

class SlideinTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    var isPresenting = true
    let dimmingView = UIView()

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        guard let toViewController = transitionContext.viewController(forKey: .to),
              let fromViewController = transitionContext.viewController(forKey: .from) else { return }
        let containerView = transitionContext.containerView

        let finalWidth = toViewController.view.bounds.width * 0.8
        let finalHeight = toViewController.view.bounds.height

        if isPresenting {
            let tapGesture = UITapGestureRecognizer(target: toViewController, action: #selector(UIViewController.dismissControllerAnimated))
            dimmingView.addGestureRecognizer(tapGesture)

            //adds the dimming view
            dimmingView.backgroundColor = .black
            dimmingView.alpha = 0.0
            containerView.addSubview(dimmingView)
            dimmingView.frame = containerView.bounds
            //adds the menu view controller to our container
            containerView.addSubview(toViewController.view)

            //init frame off the screen
            toViewController.view.frame = CGRect(x: -finalWidth, y: 0, width: finalWidth, height: finalHeight)
        }

        let transform = {
            self.dimmingView.alpha = 0.5
            toViewController.view.transform = CGAffineTransform(translationX: finalWidth, y: 0)
        }

        let identity = {
            self.dimmingView.alpha = 0.0
            fromViewController.view.transform = .identity
        }

        //animates the transition
        let duration = transitionDuration(using: transitionContext)
        let isCancelled = transitionContext.transitionWasCancelled
        UIView.animate(withDuration: duration, animations: {
            self.isPresenting ? transform() : identity()
        }) { (_) in
            transitionContext.completeTransition(!isCancelled)
            if !self.isPresenting {
                self.dimmingView.removeFromSuperview()
            }
        }
    }
}
