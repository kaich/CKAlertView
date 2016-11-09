//
//  String+Alert.swift
//  Pods
//
//  Created by mac on 16/11/8.
//
//

import Foundation

extension String : CKAlertViewStringable {
    
    public func ck_string() -> String {
        return self
    }
    
    public func ck_attributeString() -> NSAttributedString {
       return ck_attributeString(color: nil)
    }
    
    /// 简单的给文字赋予颜色
    ///
    /// - parameter color: 颜色
    ///
    /// - returns: NSMutableAttributedString
    public func ck_attributeString(color :UIColor? = nil) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3
        
        let attrString = NSMutableAttributedString(string: self)
        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        if let color = color {
            attrString.addAttribute(NSForegroundColorAttributeName, value:color, range:NSMakeRange(0, attrString.length));
        }
        
        return attrString
    }
}
