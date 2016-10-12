//
//  CKAlertView+MajorAction.swift
//  Pods
//
//  Created by mac on 16/10/12.
//
//

import Foundation

extension CKAlertView {
    
    public func show(title alertTitle :String, message alertMessages :[String]?, cancelButtonTitle :String, majorButtonTitle :String, anotherButtonTitle :String, completeBlock :(((Int) -> Void))? = nil) {
        dismissCompleteBlock = completeBlock
        
        let componentMaker = CKAlertViewComponentMajorActionMaker()
        componentMaker.delegate = self
        componentMaker.alertTitle = alertTitle
        componentMaker.alertMessages = alertMessages
        componentMaker.cancelButtonTitle = cancelButtonTitle
        componentMaker.otherButtonTitles = [majorButtonTitle,anotherButtonTitle]
        componentMaker.makeLayout()
        
        self.componentMaker = componentMaker
        
        show()
    }
    
}


class CKAlertViewBottomSplitLineHeaderView : CKAlertViewHeaderView {
    
    override func setup() {
        super.setup()
        textFont = UIFont.systemFont(ofSize: 15)
    }
    
    override func makeLayout() {
        super.makeLayout()
        
        let splitLineView = UIView()
        splitLineView.backgroundColor = kSplitLineColor
        addSubview(splitLineView)
        splitLineView.snp.makeConstraints { (make) in
            make.bottom.equalTo(self).offset(-20)
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
            make.height.equalTo(kSplitLineWidth)
        }
        
        if let titleLabel = subviews.first {
           titleLabel.snp.remakeConstraints({ (make) in
                make.top.equalTo(self).offset(20)
                make.left.equalTo(self).offset(20)
                make.right.equalTo(self).offset(-20)
                make.bottom.equalTo(splitLineView).offset(-20)
           })
        }
    }
    
}


class CKAlertViewMajorActionFooterView : CKAlertViewFooterView {
    
    override func setup() {
        super.setup()
        textColor = HexColor(0x666666,1)
        cancelButtonTitleColor = HexColor(0x666666,1)
    }
    
    override func makeFooterTopHSplitLine() -> UIView? {
        return nil
    }
    
    override func layoutMultiButtons () {
        
        if otherButtons.count == 2 {
            
            let majorButton = otherButtons.first
            let anotherButton = otherButtons[1]
            
            majorButton?.backgroundColor = HexColor(0x49bc1e,1)
            majorButton?.layer.cornerRadius = 3
            majorButton?.layer.masksToBounds = true
            majorButton?.setTitleColor(UIColor.white, for: .normal)
            
            majorButton?.snp.makeConstraints({ (make) in
                make.top.equalTo(self)
                make.left.equalTo(self).offset(20)
                make.height.equalTo(36)
                make.right.equalTo(self).offset(-20)
            })
            
            cancelButton.snp.makeConstraints { (make) in
                make.top.equalTo(majorButton!.snp.bottom).offset(20)
                make.left.equalTo(self).offset(20)
                make.height.equalTo(36)
                make.bottom.equalTo(self).offset(-20)
            }
            
            anotherButton.snp.makeConstraints { (make) in
                make.left.equalTo(cancelButton.snp.right).offset(20)
                make.top.bottom.equalTo(cancelButton)
                make.width.height.equalTo(cancelButton)
                make.right.equalTo(self).offset(-20)
            }
        }
    }
}


class CKAlertViewComponentMajorActionMaker :CKAlertViewComponentMaker {
    
    override func layoutHeader() -> CKAlertViewComponent? {
        let headerView = CKAlertViewBottomSplitLineHeaderView()
        headerView.alertTitle = alertTitle
        headerView.alertTitle = alertTitle
        
        return headerView
    }
    
    override func layoutBody() -> CKAlertViewComponent? {
        let bodyView = super.layoutBody()
        bodyView?.textColor = HexColor(0x666666,1)
        
        return bodyView
    }
    
    override func layoutFooter() -> CKAlertViewComponent? {
        let footerView = CKAlertViewMajorActionFooterView()
        footerView.delegate = delegate
        footerView.cancelButtonTitle = cancelButtonTitle
        footerView.otherButtonTitles = otherButtonTitles
        
        return footerView
    }
    
}
