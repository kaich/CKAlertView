//
//  CKAlertView+ImageHeader.swift
//  Pods
//
//  Created by mac on 16/10/11.
//
//

import Foundation

public extension CKAlertView {
    
    ///  显示带图标的标题栏的弹出框
    ///
    /// - parameter image:             标题图片
    /// - parameter alertTitle:        标题
    /// - parameter message:           主体,$代表段落的结尾
    /// - parameter cancelButtonTitle: 取消按钮标题
    /// - parameter otherButtonTitles: 其他按钮标题
    /// - parameter completeBlock:     点击按钮后的回调
    public convenience init(image headerImage :UIImage?, title alertTitle :CKAlertViewStringable?, message alertMessages :[CKAlertViewStringable]?, cancelButtonTitle :CKAlertViewStringable, otherButtonTitles :[CKAlertViewStringable]? = nil, completeBlock :(((Int) -> Void))? = nil) {
        self.init(nibName: nil, bundle: nil)
        
        dismissCompleteBlock = completeBlock
        
        let componentMaker = CKAlertViewComponentAdditionImageHeaderMaker()
        componentMaker.alertTitle = alertTitle
        componentMaker.alertHeaderImage = headerImage
        componentMaker.alertMessages = alertMessages
        componentMaker.cancelButtonTitle = cancelButtonTitle
        componentMaker.otherButtonTitles = otherButtonTitles
        componentMaker.indentationPatternWidth = indentationPatternWidth
        
        installComponentMaker(maker: componentMaker)
    }
    
}

class CKAlertViewAdditionImageHeaderView : CKAlertViewHeaderView {
    var headerImage :UIImage?
    
    override func setup() {
        super.setup()
        textFont = UIFont.systemFont(ofSize: 15)
    }

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


class CKAlertViewBorderOnlyTwoFooterView : CKAlertViewFooterView {
    
    override func setup() {
        super.setup()
        textColor = HexColor(0x444444,1)
        cancelButtonTitleColor = HexColor(0x444444,1)
    }
    
    override func makeFooterTopHSplitLine() -> UIView? {
        return nil
    }
    
    override func layoutOnlyTwoButtons() {
        
        cancelButton.layer.borderColor = HexColor(0x999999,1).cgColor
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.cornerRadius = 3
        
        cancelButton.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.left.equalTo(self).offset(20)
            make.height.equalTo(36)
            make.bottom.equalTo(self).offset(-20)
        }
        
        if let anotherButton = otherButtons.first {
            anotherButton.layer.borderColor = HexColor(0x999999,1).cgColor
            anotherButton.layer.borderWidth = 1
            anotherButton.layer.cornerRadius = 3
            
            anotherButton.snp.makeConstraints { (make) in
                make.left.equalTo(cancelButton.snp.right).offset(20)
                make.top.bottom.equalTo(cancelButton)
                make.width.height.equalTo(cancelButton)
                make.right.equalTo(self).offset(-20)
            }
        }
    }
}


class CKAlertViewComponentAdditionImageHeaderMaker :CKAlertViewComponentMaker {
    var alertHeaderImage :UIImage?
    
    override func makeHeader() -> CKAlertViewComponent? {
        let headerView = CKAlertViewAdditionImageHeaderView()
        headerView.headerImage = alertHeaderImage
        headerView.alertTitle = alertTitle
        
        return headerView
    }
    
    override func makeBody() -> CKAlertViewComponent? {
        let bodyView = super.makeBody()
        bodyView?.textColor = HexColor(0x666666,1)
        return bodyView
    }
    
    override func makeFooter() -> CKAlertViewComponent? {
        let footerView = CKAlertViewBorderOnlyTwoFooterView()
        footerView.delegate = delegate
        footerView.cancelButtonTitle = cancelButtonTitle
        footerView.otherButtonTitles = otherButtonTitles
        
        return footerView
    }
    
}
