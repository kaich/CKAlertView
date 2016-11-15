//
//  CKAlertView+BlueCancel.swift
//  Pods
//
//  Created by mac on 16/11/9.
//
//

import Foundation


public extension CKAlertView {
    
    
    /// 显示突出主功能按钮的弹出框(主功能按钮长,取消按钮和其他按钮居其下方）
    ///
    /// - parameter alertTitle:         标题
    /// - parameter alertMessages:      主体,$代表段落的结尾
    /// - parameter cancelButtonTitle:  取消按钮标题
    /// - parameter otherButtonTitles: 其他按钮标题
    /// - parameter completeBlock:      点击按钮后的回调
    public convenience init(isXHidden :Bool, title alertTitle :CKAlertViewStringable, message alertMessages :[CKAlertViewStringable]?, blueCancelButtonTitle :CKAlertViewStringable, completeBlock :(((Int) -> Void))? = nil) {
        self.init(nibName: nil, bundle: nil)
        
        dismissCompleteBlock = completeBlock
        
        let componentMaker = CKAlertViewComponentBlueCancelMaker()
        componentMaker.alertTitle = alertTitle
        componentMaker.alertMessages = alertMessages
        componentMaker.cancelButtonTitle = blueCancelButtonTitle
        componentMaker.isXHidden = isXHidden
        componentMaker.indentationPatternWidth = indentationPatternWidth
        
        installComponentMaker(maker: componentMaker)
    }
    
}


class CKAlertViewXCloseHeaderView : CKAlertViewHeaderView {
    let btnX = UIButton()
    
    override func setup() {
        super.setup()
        textFont = UIFont.systemFont(ofSize: 15)
    }
    
    override func makeLayout() {
        super.makeLayout()
        
        let splitLineView = UIView()
        splitLineView.backgroundColor = CKAlertView.config.splitLineColor
        addSubview(splitLineView)
        splitLineView.snp.makeConstraints { (make) in
            make.bottom.equalTo(self).offset(-20)
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
            make.height.equalTo(CKAlertView.config.splitLineWidth)
        }
        
        if let titleLabel = subviews.first {
            titleLabel.snp.remakeConstraints({ (make) in
                make.top.equalTo(self).offset(20)
                make.left.equalTo(self).offset(20)
                make.right.equalTo(self).offset(-20)
                make.bottom.equalTo(splitLineView).offset(-20)
            })
            
            
            
            btnX.setImage(UIImage.make(name: "close_28x28"), for: .normal)
            btnX.addTarget(self, action: #selector(clickButtonX), for: .touchUpInside)
            addSubview(btnX)
            btnX.snp.makeConstraints { (make) in
                make.centerY.equalTo(titleLabel)
                make.right.equalTo(self).offset(-15)
            }
        }
        
    }
    
    func clickButtonX() {
        if let delegate  = delegate {
            delegate.clickButton(at: -1)
        }
    }
    
}


class CKAlertViewBlueCancelFooterView : CKAlertViewFooterView {
    
    override func setup() {
        super.setup()
        textColor = HexColor(0x666666,1)
        cancelButtonTitleColor = HexColor(0x666666,1)
    }
    
    override func makeFooterTopHSplitLine() -> UIView? {
        return nil
    }
    
    override func layoutOnlyCancelButton() {
        
        cancelButton.backgroundColor = HexColor(0x236ee7, 1)
        cancelButton.setTitleColor(UIColor.white, for: .normal)
        cancelButton.layer.cornerRadius = 3
        cancelButton.layer.masksToBounds = true
        cancelButton.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.left.equalTo(self).offset(20)
            make.right.bottom.equalTo(self).offset(-20)
            make.height.equalTo(40)
        }
    }
}


class CKAlertViewComponentBlueCancelMaker :CKAlertViewComponentMaker {
    var isXHidden = false
    
    override func makeHeader() -> CKAlertViewComponent? {
        let headerView = CKAlertViewXCloseHeaderView()
        headerView.alertTitle = alertTitle
        headerView.alertTitle = alertTitle
        headerView.btnX.isHidden = isXHidden
        
        return headerView
    }
    
    override func makeBody() -> CKAlertViewComponent? {
        let bodyView = super.makeBody()
        bodyView?.textColor = UIColor.black
        bodyView?.textFont = UIFont.systemFont(ofSize: 12)
        
        return bodyView
    }
    
    override func makeFooter() -> CKAlertViewComponent? {
        let footerView = CKAlertViewBlueCancelFooterView()
        footerView.cancelButtonTitle = cancelButtonTitle
        footerView.otherButtonTitles = otherButtonTitles
        
        return footerView
    }
    
}
