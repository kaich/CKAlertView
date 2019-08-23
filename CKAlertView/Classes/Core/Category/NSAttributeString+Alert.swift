//
//  NSAttributeString+Alert.swift
//  Pods
//
//  Created by mac on 16/11/8.
//
//

import Foundation

public enum CKIndentStyle {
    case firstLine , headIndent , tailIndent
}


extension NSAttributedString : CKAlertViewStringable {
    
    public func ck_string() -> String {
        return string
    }
    
    public func ck_attributeString() -> NSAttributedString {
        return self
    }
    
    public func ck_apply(align : NSTextAlignment) -> NSAttributedString {
        
        let finalAttributes = self.attributes(at: 0, effectiveRange: nil)
        if let paragraphStyle = finalAttributes[NSAttributedString.Key.paragraphStyle] as? NSMutableParagraphStyle {
           paragraphStyle.alignment = align
        }
        
        return self
    }
    
    public func ck_apply(font :UIFont) -> NSAttributedString {
        let finalString :NSMutableAttributedString = NSMutableAttributedString(attributedString: self)
        finalString.addAttribute(NSAttributedString.Key.font, value: font, range: NSMakeRange(0, length))
        return finalString
    }
    
    public func ck_apply(color :UIColor) -> NSAttributedString {
        let finalString :NSMutableAttributedString = NSMutableAttributedString(attributedString: self)
        finalString.addAttribute(NSAttributedString.Key.foregroundColor, value:color, range:NSMakeRange(0, length));
        return finalString
    }
    
    public func ck_apply(indent :CGFloat , style :CKIndentStyle) -> NSAttributedString {
        let finalAttributes = self.attributes(at: 0, effectiveRange: nil)
        if let paragraphStyle = finalAttributes[NSAttributedString.Key.paragraphStyle] as? NSMutableParagraphStyle {
            switch style {
            case .firstLine:
                paragraphStyle.firstLineHeadIndent = indent
            case .headIndent:
                paragraphStyle.headIndent = indent
            case .tailIndent:
                paragraphStyle.tailIndent = indent
            }
        }
        
        return self
    }
    
    public func ck_apply(lineSpacing :CGFloat) -> NSAttributedString {
        let finalAttributes = self.attributes(at: 0, effectiveRange: nil)
        if let paragraphStyle = finalAttributes[NSAttributedString.Key.paragraphStyle] as? NSMutableParagraphStyle {
            paragraphStyle.lineSpacing = lineSpacing
        }
        return self
    }
    
}
