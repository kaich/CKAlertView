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
        alert?.show(title: "无法安装‘爱奇艺视频播放’，因苹果系统的限制您可以选择如下方法解决", message: "Swift 是一门进行 iOS 和 OS X 应用开发的新语言。然而，如果你有 C 或者 Objective-C 开发经验的话，你会发现 Swift 的很多内容都是你熟悉的", cancelButtonTitle: "确定", otherButtonTitles: nil){ index in
            self.lblMessage.text = "One button alert dismissed"
        }
        
    }
    
    @IBAction func showDoubleButtonAlert(_ sender: AnyObject) {
        alert = CKAlertView()
        alert?.show(title: "无法安装‘爱奇艺视频播放’，因苹果系统的限制您可以选择如下方法解决", message: "Swift 是一门进行 iOS 和 OS X 应用开发的新语言。然而，如果你有 C 或者 Objective-C 开发经验的话，你会发现 Swift 的很多内容都是你熟悉的", cancelButtonTitle: "取消", otherButtonTitles: ["确定"]){ index in
            self.lblMessage.text = "\(index) clicked,two button alert dismissed"
        }
    }

    @IBAction func showMultiButtonAlert(_ sender: AnyObject) {
        alert = CKAlertView()
        alert?.show(title: "无法安装‘爱奇艺视频播放’，因苹果系统的限制您可以选择如下方法解决", message: "Swift 是一门进行 iOS 和 OS X 应用开发的新语言。然而，如果你有 C 或者 Objective-C 开发经验的话，你会发现 Swift 的很多内容都是你熟悉的", cancelButtonTitle: "取消", otherButtonTitles: ["确定","重试","结束"]){ index in
            self.lblMessage.text = "\(index) clicked,multi button alert dismissed"
        }
    }
}

