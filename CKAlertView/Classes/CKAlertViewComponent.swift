//
//  CKAlertViewComponent.swift
//  Pods
//
//  Created by mac on 16/10/11.
//
//

import UIKit

protocol CKAlertViewComponentDelegate :class {
    func clickButton(at index :Int);
}


class CKAlertViewComponent: UIView {
    weak var delegate :CKAlertViewComponentDelegate?
    
    func makeLayout() {
       fatalError("makeLayout() has not been implemented")
    }
    
}


class CKAlertViewComponentBaseMaker {
    weak var delegate :CKAlertViewComponentDelegate?
    internal(set) var headerView  :CKAlertViewComponent!
    internal(set) var bodyView    :CKAlertViewComponent!
    internal(set) var footerView  :CKAlertViewComponent!
    var cancelButtonTitle: String?
    var otherButtonTitles :[String]?
    
    func makeLayout() {
        layoutHeader()
        layoutBody()
        layoutFooter()
    }
    
    func layoutHeader() {
       fatalError("layoutHeader() has not been implemented")
    }
    
    func layoutBody() {
       fatalError("layoutBody() has not been implemented")
    }
    
    func  layoutFooter() {
       fatalError("layoutFooter() has not been implemented")
    }
}


class CKAlertViewComponentMaker : CKAlertViewComponentBaseMaker {
    var alertTitle :String?
    var alertMessage :String?
    
    override func layoutHeader() {
        let headerView = CKAlertViewHeaderView()
        headerView.alertTitle = alertTitle
        headerView.makeLayout()
        
        self.headerView = headerView
    }
    
    override func layoutBody() {
        let bodyView = CKAlertViewBodyView()
        bodyView.alertMessage = alertMessage
        bodyView.makeLayout()
        
        self.bodyView = bodyView
    }
    
    override func  layoutFooter() {
        let footerView = CKAlertViewFooterView()
        footerView.delegate = delegate
        
        footerView.cancelButtonTitle = cancelButtonTitle
        footerView.otherButtonTitles = otherButtonTitles
        footerView.makeLayout()
        
        self.footerView = footerView
    }
    
}




class CKAlertViewHeaderView: CKAlertViewComponent {
    var alertTitle :String?
    
    override func makeLayout() {
        let titleLabel = UILabel()
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.font = kTitleFont
        titleLabel.text = alertTitle
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(20)
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
            make.bottom.equalTo(self).offset(-10)
        }
    }
    
}


class CKAlertViewBodyView: CKAlertViewComponent {
    var alertMessage :String?
    
    override func makeLayout() {
        let messageLabel = UILabel()
        messageLabel.backgroundColor = UIColor.clear
        messageLabel.numberOfLines = 0
        messageLabel.font = kMessageFont
        messageLabel.text = alertMessage
        self.addSubview(messageLabel)
        messageLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(self).inset(UIEdgeInsetsMake(0, 20, 20, 20))
        }
    }
    
}


class CKAlertViewFooterView: CKAlertViewComponent {
    var cancelButton :UIButton!
    var otherButtons = [UIButton]()
    var cancelButtonTitle :String?
    var otherButtonTitles :[String]?
    
    override func makeLayout() {
        makeFooterTopHSplitLine()
        makeButtons(cancelButtonTitle: cancelButtonTitle, otherButtonTitles: otherButtonTitles)
        
        if otherButtons.count > 0 {
            
            if otherButtons.count == 1 {
                layoutOnlyTwoButtons()
            }
            else {
                layoutMultiButtons()
            }
        }
        else {
            layoutOnlyCancelButton()
        }
    }
    
    
    func makeButtons(cancelButtonTitle: String?,otherButtonTitles :[String]? = nil) {
        
        cancelButton = UIButton()
        cancelButton.setTitleColor(kCancelTitleColor, for: .normal)
        cancelButton.setTitle(cancelButtonTitle, for: .normal)
        cancelButton.addTarget(self, action: #selector(clickButton(sender:)), for: .touchUpInside)
        self.addSubview(cancelButton)
        
        otherButtons = [UIButton]()
        if let otherButtonTitles = otherButtonTitles {
            for title in otherButtonTitles {
                let otherButton = UIButton()
                otherButton.setTitleColor(kCancelTitleColor, for: .normal)
                otherButton.setTitle(title, for: .normal)
                otherButton.addTarget(self, action: #selector(clickButton(sender:)), for: .touchUpInside)
                self.addSubview(otherButton)
                otherButtons.append(otherButton)
            }
        }
    }
    
    func makeFooterTopHSplitLine() -> UIView? {
        let splitLineView = UIView()
        splitLineView.backgroundColor = kSplitLineColor
        self.addSubview(splitLineView)
        splitLineView.snp.makeConstraints { (make) in
            make.top.right.left.equalTo(self)
            make.height.equalTo(kSplitLineWidth)
        }
        return splitLineView
    }
    
    
    func layoutOnlyCancelButton() {
        cancelButton.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalTo(self)
            make.height.equalTo(kDefaultButtonHeight)
        }
    }
    
    func layoutOnlyTwoButtons() {
        
        let vMidSplitLineView = UIView()
        vMidSplitLineView.backgroundColor = kSplitLineColor
        self.addSubview(vMidSplitLineView)
        
        cancelButton.snp.makeConstraints { (make) in
            make.top.bottom.left.equalTo(self)
            make.height.equalTo(kDefaultButtonHeight)
        }
        
        vMidSplitLineView.snp.makeConstraints({ (make) in
            make.left.equalTo(cancelButton.snp.right)
            make.top.bottom.height.equalTo(cancelButton)
            make.width.equalTo(kSplitLineWidth)
        })
        
        if let anotherButton = otherButtons.first {
            anotherButton.snp.makeConstraints { (make) in
                make.left.equalTo(vMidSplitLineView.snp.right)
                make.top.bottom.right.equalTo(self)
                make.width.height.equalTo(cancelButton)
            }
        }
    }
    
    func layoutMultiButtons() {
        cancelButton.backgroundColor = kMultiButtonBackgroundColor
        cancelButton.setTitleColor(UIColor.white, for: .normal)
        cancelButton.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(10)
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
            make.height.equalTo(kMultiButtonHeight)
        }
        
        for (index,emButton) in otherButtons.enumerated() {
            emButton.backgroundColor = kMultiButtonBackgroundColor
            emButton.setTitleColor(UIColor.white, for: .normal)
            emButton.snp.makeConstraints { (make) in
                make.left.equalTo(self).offset(20)
                make.right.equalTo(self).offset(-20)
                make.height.equalTo(kMultiButtonHeight)
                if index == 0 {
                    make.top.equalTo(cancelButton.snp.bottom).offset(10)
                }
                else {
                    let lastButton = otherButtons[index - 1]
                    make.top.equalTo(lastButton.snp.bottom).offset(10)
                    if index == otherButtons.count - 1 {
                        make.bottom.equalTo(self).offset(-20)
                    }
                }
            }
        }
    }
    
    
    func  clickButton(sender :UIButton) {
        
        //index of cancel button is 0
        var index = 0
        if otherButtons.contains(sender) {
            index = otherButtons.index(of: sender)! + 1
        }
        
        if let delegate = delegate {
            delegate.clickButton(at: index)
        }
    }
}
