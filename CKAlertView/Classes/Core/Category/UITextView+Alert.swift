//
//  UITextView+Alert.swift
//  Pods
//
//  Created by mac on 16/11/10.
//
//

import Foundation

extension UITextView {
    
    func ck_setText(string :CKAlertViewStringable? , isCenter :Bool = false) {
        if let string  = string as? String {
            self.text = string
        }
        else if let attributeString = string as? NSAttributedString {
            if isCenter {
                attributeString.ck_apply(align: .center)
            }
            self.attributedText = attributeString
        }
    }

}
