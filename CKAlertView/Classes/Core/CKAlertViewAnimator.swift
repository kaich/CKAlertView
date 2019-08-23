//
//  CKAlertViewAnimator.swift
//  Pods
//
//  Created by mac on 17/2/9.
//
//

import UIKit

public protocol CKAlertViewAnimatable {
    init(alertView :CKAlertView?)
    var alertView :CKAlertView? {get}
    
    /// 显示动画
    ///
    /// - Parameter completeBlock: 动画结束回调
    func show(completeBlock :(() -> ())?)
    
    /// 消失动画
    ///
    /// - Parameter completeBlock: 动画结束回调
    func dismiss(completeBlock :(() -> ())?)
    
}

//MARK: - 动画效果

/// 弹簧缩放
public class CKAlertViewSpringAnimator: CKAlertViewAnimatable {
    public var alertView :CKAlertView?
    
    required public init(alertView: CKAlertView?) {
        self.alertView = alertView
    }
    
    public func show(completeBlock :(() -> ())?) {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.65, initialSpringVelocity: 1, options: .curveLinear, animations: {
            if let alertView = self.alertView {
                alertView.view.alpha = 1
                alertView.containerView.layoutIfNeeded()
            }
        }) { _ in
            if let completeBlock = completeBlock {
                completeBlock()
            }
        }
    }
    
    public func dismiss(completeBlock: (() -> ())?) {
        UIView.animate(withDuration: 0.3, animations: {
            if let alertView = self.alertView {
                alertView.view.alpha = 0
            }
        }) { (_) in
            if let completeBlock = completeBlock {
                completeBlock()
            }
        }
    }
}


/// 波纹
public class CKAlertViewRippleAnimator: NSObject, CKAlertViewAnimatable, CAAnimationDelegate {
    public var alertView: CKAlertView?
    var isAnimating = false
    
    required public init(alertView: CKAlertView?) {
        self.alertView = alertView
    }
    
    public func show(completeBlock :(() -> ())?) {
        guard isAnimating == false else {
            return
        }
        if let containerView = alertView?.containerView , let overlayView = alertView?.overlayView{
            containerView.layoutIfNeeded()
            overlayView.layer.opacity = 1
            
            let maskWidth = sqrt(pow(containerView.bounds.height, 2) + pow(containerView.bounds.width, 2))
            let maskLayer = CALayer()
            maskLayer.frame = CGRect(x: 0, y: 0, width: maskWidth, height: maskWidth)
            maskLayer.cornerRadius = maskWidth / 2
            maskLayer.backgroundColor = UIColor.white.cgColor
            maskLayer.position = CGPoint(x: containerView.frame.width / 2 , y: containerView.frame.height / 2)
            alertView?.containerView.layer.mask = maskLayer
            
            CATransaction.begin()
            isAnimating = true
            
            CATransaction.setCompletionBlock({
                self.isAnimating = false
                if let completeBlock = completeBlock {
                    completeBlock()
                }
            })
            
            let scaleRate = 20.0 / maskWidth
            let containerAnimation = CABasicAnimation(keyPath: "transform.scale")
            containerAnimation.fromValue = scaleRate
            containerAnimation.toValue = 1
            containerAnimation.duration = 0.3
            containerAnimation.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
            maskLayer.add(containerAnimation, forKey: "scale")
            
            let overlayAnimation = CABasicAnimation(keyPath: "opacity")
            overlayAnimation.fromValue = 0
            overlayAnimation.toValue = 1
            overlayAnimation.duration = 0.3
            overlayView.layer.add(overlayAnimation, forKey: "opacity")
            
            CATransaction.commit()
            
        }
    }
    
    public func dismiss(completeBlock: (() -> ())?) {
        guard isAnimating == false else {
            return
        }
        if let _ = alertView?.containerView , let overlayView = alertView?.overlayView, let maskLayer = alertView?.containerView.layer.mask {
            overlayView.layer.opacity = 0
            
            let scaleRate :CGFloat = 0.0
            maskLayer.transform = CATransform3DMakeScale(scaleRate, scaleRate, 1)
            
            CATransaction.begin()
            isAnimating = true
            
            CATransaction.setCompletionBlock({
                self.isAnimating = false
                if let completeBlock = completeBlock {
                    completeBlock()
                }
            })
            
            let containerAnimation = CABasicAnimation(keyPath: "transform.scale")
            containerAnimation.fromValue = 1
            containerAnimation.toValue = scaleRate
            containerAnimation.duration = 0.3
            containerAnimation.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
            maskLayer.add(containerAnimation, forKey: "scale")
            
            let overlayAnimation = CABasicAnimation(keyPath: "opacity")
            overlayAnimation.fromValue = 1
            overlayAnimation.toValue = 0
            overlayAnimation.duration = 0.3
            overlayView.layer.add(overlayAnimation, forKey: "opacity")
            
            CATransaction.commit()
        }
        
    }
    
}

//落下
public class CKAlertDropDownAnimator: NSObject, CKAlertViewAnimatable {
    public var alertView: CKAlertView?
    lazy var animator: UIDynamicAnimator = {
        return UIDynamicAnimator(referenceView: (self.alertView?.view)!)
    }()
    
    required public init(alertView: CKAlertView?) {
        self.alertView = alertView
    }
    
    public func show(completeBlock :(() -> ())?) {
        if let alert = alertView ,let containerView = alertView?.containerView , let overlayView = alertView?.overlayView, let view = alertView?.view {
            containerView.snp.remakeConstraints({ (make) in
                make.centerX.equalTo(view)
                make.bottom.equalTo(view.snp.top)
                if alert.config.isFixedContentWidth {
                    make.width.equalTo(alert.config.contentWidth)
                }
            })
            view.layoutIfNeeded()
            self.animator.removeAllBehaviors()
            
            let gravity = UIGravityBehavior(items: [containerView])
            gravity.magnitude = 6
            animator.addBehavior(gravity)
            
            let sreenHeight = UIScreen.main.bounds.height
            let bottom = (sreenHeight - containerView.bounds.height)/2
            let boundaryCollision = UICollisionBehavior(items: [containerView])
            boundaryCollision.setTranslatesReferenceBoundsIntoBoundary(with: UIEdgeInsets(top: -sreenHeight, left: 0, bottom: bottom, right: 0))
            animator.addBehavior(boundaryCollision)

            let bounce = UIDynamicItemBehavior(items: [containerView])
            bounce.elasticity = 0.4
            bounce.density = 200
            bounce.resistance = 2
            animator.addBehavior(bounce)
            
            UIView .animate(withDuration: 0.5, animations: { 
                overlayView.layer.opacity = 1
            }, completion: { (_) in
                if let completeBlock = completeBlock {
                    completeBlock()
                }
            })
            
        }
    }
    
    public func dismiss(completeBlock: (() -> ())?) {
        if let alert = alertView, let containerView = alertView?.containerView , let overlayView = alertView?.overlayView, let view = alertView?.view  {
            containerView.snp.remakeConstraints({ (make) in
                make.center.equalTo(view)
                if alert.config.isFixedContentWidth {
                    make.width.equalTo(alert.config.contentWidth)
                }
            })
            view.layoutIfNeeded()
            self.animator.removeAllBehaviors()
            
            let gravity = UIGravityBehavior(items: [containerView])
            gravity.magnitude = 4
            animator.addBehavior(gravity)
            
            UIView .animate(withDuration: 0.5, animations: {
                overlayView.layer.opacity = 0
            }, completion: { (_) in
                if let completeBlock = completeBlock {
                    completeBlock()
                }
            })
            
 
        }
        
    }
    
}
