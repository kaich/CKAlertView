//
//  UILabel+Alert.swift
//  Pods
//
//  Created by mac on 16/11/8.
//
//

import Foundation

extension UILabel {
    
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
