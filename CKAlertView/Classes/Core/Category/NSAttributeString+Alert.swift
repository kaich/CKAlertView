//
//  NSAttributeString+Alert.swift
//  Pods
//
//  Created by mac on 16/11/8.
//
//

import Foundation

extension NSAttributedString : CKAlertViewStringable {
    
    public func ck_string() -> String {
        return string
    }
    
    public func ck_attributeString() -> NSAttributedString {
        return self
    }
    
    func ck_centerAlign() -> NSAttributedString {
        
        let finalAttributes = self.attributes(at: 0, effectiveRange: nil)
        if let paragraphStyle = finalAttributes[NSParagraphStyleAttributeName] as? NSMutableParagraphStyle {
           paragraphStyle.alignment = .center
        }
        
        return self
    }
}
