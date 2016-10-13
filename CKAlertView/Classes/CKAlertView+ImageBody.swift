//
//  CKAlertView+Image.swift
//  Pods
//
//  Created by mac on 16/10/11.
//
//

import Foundation

extension CKAlertView {
   
    
    ///  显示图片作为弹出框主体的弹出框
    ///
    /// - parameter alertTitle:       标题
    /// - parameter bodyImage:        主体图片
    /// - parameter cancelButtonTitle: 取消按钮标题
    /// - parameter otherButtonTitles: 其他按钮标题
    /// - parameter completeBlock:     点击按钮后的回调
    public func show(title alertTitle :String, image bodyImage :UIImage?, cancelButtonTitle :String, otherButtonTitles :[String]? = nil, completeBlock :(((Int) -> Void))? = nil) {
        
        dismissCompleteBlock = completeBlock
        
        let componentMaker = CKAlertViewComponentImageBodyMaker()
        componentMaker.delegate = self
        componentMaker.alertTitle = alertTitle
        componentMaker.alertBodyImage = bodyImage
        componentMaker.cancelButtonTitle = cancelButtonTitle
        componentMaker.otherButtonTitles = otherButtonTitles
        componentMaker.makeLayout()
        self.componentMaker = componentMaker
        
        showImageBodyAlert()
    }
    
    func showImageBodyAlert() {
        let ownWindow = UIApplication.shared.keyWindow! as UIWindow
        ownWindow.addSubview(view)
        
        self.view.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.view.alpha = 1
            self.contentView.layoutIfNeeded()
        }
        
    }
    
}

class CKAlertViewImageBodyView: CKAlertViewBodyView {
    var image :UIImage?
    
    override func makeLayout() {
        let ivBody = UIImageView(image: image)
        ivBody.backgroundColor = UIColor.red
        self.addSubview(ivBody)
        ivBody.snp.makeConstraints { (make) in
            make.top.right.bottom.left.equalTo(self)
        }
    }
}


class CKAlertViewComponentImageBodyMaker :CKAlertViewComponentMaker {
    var alertBodyImage :UIImage?
    
    override func layoutHeader() -> CKAlertViewComponent? {
        let headerView = super.layoutHeader()
        headerView?.textFont = UIFont.systemFont(ofSize: 15)
        
        return headerView
    }
    
    override func layoutBody() -> CKAlertViewComponent? {
        let bodyView = CKAlertViewImageBodyView()
        bodyView.image = alertBodyImage
        
        return bodyView
    }
    
}
