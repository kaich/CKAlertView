//
//  CKAlertViewInteractiveAnimator.swift
//  Pods
//
//  Created by mac on 17/3/1.
//
//

import UIKit


public protocol CKAlertViewInteractive {
    init(alertView :CKAlertView?)
    var alertView :CKAlertView? {get}
    func setupAfterLoaded()
}


class CKAlertViewAttachmentInteractiveHandler: CKAlertViewInteractive {
    public var alertView :CKAlertView?
    
    fileprivate var containerView: UIView! {
        return self.alertView?.containerView
    }
    fileprivate var view: UIView! {
        return self.alertView?.view
    }
    
    fileprivate lazy var interactiveAnimator: UIDynamicAnimator = UIDynamicAnimator(referenceView: self.view)
    fileprivate lazy var panGesture: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleAttachmentGesture(_:)))
    fileprivate var attachmentBehavior: UIAttachmentBehavior!
    
    required public init(alertView: CKAlertView?) {
        self.alertView = alertView
    }
    
    public func setupAfterLoaded() {
       view.addGestureRecognizer(panGesture)
    }
    
    @IBAction func handleAttachmentGesture(_ sender: UIPanGestureRecognizer) {
        
        let location = sender.location(in: view)
        let boxLocation = sender.location(in: containerView)
        
        switch sender.state {
        case .began:
            
            interactiveAnimator.removeAllBehaviors()
            
            let centerOffset = UIOffset(horizontal: boxLocation.x - containerView.bounds.midX, vertical: boxLocation.y - containerView.bounds.midY)
            attachmentBehavior = UIAttachmentBehavior(item: containerView, offsetFromCenter: centerOffset, attachedToAnchor: location)
            interactiveAnimator.addBehavior(attachmentBehavior)
            
        case .ended:
            
            interactiveAnimator.removeAllBehaviors()
            resetState()
            
        default:
            attachmentBehavior.anchorPoint = location
            
            break
        }
    }
    
    func resetState() {
        interactiveAnimator.removeAllBehaviors()
        
        UIView.animate(withDuration: 0.45, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.containerView.center = self.view.center
            self.containerView.transform = CGAffineTransform.identity
        }) { (_) in
            
        }
    }
    
}
