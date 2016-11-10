//
//  CKAlertViewStringProtocol.swift
//  Pods
//
//  Created by mac on 16/11/8.
//
//

import Foundation

public protocol CKAlertViewStringable {
   
    func ck_string() -> String
    
    func ck_attributeString() -> NSAttributedString
    
    func ck_apply(align : NSTextAlignment) -> NSAttributedString
    
    func ck_apply(font :UIFont) -> NSAttributedString
    
    func ck_apply(color :UIColor) -> NSAttributedString
    
    func ck_apply(indent :CGFloat , style :CKIndentStyle) -> NSAttributedString
}
