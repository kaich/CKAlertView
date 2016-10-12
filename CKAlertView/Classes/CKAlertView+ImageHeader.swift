//
//  CKAlertView+ImageHeader.swift
//  Pods
//
//  Created by mac on 16/10/11.
//
//

import Foundation

extension CKAlertView {
    
    public func show(image headerImage :UIImage?, title alertTitle :String?, message alertMessage :String, cancelButtonTitle :String, otherButtonTitles :[String]? = nil, completeBlock :(((Int) -> Void))? = nil) {
        dismissCompleteBlock = completeBlock
        
        let componentMaker = CKAlertViewComponentAdditionImageHeaderMaker()
        componentMaker.delegate = self
        componentMaker.alertTitle = alertTitle
        componentMaker.alertHeaderImage = headerImage
        componentMaker.alertMessage = alertMessage
        componentMaker.cancelButtonTitle = cancelButtonTitle
        componentMaker.otherButtonTitles = otherButtonTitles
        componentMaker.makeLayout()
        
        self.componentMaker = componentMaker
        
        show()
    }
    
}

class CKAlertViewAdditionImageHeaderView : CKAlertViewHeaderView {
    var headerImage :UIImage?
    
    override func makeLayout() {
        super.makeLayout()
        
        let titleLabel = subviews.first
        
        let ivIcon = UIImageView(image: headerImage)
        addSubview(ivIcon)
        
        ivIcon.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(20)
            make.centerX.equalTo(self)
        }
        
        if let titleLabel = titleLabel {
           titleLabel.snp.remakeConstraints({ (make) in
                make.top.equalTo(ivIcon.snp.bottom).offset(10)
                make.left.equalTo(self).offset(20)
                make.right.equalTo(self).offset(-20)
                make.bottom.equalTo(self).offset(-20)
           })
        }
        
    }
    
}

class CKAlertViewComponentAdditionImageHeaderMaker :CKAlertViewComponentMaker {
    var alertHeaderImage :UIImage?
    
    override func layoutHeader () {
        let headerView = CKAlertViewAdditionImageHeaderView()
        headerView.headerImage = alertHeaderImage
        headerView.alertTitle = alertTitle
        headerView.makeLayout()
        
        self.headerView = headerView
    }
    
}
