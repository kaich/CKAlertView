//
//  CKAlertView+MajorAction.swift
//  Pods
//
//  Created by mac on 16/10/12.
//
//

import Foundation
import DACircularProgress

public class CKCircularProgressAlertView : CKAlertView {
    public var alertTitle = "" {
        didSet {
            if let componentMaker = self.componentMaker as? CKAlertViewComponentCircularProgressMaker {
                componentMaker.alertTitle = alertTitle
            }
        }
    }
    public var progress :Float = 0 {
        didSet {
            if let componentMaker = self.componentMaker as? CKAlertViewComponentCircularProgressMaker {
                componentMaker.progress = progress
            }
        }
    }
    public var progressMessage = "" {
        didSet {
            if let componentMaker = self.componentMaker as? CKAlertViewComponentCircularProgressMaker {
                componentMaker.progressMessage = progressMessage
            }
        }
    }
    public var alertMessage = "" {
        didSet {
            if let componentMaker = self.componentMaker as? CKAlertViewComponentCircularProgressMaker {
                componentMaker.alertMessage = alertMessage
            }
        }
    }
    public var alertDetailMessage = "" {
        didSet {
            if let componentMaker = self.componentMaker as? CKAlertViewComponentCircularProgressMaker {
                componentMaker.alertDetailMessage = alertDetailMessage
            }
        }
    }
    public var cancelButtonTitle = "" {
        didSet {
            if let componentMaker = self.componentMaker as? CKAlertViewComponentCircularProgressMaker {
                componentMaker.cancelButtonTitle = cancelButtonTitle
            }
        }
    }
    

    
    
    /// 显示圆形进度条的弹出框
    ///
    /// - parameter alertTitle:        标题
    /// - parameter progress:          进度
    /// - parameter alertMessage:      内容
    /// - parameter detailMessage:     详细内容
    /// - parameter cancelButtonTitle: 取消按钮文字
    /// - parameter completeBlock:     完成回调
    public init(title alertTitle :String, progress :Float, progressMessage :String? ,  message alertMessage :String?,  detailMessage :String?,  cancelButtonTitle :String, completeBlock :(((Int) -> Void))? = nil) {
        super.init(nibName: nil, bundle: nil)
        dismissCompleteBlock = completeBlock
        
        let componentMaker = CKAlertViewComponentCircularProgressMaker()
        componentMaker.alertTitle = alertTitle
        componentMaker.cancelButtonTitle = cancelButtonTitle
        componentMaker.otherButtonTitles = nil
        
        installComponentMaker(maker: componentMaker)
        
        componentMaker.alertMessage = alertMessage
        componentMaker.alertDetailMessage = detailMessage
        componentMaker.progress = progress
        componentMaker.progressMessage = progressMessage
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public override func show() {
        super.show()
    }
}


class CKAlertViewCircularProgressHeaderView : CKAlertViewHeaderView {
    
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
            
            
            let btnX = UIButton()
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


class CKAlertViewCircularProgressBodyView : CKAlertViewBodyView {
    let progressView = DACircularProgressView()
    let lblMessage = UILabel()
    let lblDetailMessage = UILabel()
    let lblProgressMessage = UILabel()
    
    override func makeLayout() {
        
        progressView.roundedCorners = 1
        progressView.thicknessRatio = 0.1
        progressView.trackTintColor = HexColor(0xe6e6e6, 1)
        progressView.progressTintColor = HexColor(0x39b54a, 1)
        addSubview(progressView)
        progressView.snp.makeConstraints { (make) in
            make.height.width.equalTo(100)
            make.top.equalTo(self).offset(10)
            make.centerX.equalTo(self)
            
        }
        
        lblProgressMessage.font = UIFont.systemFont(ofSize: 16)
        lblProgressMessage.textColor = UIColor.black
        addSubview(lblProgressMessage)
        lblProgressMessage.snp.makeConstraints { (make) in
            make.centerX.centerY.equalTo(progressView)
        }
        
        lblMessage.textColor = HexColor(0x333333, 1)
        lblMessage.textAlignment = .center
        lblMessage.font = UIFont.systemFont(ofSize: 13)
        addSubview(lblMessage)
        lblMessage.snp.makeConstraints { (make) in
            make.top.equalTo(progressView.snp.bottom).offset(25)
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
        }
        
        lblDetailMessage.textColor = HexColor(0x999999, 1)
        lblDetailMessage.textAlignment = .center
        lblDetailMessage.font = UIFont.systemFont(ofSize: 11)
        addSubview(lblDetailMessage)
        lblDetailMessage.snp.makeConstraints { (make) in
            make.left.right.equalTo(lblMessage)
            make.top.equalTo(lblMessage.snp.bottom).offset(10)
            make.bottom.equalTo(self).offset(-30)
        }
        
    }
    
}



class CKAlertViewComponentCircularProgressMaker :CKAlertViewComponentMaker {
    var progress :Float = 0.0 {
        didSet {
            if let circularBodyView = bodyView as? CKAlertViewCircularProgressBodyView {
                circularBodyView.progressView.setProgress(CGFloat(progress), animated: true)
            }
        }
    }
    
    var progressMessage :String?  {
        didSet {
            if let circularBodyView = bodyView as? CKAlertViewCircularProgressBodyView {
                circularBodyView.lblProgressMessage.text = progressMessage
            }
        }
    }
    
    var alertMessage :String? {
        didSet {
            if let circularBodyView = bodyView as? CKAlertViewCircularProgressBodyView {
                circularBodyView.lblMessage.text = alertMessage
            }
        }
    }
    
    var alertDetailMessage :String? {
        didSet {
            if let circularBodyView = bodyView as? CKAlertViewCircularProgressBodyView {
                circularBodyView.lblDetailMessage.text = alertDetailMessage
            }
        }
    }
    
    
    override func layoutHeader() -> CKAlertViewComponent? {
        let headerView = CKAlertViewCircularProgressHeaderView()
        headerView.alertTitle = alertTitle
        headerView.delegate = delegate
        
        return headerView
    }
    
    override func layoutBody() -> CKAlertViewComponent? {
        let bodyView = CKAlertViewCircularProgressBodyView()
        
        return bodyView
    }
    
}
