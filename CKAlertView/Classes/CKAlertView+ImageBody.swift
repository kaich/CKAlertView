//
//  CKAlertView+Image.swift
//  Pods
//
//  Created by mac on 16/10/11.
//
//

import Foundation

extension CKAlertView {
    
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
        let headerView = layoutHeader()
        headerView?.textFont = UIFont.systemFont(ofSize: 15)
        
        return headerView
    }
    
    override func layoutBody() -> CKAlertViewComponent? {
        let bodyView = CKAlertViewImageBodyView()
        bodyView.image = alertBodyImage
        
        return bodyView
    }
    
}
