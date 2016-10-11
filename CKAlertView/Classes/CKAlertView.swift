//
//  CKAlertView.swift
//  AwesomeBat
//
//  Created by mac on 16/10/10.
//  Copyright © 2016年 kaicheng. All rights reserved.
//

import UIKit
import SnapKit

let HexColor = {(hex :Int) in return UIColor.init(colorLiteralRed: ((Float)((hex & 0xFF0000) >> 16))/255.0, green: ((Float)((hex & 0xFF00) >> 8))/255.0, blue: ((Float)(hex & 0xFF))/255.0, alpha: 1) }
let is4Inc = UIScreen.main.bounds.size.width == 320

let kTitleFont = UIFont.boldSystemFont(ofSize: 17)
let kMessageFont = UIFont.systemFont(ofSize: 13)
let kCancelTitleColor = UIColor.gray
let kOtherTitleColor = UIColor.gray
let kSplitLineColor = UIColor.gray
let kSplitLineWidth = 0.5

let kDefaultButtonHeight = 44
let kDefaultButtonBackgroundColor = UIColor.clear

let kMultiButtonHeight = 30
let kMultiButtonBackgroundColor = HexColor(0x1768c9)

public class CKAlertView: UIViewController {
    fileprivate var overlayView = UIView()
    fileprivate var contentView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
    fileprivate var headerView  = UIView()
    fileprivate var bodyView    = UIView()
    fileprivate var footerView  = UIView()
    fileprivate var cancelButton :UIButton!
    fileprivate var otherButtons = [UIButton]()
    fileprivate var dismissCompleteBlock :((Int) -> Void)?
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
       
        overlayView = UIView(frame: UIScreen.main.bounds)
        overlayView.backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.5)
        view.addSubview(overlayView)
        
        let contentWidth = is4Inc ? 280 : 300
        contentView.layer.cornerRadius = 5
        contentView.layer.masksToBounds = true
        view.addSubview(contentView)
        
        headerView.backgroundColor = UIColor.clear
        contentView.addSubview(headerView)
        
        bodyView.backgroundColor = UIColor.clear
        contentView.addSubview(bodyView)
        
        footerView.backgroundColor = UIColor.clear
        contentView.addSubview(footerView)

    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    public func show(title alertTitle :String, message alertMessage :String, cancelButtonTitle :String, otherButtonTitles :[String]?, completeBlock :(((Int) -> Void))?) {
        
        dismissCompleteBlock = completeBlock
        
        layoutHeader(title: alertTitle)
        layoutBody(message: alertMessage)
        layoutFooter(cancelButtonTitle: cancelButtonTitle, otherButtonTitles: otherButtonTitles)
        
        show()
    }
    
    
    func layoutHeader(title alertTitle :String) {
        let titleLabel = UILabel()
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.font = kTitleFont
        titleLabel.text = alertTitle
        headerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(headerView).offset(20)
            make.left.equalTo(headerView).offset(20)
            make.right.equalTo(headerView).offset(-20)
            make.bottom.equalTo(headerView).offset(-10)
        }
    }
    
    func layoutBody(message alertMessage :String) {
        let messageLabel = UILabel()
        messageLabel.backgroundColor = UIColor.clear
        messageLabel.numberOfLines = 0
        messageLabel.font = kMessageFont
        messageLabel.text = alertMessage
        bodyView.addSubview(messageLabel)
        messageLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(bodyView).inset(UIEdgeInsetsMake(0, 20, 20, 20))
        }
    }
    
    
    func  layoutFooter(cancelButtonTitle: String,otherButtonTitles :[String]?) {
        
        let splitLineView = UIView()
        splitLineView.backgroundColor = kSplitLineColor
        footerView.addSubview(splitLineView)
        splitLineView.snp.makeConstraints { (make) in
            make.top.right.left.equalTo(footerView)
            make.height.equalTo(kSplitLineWidth)
        }
        
        cancelButton = UIButton()
        cancelButton.setTitleColor(kCancelTitleColor, for: .normal)
        cancelButton.setTitle(cancelButtonTitle, for: .normal)
        cancelButton.addTarget(self, action: #selector(clickButton(sender:)), for: .touchUpInside)
        footerView.addSubview(cancelButton)
        
        otherButtons = [UIButton]()
        if let otherButtonTitles = otherButtonTitles {
            for title in otherButtonTitles {
                let otherButton = UIButton()
                otherButton.setTitleColor(kCancelTitleColor, for: .normal)
                otherButton.setTitle(title, for: .normal)
                otherButton.addTarget(self, action: #selector(clickButton(sender:)), for: .touchUpInside)
                footerView.addSubview(otherButton)
                otherButtons.append(otherButton)
            }
        }
        
        if otherButtons.count > 0 {
            
            if otherButtons.count == 1 {
                
                let vMidSplitLineView = UIView()
                vMidSplitLineView.backgroundColor = kSplitLineColor
                footerView.addSubview(vMidSplitLineView)
                
                cancelButton.snp.makeConstraints { (make) in
                    make.top.bottom.left.equalTo(footerView)
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
                        make.top.bottom.right.equalTo(footerView)
                        make.width.height.equalTo(cancelButton)
                    }
                }
            }
            else {
                
                cancelButton.backgroundColor = kMultiButtonBackgroundColor
                cancelButton.setTitleColor(UIColor.white, for: .normal)
                cancelButton.snp.makeConstraints { (make) in
                    make.top.equalTo(footerView).offset(10)
                    make.left.equalTo(footerView).offset(20)
                    make.right.equalTo(footerView).offset(-20)
                    make.height.equalTo(kMultiButtonHeight)
                }
                
                for (index,emButton) in otherButtons.enumerated() {
                    emButton.backgroundColor = kMultiButtonBackgroundColor
                    emButton.setTitleColor(UIColor.white, for: .normal)
                    emButton.snp.makeConstraints { (make) in
                        make.left.equalTo(footerView).offset(20)
                        make.right.equalTo(footerView).offset(-20)
                        make.height.equalTo(kMultiButtonHeight)
                        if index == 0 {
                            make.top.equalTo(cancelButton.snp.bottom).offset(10)
                        }
                        else {
                            let lastButton = otherButtons[index - 1]
                            make.top.equalTo(lastButton.snp.bottom).offset(10)
                            if index == otherButtons.count - 1 {
                                make.bottom.equalTo(footerView).offset(-20)
                            }
                        }
                    }
                }
            }
            
        }
        else {
            
            cancelButton.snp.makeConstraints { (make) in
                make.top.bottom.left.right.equalTo(footerView)
                make.height.equalTo(kDefaultButtonHeight)
            }
        }
        
    }
    
    func  clickButton(sender :UIButton) {
        dismiss()
        
        
        //index of cancel button is 0
        var index = 0
        if otherButtons.contains(sender) {
            index = otherButtons.index(of: sender)! + 1
        }
        
        if let completeBlock = dismissCompleteBlock {
            completeBlock(index)
        }
    }
    
    func show() {
        let ownWindow = UIApplication.shared.keyWindow! as UIWindow
        ownWindow.addSubview(view)
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.65, initialSpringVelocity: 1, options: .curveLinear, animations: {
            self.contentView.layoutIfNeeded()
        })
        
    }
    
    public func dismiss() {
        
        UIView.animate(withDuration: 0.3, animations: { 
                self.view.alpha = 0
            }) { (_) in
           self.view.removeFromSuperview()
        }
        
    }
    
    
    
    public override func updateViewConstraints() {
        
        view.snp.makeConstraints { (make) in
            make.edges.equalTo(view.superview!)
        }
        
        overlayView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        contentView.snp.makeConstraints { (make) in
            make.center.equalTo(view.center)
            make.width.equalTo(is4Inc ? 280 : 300)
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
        
        super.updateViewConstraints()
    }

}
