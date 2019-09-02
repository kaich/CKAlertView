//
//  ViewController.swift
//  CKAlertView
//
//  Created by kaich on 10/10/2016.
//  Copyright (c) 2016 kaich. All rights reserved.
//

import UIKit
import CKAlertView
import SnapKit

class ViewController: UIViewController {
    var alert :CKAlertView?

    @IBOutlet weak var lblMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showAlert(_ sender: AnyObject) {
        alert = CKAlertView(title: "无法安装‘爱奇艺视频播放’，因苹果系统的限制您可以选择如下方法解决", message: ["Swift 是一门进行iOS新语言"], cancelButtonTitle: "确定", otherButtonTitles: nil){ index in
            self.lblMessage.text = "One button alert dismissed"
        }
        alert?.animator = CKAlertDropDownAnimator(alertView: alert)
        alert?.show()
        
    }
    
    @IBAction func showDoubleButtonAlert(_ sender: AnyObject) {
        alert = CKAlertView(title: "创建一个其自身类型为可选类型的对象", message: ["如果一个类，结构体或枚举类型的对象，在构造自身的过程中有可能失败，则为其定义一个可失败构造器，是非常有必要的"], cancelButtonTitle: "取消", otherButtonTitles: ["确定"]){ index in
            self.lblMessage.text = "\(index) clicked,two button alert dismissed"
        }
        alert?.animator = CKAlertViewRippleAnimator(alertView: alert)
        alert?.show()
    }

    @IBAction func showMultiButtonAlert(_ sender: AnyObject) {
        alert = CKAlertView(title: "定义了一个名为TemperatureUnit的枚举类型", message: ["(Kelvin，Celsius，和 Fahrenheit)和一个被用来找到Character值所对应的枚举成员的可失败构造器。还能在参数不满足你所期望的条件时，导致构造失败"], cancelButtonTitle: "取消", otherButtonTitles: ["确定","重试","结束"]){ index in
            self.lblMessage.text = "\(index) clicked,multi button alert dismissed"
        }
        alert?.show()
    }
    
    @IBAction func showImageBodyAlert(_ sender: AnyObject) {
        let image = UIImage(named: "sample_image")
        alert = CKAlertView(title: "该可失败构造器传递合适的参数", image: image, cancelButtonTitle: "我知道了", otherButtonTitles: ["查看详情"], completeBlock: { (index) in
            self.lblMessage.text = "\(index) clicked, image message alert dismissed"
        })
        alert?.show()
    }
    
    @IBAction func showImageHeaderAlert(_ sender: AnyObject) {
        let image = UIImage(named: "repair_icon")
        alert = CKAlertView(image: image, title: "开始学习swift", message: ["如果你使用闭包来初始化属性的值","请记住在闭包执行时，实例的其它部分都还没有初始化。","$","这意味着你不能够在闭包里访问其它的属性，就算这个属性有默认值也不允许"], cancelButtonTitle: "不再提醒", otherButtonTitles: ["我知道了"], completeBlock: { (index) in
            self.lblMessage.text = "\(index) clicked, image title alert dismissed"
        })
        alert?.show()
    }
    
    @IBAction func showMajorActionAlert(_ sender: AnyObject) {
        alert = CKAlertView(title: "可失败构造器", message: ["西洋跳棋游戏在一副黑白格交替的 10x10 的棋盘中进行。为了呈现这副游戏棋盘，Checkerboard结构体定义了一个属性boardColors，它是一个包含 100 个布尔值的数组"], cancelButtonTitle: "我知道了", majorButtonTitle: "现在去设置", anotherButtonTitle: "不在提醒") {(index) in
            self.lblMessage.text = "\(index) clicked, major action alert dismissed"
        }
        alert?.show()
    }
    
    @IBAction func showCustomAlert(_ sender: AnyObject) {
        alert = CKAlertView(buildViewBlock: { (bodyView) in
            if let customView = Bundle.main.loadNibNamed("CustomView", owner: self, options: nil)?.first as? UIView {
                bodyView.addSubview(customView)
                customView.snp.makeConstraints({ (make) in
                    make.left.right.top.bottom.equalTo(bodyView)
                })
            }
        })
        alert?.show()
    }
    
    @IBAction func beginSearch(_ sender: AnyObject) {
        alert?.dismiss()
        self.lblMessage.text = "custom view, begin search click"
    }
    
    @IBAction func showAttributeStringAlert(_ sender: AnyObject) {
        alert = CKAlertView(title: "自定义文字颜色".ck_apply(color: UIColor.orange), message: ["Swift 是一门进行iOS新语言".ck_apply(color: UIColor.red),"这个函数的类型参数列紧随在两个类型参数需求的后面".ck_apply(color: UIColor.green),"如果循环体结束后未发现没有任何的不匹配，那表明两个容器匹配".ck_apply(color: UIColor.blue)], cancelButtonTitle: "确定".ck_apply(color: UIColor.purple), otherButtonTitles: nil){ index in
            self.lblMessage.text = "One button alert dismissed"
        }
        alert?.show()
    }
    
    @IBAction func showBlueCancelAlert(_ sender: AnyObject) {
        let alert = CKAlertView(isXHidden: false ,title: "多彩多姿Swift", message: ["方法是与某些特定类型相关联的函数。1、类、2、结构体、3、枚举都可以定义实例方法".ck_apply(color: UIColor.red),"$","新版本方法简介","1、具体的任务与功能。类、结构体、枚举也可以定义类型方法。实例方法是被类型的某个实例调用的方法。你也可以定义类型本身调用的方法，这种方法就叫做类型方法","2、实例方法是属于某个特定类、结构体或者枚举类型","$","函数参数不同，对于方法的参数，Swift 使用不同的默认处理方式，这可以让方法命名规范更容易写".ck_apply(color: UIColor.red)], blueCancelButtonTitle: "现在启用") { (index) in
            self.lblMessage.text = "blue cancel button alert dismissed"
        }
//        alert.animator = CKAlertDropDownAnimator(alertView: alert)
        alert.indentationPatternWidth = ["^\\d、" : 18]
        alert.show()
    }
    
    @IBAction func showSystemAlert(_ sender: AnyObject) {
        
        let alert = UIAlertController(title: "系统样式", message: "Swift 的String和Character类型提供了一个快速的，兼容 Unicode 的方式来处理代码中的文本信息。 创建和操作字符串的语法与 C 语言中字符串操作相似，轻量并且易读。 字符串连接操作只需要简单地通过+号将两个字符串相连即可。 与 Swift 中其他值一样，能否更改字符串的值，取决于其被定义为常量还是变量。", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func showCustomInputAlert(_ sender: AnyObject) {
        let alert = CKAlertView(title: "请输入您的密码",cancelButtonTitle: "取消", otherButtonTitles: ["确定"],buildViewBlock: { (body) in
                let textField = UITextField()
                textField.borderStyle = .roundedRect
                textField.returnKeyType = .done
                textField.isSecureTextEntry = true
                textField.placeholder = "请输入登录密码"
                textField.font = UIFont.systemFont(ofSize: 14)
                body.addSubview(textField)
                textField.snp.makeConstraints({ (make) in
                    make.left.equalTo(body).offset(20)
                    make.right.equalTo(body).offset(-20)
                    make.top.equalTo(body).offset(13)
                    make.height.equalTo(35)
                    make.bottom.equalTo(body).offset(-20)
                })
                
            })
        alert.show()
    }
    
    @IBAction func showFillImageHeaderAlert(_ sender: Any) {
        let image = UIImage(named: "updatePop_bg")
        alert = CKAlertView(image: image, title: nil, message: ["新版本更新了以下内容".ck_apply(color: .black),"1、增加游戏热点功能，优化各类榜单","2、完成兼容IOS9，增强用户体验","3、全新视觉，简约界面乐享沟通","$","注意：您好，如果您使用的是Intel CPU，您可以使用QQ Mac版 V1.4.1版本与您的好友沟通，点击下载。V1.4.1是专为使用Intel CPU的10.5 Leopard用户特别定制，使用更稳定，更流畅。".ck_apply(color: .red)], cancelButtonTitle: "不再提醒", otherButtonTitles: ["我知道了"], completeBlock: { (index) in
            self.lblMessage.text = "\(index) clicked, image title alert dismissed"
        })
        let config = CKAlertViewConfiguration()
        config.otherBackgroundColorColor = HexColor(0x1768c9, 1)
        config.otherTitleColor = .white
        alert?.config = config
        alert?.containerContentView.backgroundColor = UIColor.white
        alert?.show()
    }
    
    //MARK: - Config 
    
    //MARK: - extension
    var progress :Float = 0.0
    var progressMessage :String? = "0/100"
    var message :String? = "正在从网络下载图片"
    var detailMessage :String? = "已用时间 00:00:00"
    var timer :Timer? = nil
    @IBAction func showCircularProgressAlert(_ sender: AnyObject) {
        timer?.invalidate()
        progress = 0.0
        progressMessage = "0/100"
        alert = CKCircularProgressAlertView(title: "图片下载", progress: progress, progressMessage: progressMessage , message: message , detailMessage: detailMessage, cancelButtonTitle: "隐藏窗口", completeBlock: {(index) in
            self.lblMessage.text = "\(index) clicked, major action alert dismissed"
        })
        if let alert = self.alert as? CKCircularProgressAlertView {
            alert.show()
        }
        timer = Timer.scheduledTimer(timeInterval: 1,
                            target: self,
                            selector: #selector(self.updateTime),
                            userInfo: nil,
                            repeats: true)
    }
    
    @objc func updateTime() {
        if let alert = self.alert as? CKCircularProgressAlertView {
            progress = (progress + 0.1) / 1
            progressMessage = "\(progress * 100)/100"
            detailMessage = "已用时间 \(progress * 10)"
            
            alert.progress = progress
            alert.progressMessage = progressMessage!
            alert.alertDetailMessage = detailMessage!
        }
    }
    
    
}

