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
    
}
