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
}
