//
//  CKAlertView.swift
//  AwesomeBat
//
//  Created by mac on 16/10/10.
//  Copyright © 2016年 kaicheng. All rights reserved.
//

import UIKit
import SnapKit

let HexColor = {(hex :Int, alpha :Float) in return UIColor.init(colorLiteralRed: ((Float)((hex & 0xFF0000) >> 16))/255.0, green: ((Float)((hex & 0xFF00) >> 8))/255.0, blue: ((Float)(hex & 0xFF))/255.0, alpha: alpha) }
let is4Inc = UIScreen.main.nativeBounds.size.width / UIScreen.main.nativeScale == 320


public extension UIImage {
    static func make(name: String) -> UIImage? {
        let bundle = Bundle(for: CKAlertView.self)
        let imageName = "CKAlertView.bundle/\(name)"
        return UIImage(named: imageName , in: bundle, compatibleWith: nil)
    }
}

public struct CKAlertViewConfiguration {
   
    /// alertView宽度是否固定
    public var isFixedContentWidth = true
    /// alertView的宽度，只有 isFixedContentWidth = ture，此值才会有作用
    public var contentWidth = is4Inc ? 280 : 300
    /// 标题字体
    public var titleFont = UIFont.boldSystemFont(ofSize: 17)
    /// 主体字体
    public var messageFont = UIFont.systemFont(ofSize: 13)
    /// 取消按钮的字体颜色
    public var cancelTitleColor = HexColor(0x444444,1)
    /// 其他按钮字体颜色
    public var otherTitleColor = HexColor(0x444444,1)
    /// 分割线颜色
    public var splitLineColor = UIColor.gray
    /// 分割线宽度
    public var splitLineWidth = 0.5
    /// 按钮默认高度
    public var buttonDefaultHeight = 44
    /// 按钮默认背景色
    public var buttonDefaultBackgroundColor =  UIColor.clear
    /// 多行按钮默认高度
    public var multiButtonHeight = 30
    /// 多行按钮默认背景色
    public var multiButtonBackgroundColor = HexColor(0x1768c9,1)
}


/// 多种样式的弹出框，支持多行和多段落的弹出框消息。区分段落以$结尾, 文字String或者NSAttributedString。(Multi style alert. Surpport multi line message. Symbol $ represent paragraph end).
public class CKAlertView: UIViewController, CKAlertViewComponentDelegate {
    /// 配置整体样式
    public static var config = CKAlertViewConfiguration()
    /// 正则 -》 缩进宽度
    public var indentationPatternWidth :[String : CGFloat]? {
        didSet {
            if let componentMaker = self.componentMaker as? CKAlertViewComponentMaker {
                componentMaker.indentationPatternWidth = indentationPatternWidth
            }
        }
    }
    /// 是否用户控制消失，如果是true那么点击按钮弹出框不自动消失
    public var isUserDismiss = false
    
    var overlayView = UIView()
    var containerView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
    var componentMaker :CKAlertViewComponentBaseMaker!
    
    var headerView  :CKAlertViewComponent! {
        get {
           return componentMaker.headerView
        }
    }
    var bodyView    :CKAlertViewComponent! {
        get {
            return componentMaker.bodyView
        }
    }
    var footerView  :CKAlertViewComponent! {
        get {
            return componentMaker.footerView
        }
    }
    
    var dismissCompleteBlock :((Int) -> Void)?
    
    var _isShow = false
    public var isShow :Bool {
        get {
            return  _isShow
        }
    }
    
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
       
        overlayView = UIView(frame: UIScreen.main.bounds)
        overlayView.backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.5)
        view.addSubview(overlayView)
        
        containerView.center = view.center
        containerView.layer.cornerRadius = 5
        containerView.layer.masksToBounds = true
        view.addSubview(containerView)
        
        headerView.backgroundColor = UIColor.clear
        containerView.contentView.addSubview(headerView)
        
        bodyView.backgroundColor = UIColor.clear
        containerView.contentView.addSubview(bodyView)
        
        footerView.backgroundColor = UIColor.clear
        containerView.contentView.addSubview(footerView)

        makeConstraint()
        
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func installComponentMaker(maker :CKAlertViewComponentBaseMaker) {
        self.componentMaker = maker
        self.componentMaker.delegate = self
        self.componentMaker.makeComponents()
    }
    
    public func show() {
        self.componentMaker.makeLayout()
        
        let ownWindow = UIApplication.shared.keyWindow! as UIWindow
        ownWindow.addSubview(view)
        ownWindow.rootViewController?.addChildViewController(self)
        updateViewConstraints()
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.65, initialSpringVelocity: 1, options: .curveLinear, animations: {
            self.view.alpha = 1
            self.containerView.layoutIfNeeded()
            self._isShow = true
        })
    }
    
    
    public func dismiss(isAnimate :Bool = true, completeBlock :((Void) -> Void)? = nil) {
        
        let dismissBlock = {
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
            self._isShow = false
            if let completeBlock = completeBlock {
                completeBlock()
            }
        }
        
        if isAnimate == true {
            UIView.animate(withDuration: 0.3, animations: {
                self.view.alpha = 0
            }) { (_) in
                dismissBlock()
            }
        }
        else {
            dismissBlock()
        }
        
    }
    
    
    func makeConstraint() {

        overlayView.snp.makeConstraints { (make) in
            make.top.right.bottom.left.equalTo(view)
        }
        
        containerView.snp.makeConstraints { (make) in
            make.center.equalTo(view.snp.center)
            if CKAlertView.config.isFixedContentWidth {
                make.width.equalTo(CKAlertView.config.contentWidth)
            }
        }
        
        headerView.snp.makeConstraints { (make) in
            make.top.equalTo(containerView)
            make.left.right.equalTo(containerView.contentView)
        }
        
        bodyView.snp.makeConstraints { (make) in
            make.top.equalTo(headerView.snp.bottom)
            make.left.right.equalTo(containerView.contentView)
        }
        
        footerView.snp.makeConstraints { (make) in
            make.top.equalTo(bodyView.snp.bottom)
            make.left.right.equalTo(containerView.contentView)
            make.bottom.equalTo(containerView.contentView)
        }
    }
    
    
    public override func updateViewConstraints() {
        
        view.snp.remakeConstraints { (make) in
            make.top.right.bottom.left.equalTo(view.superview!)
        }
        
        super.updateViewConstraints()
    }
    
    
    //MARK: - CKAlertViewComponentDelegate
    func  clickButton(at index :Int) {
        if !isUserDismiss {
            dismiss()
        }
        
        if let completeBlock = dismissCompleteBlock {
            completeBlock(index)
        }
    }
    
    
    //MARK: - major show method 
    
    /// 标准弹出框(文字String或者NSAttributedString)
    ///
    /// - parameter alertTitle:        标题
    /// - parameter alertMessages:     主体,$代表段落的结尾
    /// - parameter cancelButtonTitle: 取消按钮标题
    /// - parameter otherButtonTitles: 其他按钮标题
    /// - parameter completeBlock:     点击按钮后的回调
    public convenience init(title alertTitle :CKAlertViewStringable, message alertMessages :[CKAlertViewStringable]?, cancelButtonTitle :CKAlertViewStringable, otherButtonTitles :[CKAlertViewStringable]? = nil, completeBlock :(((Int) -> Void))? = nil) {
        self.init(nibName: nil, bundle: nil)
        
        dismissCompleteBlock = completeBlock
        
        let componentMaker = CKAlertViewComponentMaker()
        componentMaker.alertTitle = alertTitle
        componentMaker.alertMessages = alertMessages
        componentMaker.cancelButtonTitle = cancelButtonTitle
        componentMaker.otherButtonTitles = otherButtonTitles
    
        installComponentMaker(maker: componentMaker)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

}

