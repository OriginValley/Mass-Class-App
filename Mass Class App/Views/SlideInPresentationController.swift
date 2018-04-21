//
//  SlideInPresentationController.swift
//
//  Created by Christian Flanders on 3/10/18.
//

import UIKit

class SlideInPresentationController: UIPresentationController {

    fileprivate var dimmingView: UIView!

    fileprivate let fullAlpha: CGFloat = 1.0
    fileprivate let noAlpha: CGFloat = 1.0

    fileprivate let cardInsetFromTop: CGFloat = 60


    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {

        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        setupDimmingView()
    }

    override func presentationTransitionWillBegin() {
        containerView?.insertSubview(dimmingView, at: 0)

        NSLayoutConstraint.activate(
            NSLayoutConstraint.constraints(withVisualFormat: "V:|[dimmingView]|",
                                           options: [], metrics: nil, views: ["dimmingView": dimmingView]))
        NSLayoutConstraint.activate(
            NSLayoutConstraint.constraints(withVisualFormat: "H:|[dimmingView]|",
                                           options: [], metrics: nil, views: ["dimmingView": dimmingView]))

        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = fullAlpha
            return
        }

        coordinator.animate(alongsideTransition: { (_) in
            self.dimmingView.alpha = self.fullAlpha
        })
    }

    override func dismissalTransitionWillBegin() {
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = noAlpha
            return
        }

        coordinator.animate(alongsideTransition: { (_) in
            self.dimmingView.alpha = self.noAlpha
        })
    }

    override func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
    }

    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        return CGSize(width: parentSize.width, height: parentSize.height / 2)
    }

    override var frameOfPresentedViewInContainerView: CGRect {


        var frame: CGRect = .zero
        frame.size = size(forChildContentContainer: presentedViewController,
                          withParentContainerSize: containerView!.bounds.size)


        if #available(iOS 11.0, *) {
            frame.origin.y = containerView!.safeAreaInsets.bottom + (containerView?.frame.height)! / 2
        } else {
            frame.origin.y = containerView!.frame.minY + (containerView?.frame.minY)! + containerView!.frame.height / 2
        }

        return frame
    }



}

private extension SlideInPresentationController {

    func setupDimmingView() {
        dimmingView = UIView()
        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        dimmingView.alpha = noAlpha

        let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        dimmingView.addGestureRecognizer(recognizer)

    }

    @objc dynamic func handleTap(recognizer: UITapGestureRecognizer) {
        presentingViewController.dismiss(animated: true)
    }
}
