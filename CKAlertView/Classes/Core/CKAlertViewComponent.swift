//
//  CKAlertViewComponent.swift
//  Pods
//
//  Created by mac on 16/10/11.
//
//

import UIKit

extension UIImage {

    class func imageWithColor(color :UIColor) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            context.fill(rect)
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image;
    }
    
}



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
    internal lazy var headerView  :CKAlertViewComponent! = self.makeHeader()
    internal lazy var bodyView    :CKAlertViewComponent! = self.makeBody()
    internal lazy var footerView  :CKAlertViewComponent! = self.makeFooter()
    var cancelButtonTitle: CKAlertViewStringable?
    var otherButtonTitles :[CKAlertViewStringable]?
    private var isMakeLayoutCompleted = false
    
    func makeComponents() {
        
        headerView.delegate = delegate
        bodyView.delegate = delegate
        footerView.delegate = delegate
    }
    
    func makeLayout() {
        if !isMakeLayoutCompleted {
            
            headerView.makeLayout()
            bodyView.makeLayout()
            footerView.makeLayout()
            
            isMakeLayoutCompleted = true
        }
    }
   
    func makeHeader() -> CKAlertViewComponent? {
       fatalError("layoutHeader() has not been implemented")
    }
    
    func makeBody() -> CKAlertViewComponent? {
       fatalError("layoutBody() has not been implemented")
    }
    
    func  makeFooter() -> CKAlertViewComponent? {
       fatalError("layoutFooter() has not been implemented")
    }
}


class CKAlertViewComponentMaker : CKAlertViewComponentBaseMaker {
    var alertTitle :CKAlertViewStringable?
    var alertMessages :[CKAlertViewStringable]?
    var indentationPatternWidth :[String : CGFloat]? {
        didSet {
            if let bodyView = self.bodyView as? CKAlertViewBodyView {
                bodyView.indentationPattern2WidthDic = indentationPatternWidth
            }
        }
    }
    
    override func makeHeader() -> CKAlertViewComponent? {
        let headerView = CKAlertViewHeaderView()
        headerView.alertTitle = alertTitle
        
        return headerView
    }
    
    override func makeBody() -> CKAlertViewComponent? {
        let bodyView = CKAlertViewBodyView()
        bodyView.alertMessages = alertMessages
        
        return bodyView
    }
    
    override func makeFooter() -> CKAlertViewComponent? {
        let footerView = CKAlertViewFooterView()
        
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
    var indentationPattern2WidthDic : [String : CGFloat]?
    var alertMessages :[CKAlertViewStringable]?
    
    override func setup () {
        self.textFont = CKAlertView.config.messageFont
        self.textColor = UIColor.black
    }
    
    
    /// $ represent paragraph end
    override func makeLayout() {
        
        if let alertMessages = alertMessages {
            var isParagraphBegin = false
            var lastMessageLabel :UITextView? = nil
            var pureMessage :String = ""
            for (index,emMessage) in alertMessages.enumerated() {
                
                pureMessage = emMessage.ck_string()
                
                if pureMessage == "$" {
                    isParagraphBegin = true
                }
                else {
                    var messageLabel :UITextView!
                    let checkResult = check(string: emMessage.ck_string(), indentationPattern2WidthDic: indentationPattern2WidthDic)
                    if checkResult.isNeedindentation {
                        let zeroRect = CGRect(x: 0, y: 0, width: 0, height: 0)
                        let textStorage = NSTextStorage()
                        let layoutManager = NSLayoutManager()
                        let textContainer = NSTextContainer(size: zeroRect.size)
                        textContainer.exclusionPaths = [UIBezierPath(rect: CGRect(x: 0, y: getLineHeight(string: emMessage), width: checkResult.indentationWidth, height: CGFloat.greatestFiniteMagnitude))]
                        textStorage.addLayoutManager(layoutManager)
                        layoutManager.addTextContainer(textContainer)
                        messageLabel = UITextView(frame: zeroRect, textContainer: textContainer)
                    }
                    else {
                        messageLabel = UITextView()
                    }
                    messageLabel.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0)
                    messageLabel.isEditable = false
                    messageLabel.isSelectable = false
                    messageLabel.isScrollEnabled = false
                    messageLabel.backgroundColor = UIColor.clear
                    messageLabel.font = textFont
                    messageLabel.textColor = textColor
                    messageLabel.textAlignment = .left
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
    
    func getLineHeight(string :CKAlertViewStringable) -> CGFloat {
        var lineHeight :CGFloat = 0
        
        if let string = string as? String {
            if let textFont = textFont {
                lineHeight = textFont.lineHeight
            }
        }
        else if let attributeStr = string as? NSAttributedString {
            let finalAttributes = attributeStr.attributes(at: 0, effectiveRange: nil)
            if let fontSize = finalAttributes[NSFontAttributeName] as? UIFont {
                lineHeight = fontSize.lineHeight
            }
            else {
                if let textFont = textFont {
                    lineHeight = textFont.lineHeight
                }
            }
            
            if let paragraphStyle = finalAttributes[NSParagraphStyleAttributeName] as? NSMutableParagraphStyle {
                lineHeight += paragraphStyle.lineSpacing
            }
        }
        
        return ceil(lineHeight)
    }
    
    func check(string :String, indentationPattern2WidthDic :[String : CGFloat]?) -> (isNeedindentation :Bool, indentationWidth :CGFloat) {
        var isNeedindentation = false
        var indentationWidth :CGFloat = 0
        
        if let indentationPattern2WidthDic = indentationPattern2WidthDic {
            for (indentationPattern, width) in indentationPattern2WidthDic {
                if let regex = try? NSRegularExpression(pattern: indentationPattern, options: .caseInsensitive) {
                    let count = regex.numberOfMatches(in: string, options: .anchored, range: NSMakeRange(0, string.characters.count))
                    if count > 0 {
                        isNeedindentation = true
                        indentationWidth = width
                    }
                }
            }
        }
        
        return (isNeedindentation, indentationWidth)
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
        
        cancelButton = UIButton(type: .system)
        cancelButton.setTitleColor(cancelButtonTitleColor, for: .normal)
        cancelButton.titleLabel?.font = cancelButtonTitleFont
        cancelButton.ck_setText(string: cancelButtonTitle)
        cancelButton.addTarget(self, action: #selector(clickButton(sender:)), for: .touchUpInside)
        self.addSubview(cancelButton)
        
        otherButtons = [UIButton]()
        if let otherButtonTitles = otherButtonTitles {
            for title in otherButtonTitles {
                let otherButton = UIButton(type: .system)
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
