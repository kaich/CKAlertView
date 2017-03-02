//
//  CKForceGestureRecognizer.swift
//  Pods
//
//  Created by mac on 17/3/1.
//
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

@available(iOS 9.0, *)
public class CKForceGestureRecognizer: UIPanGestureRecognizer {
    
    public var thresholdForce :CGFloat = 3
    public var isForceEnd = false
    public var forceValue: CGFloat = 0
    public var maxValue: CGFloat!
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        handleForceWithTouches(touches: touches)
        isForceEnd = false
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        handleForceWithTouches(touches: touches)
        if forceValue > thresholdForce {
            isForceEnd = true
            state = .ended
        }
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        handleForceWithTouches(touches: touches)
    }
    
    func handleForceWithTouches(touches: Set<UITouch>) {
        
        //only do something is one touch is received
        if touches.count != 1 {
            state = .failed
            return
        }
        
        //check if touch is valid, otherwise set state to failed and return
        guard let touch = touches.first else {
            state = .failed
            return
        }
        
        //if everything is ok, set our variables.
        forceValue = touch.force
        maxValue = touch.maximumPossibleForce
    }
    
    //This is called when our state is set to .ended.
    public override func reset() {
        super.reset()
        forceValue = 0.0
    }
}
