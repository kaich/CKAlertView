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
    /// 显示以及消失动画(默认提供了弹簧动画CKAlertViewSpringAnimator)
    public var animator :CKAlertViewAnimatable?
    /// 交互(默认提供了简单的交互CKAlertViewAttachmentInteractiveHandler)
    public var interactiveHandler: CKAlertViewInteractive?
    
    public var forceGesture: UIGestureRecognizer!
    public var forceGestureBlock: ((UIGestureRecognizer) -> Void)?
    
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
        
        if let interactiveHandler = self.interactiveHandler {
            interactiveHandler.setupAfterLoaded()
        }
        
        if #available(iOS 9, *){
            if traitCollection.forceTouchCapability == .available{
                print("force touch capability on this device")
                forceGesture = CKForceGestureRecognizer(target: self, action: #selector(handleForceGesture))
                containerView.addGestureRecognizer(forceGesture!)
            }
        }
        
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
        
        var complete = {
            self._isShow = true
        }
        
        animator?.show { Void in
            complete()
        }
        
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
            
            animator?.dismiss {
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
        if let completeBlock = dismissCompleteBlock {
            completeBlock(index)
        }
        
        if !isUserDismiss {
            dismiss()
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
        animator = CKAlertViewSpringAnimator(alertView: self)
        interactiveHandler = CKAlertViewAttachmentInteractiveHandler(alertView: self)
    }

}


extension CKAlertView {
    
    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if #available(iOS 9, *){
            
            if traitCollection.forceTouchCapability != previousTraitCollection?.forceTouchCapability {
                
                if traitCollection.forceTouchCapability == .available{
                    
                    if forceGesture == nil {
                        //the app apparently started without 3D touch enabled, so the 3D touch gestureRecognizer was never initialized. Do this now.
                        forceGesture = CKForceGestureRecognizer(target: self, action: #selector(handleForceGesture))
                        containerView.addGestureRecognizer(forceGesture!)
                    }
                }
            }
        }
    }
    
    
    func handleForceGesture() {
        if let forceGestureHandler = self.forceGestureBlock {
            forceGestureHandler(forceGesture)
        }
    }
    
}

