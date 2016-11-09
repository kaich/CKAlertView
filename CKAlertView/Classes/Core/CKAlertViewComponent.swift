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
    var textColor :UIColor?
    var textFont :UIFont?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
       fatalError("setup() has not been implemented")
    }
    
    func makeLayout() {
       fatalError("makeLayout() has not been implemented")
    }
    
}


class CKAlertViewComponentBaseMaker {
    weak var delegate :CKAlertViewComponentDelegate?
    internal(set) var headerView  :CKAlertViewComponent!
    internal(set) var bodyView    :CKAlertViewComponent!
    internal(set) var footerView  :CKAlertViewComponent!
    var cancelButtonTitle: CKAlertViewStringable?
    var otherButtonTitles :[CKAlertViewStringable]?
    
    func makeLayout() {
        headerView = layoutHeader()
        bodyView = layoutBody()
        footerView = layoutFooter()
        
        headerView.makeLayout()
        bodyView.makeLayout()
        footerView.makeLayout()
    }
   
    func layoutHeader() -> CKAlertViewComponent? {
       fatalError("layoutHeader() has not been implemented")
    }
    
    func layoutBody() -> CKAlertViewComponent? {
       fatalError("layoutBody() has not been implemented")
    }
    
    func  layoutFooter() -> CKAlertViewComponent? {
       fatalError("layoutFooter() has not been implemented")
    }
}


class CKAlertViewComponentMaker : CKAlertViewComponentBaseMaker {
    var alertTitle :CKAlertViewStringable?
    var alertMessages :[CKAlertViewStringable]?
    
    override func layoutHeader() -> CKAlertViewComponent? {
        let headerView = CKAlertViewHeaderView()
        headerView.alertTitle = alertTitle
        headerView.delegate = delegate
        
        return headerView
    }
    
    override func layoutBody() -> CKAlertViewComponent? {
        let bodyView = CKAlertViewBodyView()
        bodyView.alertMessages = alertMessages
        bodyView.delegate = delegate
        
        return bodyView
    }
    
    override func  layoutFooter() -> CKAlertViewComponent? {
        let footerView = CKAlertViewFooterView()
        footerView.delegate = delegate
        
        footerView.cancelButtonTitle = cancelButtonTitle
        footerView.otherButtonTitles = otherButtonTitles
        
        return footerView
    }
    
}


class CKAlertViewHeaderView: CKAlertViewComponent {
    var alertTitle :CKAlertViewStringable?
    
    override func setup () {
        self.textFont = CKAlertView.config.titleFont
        self.textColor = UIColor.black
    }
    
    override func makeLayout() {
        let titleLabel = UILabel()
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.font = textFont
        titleLabel.textColor = textColor
        titleLabel.ck_setText(string: alertTitle, isCenter: true)
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
    var alertMessages :[CKAlertViewStringable]?
    
    override func setup () {
        self.textFont = CKAlertView.config.messageFont
        self.textColor = UIColor.black
    }
    
    
    /// $ represent paragraph end
    override func makeLayout() {
        
        if let alertMessages = alertMessages {
            var isParagraphBegin = false
            var lastMessageLabel :UILabel? = nil
            var pureMessage :String = ""
            for (index,emMessage) in alertMessages.enumerated() {
                
                pureMessage = emMessage.ck_string()
                
                if pureMessage == "$" {
                    isParagraphBegin = true
                }
                else {
                    let messageLabel = UILabel()
                    messageLabel.backgroundColor = UIColor.clear
                    messageLabel.numberOfLines = 0
                    messageLabel.font = textFont
                    messageLabel.textColor = textColor
                    messageLabel.textAlignment = .center
                    messageLabel.ck_setText(string: emMessage)
                    addSubview(messageLabel)
                    
                    if alertMessages.count == 1 {
                        messageLabel.snp.makeConstraints({ (make) in
                            make.left.greaterThanOrEqualTo(self).offset(20)
                            make.right.lessThanOrEqualTo(self).offset(-20)
                            make.centerX.equalTo(self)
                            make.top.equalTo(self)
                            make.bottom.equalTo(self).offset(-20)
                        })
                    }
                    else {
                        messageLabel.snp.makeConstraints { (make) in
                            make.left.equalTo(self).offset(20)
                            make.right.equalTo(self).offset(-20)
                            if index == 0 {
                                make.top.equalTo(self)
                            } else {
                                if isParagraphBegin == true {
                                    make.top.equalTo(lastMessageLabel!.snp.bottom).offset(10)
                                    isParagraphBegin = false
                                } else {
                                    make.top.equalTo(lastMessageLabel!.snp.bottom).offset(3)
                                }
                                if index == alertMessages.count - 1 {
                                    make.bottom.equalTo(self).offset(-20)
                                }
                            }
                        }
                        lastMessageLabel = messageLabel
                    }
                }
            }
            
        }
    }
    
}


class CKAlertViewFooterView: CKAlertViewComponent {
    var cancelButton :UIButton!
    var otherButtons = [UIButton]()
    var cancelButtonTitle :CKAlertViewStringable?
    var otherButtonTitles :[CKAlertViewStringable]?
    var cancelButtonTitleFont :UIFont?
    var cancelButtonTitleColor :UIColor?
    
    override func setup () {
        self.textFont =  UIFont.systemFont(ofSize: 15)
        self.textColor = CKAlertView.config.otherTitleColor
        self.cancelButtonTitleColor = CKAlertView.config.cancelTitleColor
        self.cancelButtonTitleFont = UIFont.systemFont(ofSize: 15)
    }
    
    
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
    
    
    func makeButtons(cancelButtonTitle: CKAlertViewStringable?,otherButtonTitles :[CKAlertViewStringable]? = nil) {
        
        cancelButton = UIButton()
        cancelButton.setTitleColor(cancelButtonTitleColor, for: .normal)
        cancelButton.titleLabel?.font = cancelButtonTitleFont
        cancelButton.ck_setText(string: cancelButtonTitle)
        cancelButton.addTarget(self, action: #selector(clickButton(sender:)), for: .touchUpInside)
        self.addSubview(cancelButton)
        
        otherButtons = [UIButton]()
        if let otherButtonTitles = otherButtonTitles {
            for title in otherButtonTitles {
                let otherButton = UIButton()
                otherButton.setTitleColor(textColor, for: .normal)
                otherButton.titleLabel?.font = textFont
                otherButton.ck_setText(string: title)
                otherButton.addTarget(self, action: #selector(clickButton(sender:)), for: .touchUpInside)
                self.addSubview(otherButton)
                otherButtons.append(otherButton)
            }
        }
    }
    
    func makeFooterTopHSplitLine() -> UIView? {
        let splitLineView = UIView()
        splitLineView.backgroundColor = CKAlertView.config.splitLineColor
        self.addSubview(splitLineView)
        splitLineView.snp.makeConstraints { (make) in
            make.top.right.left.equalTo(self)
            make.height.equalTo(CKAlertView.config.splitLineWidth)
        }
        return splitLineView
    }
    
    
    func layoutOnlyCancelButton() {
        cancelButton.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalTo(self)
            make.height.equalTo(CKAlertView.config.buttonDefaultHeight)
        }
    }
    
    func layoutOnlyTwoButtons() {
        
        let vMidSplitLineView = UIView()
        vMidSplitLineView.backgroundColor = CKAlertView.config.splitLineColor
        self.addSubview(vMidSplitLineView)
        
        cancelButton.snp.makeConstraints { (make) in
            make.top.bottom.left.equalTo(self)
            make.height.equalTo(CKAlertView.config.buttonDefaultHeight)
        }
        
        vMidSplitLineView.snp.makeConstraints({ (make) in
            make.left.equalTo(cancelButton.snp.right)
            make.top.bottom.height.equalTo(cancelButton)
            make.width.equalTo(CKAlertView.config.splitLineWidth)
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
        cancelButton.backgroundColor = CKAlertView.config.multiButtonBackgroundColor
        cancelButton.setTitleColor(UIColor.white, for: .normal)
        cancelButton.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(10)
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
            make.height.equalTo(CKAlertView.config.multiButtonHeight)
        }
        
        for (index,emButton) in otherButtons.enumerated() {
            emButton.backgroundColor = CKAlertView.config.multiButtonBackgroundColor
            emButton.setTitleColor(UIColor.white, for: .normal)
            emButton.snp.makeConstraints { (make) in
                make.left.equalTo(self).offset(20)
                make.right.equalTo(self).offset(-20)
                make.height.equalTo(CKAlertView.config.multiButtonHeight)
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
