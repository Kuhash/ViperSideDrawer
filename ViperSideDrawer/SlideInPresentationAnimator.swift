//
//  SlideInPresentationAnimator.swift
//  ViperSideDrawer
//
//  Created by Aleksander Maj on 29/06/2017.
//  Copyright © 2017 Aleksander Maj. All rights reserved.
//

import UIKit

final class SlideInPresentationAnimator: NSObject {

    // MARK: - Properties
    let direction: PresentationDirection
    let isPresentation: Bool

    init(direction: PresentationDirection, isPresentation: Bool) {
        self.direction = direction
        self.isPresentation = isPresentation
        super.init()
    }
}

// MARK: - UIViewControllerAnimatedTransitioning
extension SlideInPresentationAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let parentVCKey = isPresentation ? UITransitionContextViewControllerKey.from : UITransitionContextViewControllerKey.to
        let childVCKey = isPresentation ? UITransitionContextViewControllerKey.to : UITransitionContextViewControllerKey.from

        let parentVC = transitionContext.viewController(forKey: parentVCKey)!
        let childVC = transitionContext.viewController(forKey: childVCKey)!

        if isPresentation {
            transitionContext.containerView.addSubview(childVC.view)
        }

        let childPresentedFrame = transitionContext.finalFrame(for: childVC)
        var childDismissedFrame = childPresentedFrame

        let parentDismissedFrame = transitionContext.finalFrame(for: parentVC)
        var parentPresentedFrame =  parentDismissedFrame


        switch direction {
        case .left:
            childDismissedFrame.origin.x = -childPresentedFrame.width
            parentPresentedFrame.origin.x = childPresentedFrame.width
        case .right:
            childDismissedFrame.origin.x = transitionContext.containerView.frame.size.width
            parentPresentedFrame.origin.x = -childPresentedFrame.width
        }

        let childInitialFrame = isPresentation ? childDismissedFrame : childPresentedFrame
        let childFinalFrame = isPresentation ? childPresentedFrame : childDismissedFrame
        let parentInitialFrame = isPresentation ? parentDismissedFrame : parentPresentedFrame
        let parentFinalFrame = isPresentation ? parentPresentedFrame : parentDismissedFrame

        let animationDuration = transitionDuration(using: transitionContext)
        childVC.view.frame = childInitialFrame
        //parentVC.view.frame = parentInitialFrame

        UIView.animate(withDuration: animationDuration, animations: {
            childVC.view.frame = childFinalFrame
            //parentVC.view.frame = parentFinalFrame
        }) { (finished) in
            transitionContext.completeTransition(finished)
        }
    }


}