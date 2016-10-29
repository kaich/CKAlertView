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

let kContentWidth = is4Inc ? 280 : 300
let kTitleFont = UIFont.boldSystemFont(ofSize: 17)
let kMessageFont = UIFont.systemFont(ofSize: 13)
let kCancelTitleColor = HexColor(0x444444,1)
let kOtherTitleColor = HexColor(0x444444,1)
let kSplitLineColor = UIColor.gray
let kSplitLineWidth = 0.5

let kDefaultButtonHeight = 44
let kDefaultButtonBackgroundColor = UIColor.clear

let kMultiButtonHeight = 30
let kMultiButtonBackgroundColor = HexColor(0x1768c9,1)

public extension UIImage {
    static func make(name: String) -> UIImage? {
        let bundle = Bundle(for: CKAlertView.self)
        let imageName = "CKAlertView.bundle/\(name)"
        return UIImage(named: imageName , in: bundle, compatibleWith: nil)
    }
}


/// 多种样式的弹出框，支持多行和多段落的弹出框消息。区分段落以$结尾(Multi style alert. Surpport multi line message. Symbol $ represent paragraph end).
public class CKAlertView: UIViewController, CKAlertViewComponentDelegate {
    var overlayView = UIView()
    var contentView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: UIBlurEffect(style: .light)))
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
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
       
        overlayView = UIView(frame: UIScreen.main.bounds)
        overlayView.backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.5)
        view.addSubview(overlayView)
        
        contentView.backgroundColor = HexColor(0xffffff,0.8)
        contentView.layer.cornerRadius = 5
        contentView.layer.masksToBounds = true
        view.addSubview(contentView)
        
        headerView.backgroundColor = UIColor.clear
        contentView.addSubview(headerView)
        
        bodyView.backgroundColor = UIColor.clear
        contentView.addSubview(bodyView)
        
        footerView.backgroundColor = UIColor.clear
        contentView.addSubview(footerView)

        makeConstraint()
        
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func installComponentMaker(maker :CKAlertViewComponentBaseMaker) {
        self.componentMaker = maker
        self.componentMaker.delegate = self
        self.componentMaker.makeLayout()
    }
    
    func show() {
        let ownWindow = UIApplication.shared.keyWindow! as UIWindow
        ownWindow.addSubview(view)
        ownWindow.rootViewController?.addChildViewController(self)
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.65, initialSpringVelocity: 1, options: .curveLinear, animations: {
            self.contentView.layoutIfNeeded()
        })
        
    }
    
    public func dismiss() {
        
        UIView.animate(withDuration: 0.3, animations: { 
                self.view.alpha = 0
            }) { (_) in
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
        }
        
    }
    
    
    func makeConstraint() {

        overlayView.snp.makeConstraints { (make) in
            make.top.right.bottom.left.equalTo(view)
        }
        
        contentView.snp.makeConstraints { (make) in
            make.center.equalTo(view.snp.center)
            make.width.equalTo(kContentWidth)
        }
        
        headerView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView)
            make.left.right.equalTo(contentView)
        }
        
        bodyView.snp.makeConstraints { (make) in
            make.top.equalTo(headerView.snp.bottom)
            make.left.right.equalTo(contentView)
        }
        
        footerView.snp.makeConstraints { (make) in
            make.top.equalTo(bodyView.snp.bottom)
            make.left.right.equalTo(contentView)
            make.bottom.equalTo(contentView)
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
        dismiss()
        
        if let completeBlock = dismissCompleteBlock {
            completeBlock(index)
        }
    }

}


public extension CKAlertView {
    
    
    /// 标准弹出框
    ///
    /// - parameter alertTitle:        标题
    /// - parameter alertMessages:     主体,$代表段落的结尾
    /// - parameter cancelButtonTitle: 取消按钮标题
    /// - parameter otherButtonTitles: 其他按钮标题
    /// - parameter completeBlock:     点击按钮后的回调
    public func show(title alertTitle :String, message alertMessages :[String]?, cancelButtonTitle :String, otherButtonTitles :[String]? = nil, completeBlock :(((Int) -> Void))? = nil) {
        
        dismissCompleteBlock = completeBlock
        
        let componentMaker = CKAlertViewComponentMaker()
        componentMaker.alertTitle = alertTitle
        componentMaker.alertMessages = alertMessages
        componentMaker.cancelButtonTitle = cancelButtonTitle
        componentMaker.otherButtonTitles = otherButtonTitles
        
        
        installComponentMaker(maker: componentMaker)
        
        show()
    }
    
}

