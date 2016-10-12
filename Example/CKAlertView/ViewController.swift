//
//  ViewController.swift
//  CKAlertView
//
//  Created by kaich on 10/10/2016.
//  Copyright (c) 2016 kaich. All rights reserved.
//

import UIKit
import CKAlertView

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
        alert = CKAlertView()
        alert?.show(title: "无法安装‘爱奇艺视频播放’，因苹果系统的限制您可以选择如下方法解决", message: ["Swift 是一门进行 iOS 和 OS X 应用开发的新语言。然而，如果你有 C 或者 Objective-C 开发经验的话，你会发现 Swift 的很多内容都是你熟悉的"], cancelButtonTitle: "确定", otherButtonTitles: nil){ index in
            self.lblMessage.text = "One button alert dismissed"
        }
        
    }
    
    @IBAction func showDoubleButtonAlert(_ sender: AnyObject) {
        alert = CKAlertView()
        alert?.show(title: "无法安装‘爱奇艺视频播放’，因苹果系统的限制您可以选择如下方法解决", message: ["Swift 是一门进行 iOS 和 OS X 应用开发的新语言。然而，如果你有 C 或者 Objective-C 开发经验的话，你会发现 Swift 的很多内容都是你熟悉的"], cancelButtonTitle: "取消", otherButtonTitles: ["确定"]){ index in
            self.lblMessage.text = "\(index) clicked,two button alert dismissed"
        }
    }

    @IBAction func showMultiButtonAlert(_ sender: AnyObject) {
        alert = CKAlertView()
        alert?.show(title: "无法安装‘爱奇艺视频播放’，因苹果系统的限制您可以选择如下方法解决", message: ["Swift 是一门进行 iOS 和 OS X 应用开发的新语言。然而，如果你有 C 或者 Objective-C 开发经验的话，你会发现 Swift 的很多内容都是你熟悉的"], cancelButtonTitle: "取消", otherButtonTitles: ["确定","重试","结束"]){ index in
            self.lblMessage.text = "\(index) clicked,multi button alert dismissed"
        }
    }
    
    @IBAction func showImageBodyAlert(_ sender: AnyObject) {
        alert = CKAlertView()
        let image = UIImage(named: "sample_image")
        alert?.show(title: "不知道如何删除应用程序，按照如下的步骤简单快捷，您可以选择如下解决方法", image: image, cancelButtonTitle: "我知道了", otherButtonTitles: ["查看详情"], completeBlock: { (index) in
            self.lblMessage.text = "\(index) clicked, image message alert dismissed"
        })
    }
    
    @IBAction func showImageHeaderAlert(_ sender: AnyObject) {
        alert = CKAlertView()
        let image = UIImage(named: "repair_icon")
        alert?.show(image: image, title: "开始学习swift", message: ["如果你使用闭包来初始化属性的值，请记住在闭包执行时，实例的其它部分都还没有初始化。这意味着你不能够在闭包里访问其它的属性，就算这个属性有默认值也不允许"], cancelButtonTitle: "不再提醒", otherButtonTitles: ["我知道了"], completeBlock: { (index) in
            self.lblMessage.text = "\(index) clicked, image title alert dismissed"
        })
    }
}

