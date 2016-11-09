//
//  UIButton+Alert.swift
//  Pods
//
//  Created by mac on 16/11/9.
//
//

import Foundation

extension UIButton {
    
    func ck_setText(string :CKAlertViewStringable? , isCenter :Bool = true , state :UIControlState = .normal) {
        
        if let string  = string as? String {
            setTitle(string, for: state)
        }
        else if let attributeString = string as? NSAttributedString {
            if isCenter {
                attributeString.ck_apply(align: .center)
            }
            setAttributedTitle(attributeString, for: state)
        }
    }
    
}
