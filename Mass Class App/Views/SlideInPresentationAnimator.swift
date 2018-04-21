//
//  SlideInPresentationAnimator.swift
//
//  Created by Christian Flanders on 3/10/18.
//

import UIKit




class SlideInPresentationAnimator: NSObject {


    let isPresentation: Bool
    init( isPresentation:Bool) {
        self.isPresentation = isPresentation
        super.init()
    }


}

extension SlideInPresentationAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        let animationDuration = 0.3
        return animationDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        let key = isPresentation ? UITransitionContextViewControllerKey.to : UITransitionContextViewControllerKey.from // If a view is being presented for the first time, get that key. if not, it's the from controller so get it's key

        let controller = transitionContext.viewController(forKey: key)! // Get a reference to the controller

        if isPresentation {
            transitionContext.containerView.addSubview(controller.view) // If being presented, add the view to the heirarchy
        }

        let presentedFrame = transitionContext.finalFrame(for: controller)
        var dismissedFrame = presentedFrame

        dismissedFrame.origin.y = transitionContext.containerView.frame.size.height

        let initialFrame = isPresentation ? dismissedFrame : presentedFrame
        let finalFrame = isPresentation ? presentedFrame : dismissedFrame

        let fromKey = isPresentation ? UITransitionContextViewControllerKey.from : UITransitionContextViewControllerKey.to

        let fromController = transitionContext.viewController(forKey: fromKey)!

        let animationDuration = transitionDuration(using: transitionContext)

        let bottomCardDesiredRadius: CGFloat = isPresentation ? 20.0 : 0.0
        controller.view.frame = initialFrame


        if isPresentation {
            UIApplication.shared.statusBarStyle = .lightContent
        } else {
            UIApplication.shared.statusBarStyle = .default
        }

        let presenterDesiredScale: CGFloat = isPresentation ? 0.89 : 1.0

        UIView.animate(withDuration: animationDuration, animations: {

            controller.view.frame = finalFrame

            if #available(iOS 11.0, *) {
                controller.view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
                controller.view.layer.cornerRadius = bottomCardDesiredRadius
            } else {
                let maskPath = UIBezierPath(roundedRect: controller.view.bounds,
                                            byRoundingCorners: [.topLeft, .topRight],
                                            cornerRadii: CGSize(width: bottomCardDesiredRadius, height: bottomCardDesiredRadius))

                let shape = CAShapeLayer()
                shape.path = maskPath.cgPath
                controller.view.layer.mask = shape
            }

            fromController.view.subviews.first?.layer.cornerRadius = bottomCardDesiredRadius
//            fromController.view.transform = CGAffineTransform(scaleX: presenterDesiredScale, y: presenterDesiredScale)

        }) { finished in
            transitionContext.completeTransition(finished)
        }



    }


}
