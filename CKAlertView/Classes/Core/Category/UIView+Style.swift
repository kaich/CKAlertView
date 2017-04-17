//
//  UIView+Style.swift
//  Pods
//
//  Created by mac on 2017/4/15.
//
//

import Foundation

extension UIView {
    
    func setBorder(_ style :CKBorderStyle) {
        layer.borderColor = style.color.cgColor
        layer.borderWidth = style.width
    }
    
}
