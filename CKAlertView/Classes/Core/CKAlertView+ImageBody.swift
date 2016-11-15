//
//  CKAlertView+Image.swift
//  Pods
//
//  Created by mac on 16/10/11.
//
//

import Foundation

public extension CKAlertView {
   
    
    ///  显示图片作为弹出框主体的弹出框
    ///
    /// - parameter alertTitle:       标题
    /// - parameter bodyImage:        主体图片
    /// - parameter cancelButtonTitle: 取消按钮标题
    /// - parameter otherButtonTitles: 其他按钮标题
    /// - parameter completeBlock:     点击按钮后的回调
    public convenience init(title alertTitle :CKAlertViewStringable, image bodyImage :UIImage?, cancelButtonTitle :CKAlertViewStringable, otherButtonTitles :[CKAlertViewStringable]? = nil, completeBlock :(((Int) -> Void))? = nil) {
        self.init(nibName: nil, bundle: nil)
        
        dismissCompleteBlock = completeBlock
        
        let componentMaker = CKAlertViewComponentImageBodyMaker()
        componentMaker.alertTitle = alertTitle
        componentMaker.alertBodyImage = bodyImage
        componentMaker.cancelButtonTitle = cancelButtonTitle
        componentMaker.otherButtonTitles = otherButtonTitles
        
        installComponentMaker(maker: componentMaker)
    }
    
}

class CKAlertViewImageBodyView: CKAlertViewBodyView {
    var image :UIImage?
    
    override func makeLayout() {
        let ivBody = UIImageView()
        self.addSubview(ivBody)
        ivBody.image = image
        ivBody.snp.makeConstraints { (make) in
            make.top.right.bottom.left.equalTo(self).inset(0)
        }
    }
}


class CKAlertViewComponentImageBodyMaker :CKAlertViewComponentMaker {
    var alertBodyImage :UIImage?
    
    override func makeHeader() -> CKAlertViewComponent? {
        let headerView = super.makeHeader()
        headerView?.textFont = UIFont.systemFont(ofSize: 15)
        
        return headerView
    }
    
    override func makeBody() -> CKAlertViewComponent? {
        let bodyView = CKAlertViewImageBodyView()
        bodyView.image = alertBodyImage
        
        return bodyView
    }
    
}
