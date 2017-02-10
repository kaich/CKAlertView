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
    func show(completeBlock :((Void) -> Void)?)
    
    /// 消失动画
    ///
    /// - Parameter completeBlock: 动画结束回调
    func dismiss(completeBlock :((Void) -> Void)?)
    
}

//MARK: - 动画效果

/// 弹簧缩放
class CKAlertViewSpringAnimator: CKAlertViewAnimatable {
    var alertView :CKAlertView?
    
    required init(alertView: CKAlertView?) {
        self.alertView = alertView
    }
    
    func show(completeBlock :((Void) -> Void)?) {
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
    
    func dismiss(completeBlock: ((Void) -> Void)?) {
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
class CKAlertViewRippleAnimator: NSObject, CKAlertViewAnimatable, CAAnimationDelegate {
    var alertView: CKAlertView?
    var isAnimating = false
    
    required init(alertView: CKAlertView?) {
        self.alertView = alertView
    }
    
    func show(completeBlock :((Void) -> Void)?) {
        guard isAnimating == false else {
            return
        }
        if let containerView = alertView?.containerView , let overlayView = alertView?.overlayView{
            containerView.layoutIfNeeded()
            overlayView.layer.opacity = 1
            
            let maskWidth = sqrt(pow(containerView.bounds.height, 2) + pow(containerView.bounds.width, 2))
            var maskLayer = CALayer()
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
            containerAnimation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
            maskLayer.add(containerAnimation, forKey: "scale")
            
            let overlayAnimation = CABasicAnimation(keyPath: "opacity")
            overlayAnimation.fromValue = 0
            overlayAnimation.toValue = 1
            overlayAnimation.duration = 0.3
            overlayView.layer.add(overlayAnimation, forKey: "opacity")
            
            CATransaction.commit()
            
        }
    }
    
    func dismiss(completeBlock: ((Void) -> Void)?) {
        guard isAnimating == false else {
            return
        }
        if let containerView = alertView?.containerView , let overlayView = alertView?.overlayView, let maskLayer = alertView?.containerView.layer.mask {
            overlayView.layer.opacity = 0
            
            let maskWidth = sqrt(pow(containerView.bounds.height, 2) + pow(containerView.bounds.width, 2))
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
            containerAnimation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseIn)
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
