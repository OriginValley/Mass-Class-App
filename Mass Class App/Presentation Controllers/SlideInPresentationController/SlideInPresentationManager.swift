//
//  SlideInPresentationManager.swift
//
//  Created by Christian Flanders on 3/10/18.
//

import UIKit


class SlideInPresentationManager: NSObject {


}

extension SlideInPresentationManager: UIViewControllerTransitioningDelegate {

  func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
    let presentationController = SlideInPresentationController(presentedViewController: presented, presenting: presenting)
    return presentationController
  }

  func animationController(forPresented presented: UIViewController,
                           presenting: UIViewController,
                           source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return SlideInPresentationAnimator(isPresentation: true)
  }

  func animationController(forDismissed dismissed: UIViewController)
    -> UIViewControllerAnimatedTransitioning? {
      return SlideInPresentationAnimator(isPresentation: false)
  }

}
