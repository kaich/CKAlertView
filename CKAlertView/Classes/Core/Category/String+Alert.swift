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
    
    /// 简单的给文字赋予颜色
    ///
    /// - parameter color: 颜色
    ///
    /// - returns: NSMutableAttributedString
    public func ck_attributeString() -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3
        paragraphStyle.alignment = .left
        
        let attrString = NSMutableAttributedString(string: self)
        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        
        return attrString
    }
    
    
    public func ck_apply(align : NSTextAlignment) -> NSAttributedString {
        return ck_attributeString().ck_apply(align: align)
    }
    
    public func ck_apply(font :UIFont) -> NSAttributedString {
        return ck_attributeString().ck_apply(font: font)
    }
    
    public func ck_apply(color :UIColor) -> NSAttributedString {
        return ck_attributeString().ck_apply(color: color)
    }
    
    public func ck_apply(indent :CGFloat , style :CKIndentStyle) -> NSAttributedString {
        return ck_attributeString().ck_apply(indent: indent, style: style)
    }
}
