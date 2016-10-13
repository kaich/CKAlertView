# CKAlertView

[![CI Status](http://img.shields.io/travis/kaich/CKAlertView.svg?style=flat)](https://travis-ci.org/kaich/CKAlertView)
[![Version](https://img.shields.io/cocoapods/v/CKAlertView.svg?style=flat)](http://cocoapods.org/pods/CKAlertView)
[![License](https://img.shields.io/cocoapods/l/CKAlertView.svg?style=flat)](http://cocoapods.org/pods/CKAlertView)
[![Platform](https://img.shields.io/cocoapods/p/CKAlertView.svg?style=flat)](http://cocoapods.org/pods/CKAlertView)

## Usage

简单的使用方式，调用如下方式代码就可以显示你要的弹出框

	CKAlertView().show(title: "无法安装‘爱奇艺视频播放’，因苹果系统的限制您可以选择如下方法解决", message: ["Swift 是一门进行 iOS 和 OS X 应用开发的新语言。然而，如果你有 C 或者 Objective-C 开发经验的话，你会发现 Swift 的很多内容都是你熟悉的"], cancelButtonTitle: "确定", otherButtonTitles: nil){ index in
            self.lblMessage.text = "One button alert dismissed"
        }


## Alert Style

提供多种样式的弹出框，尽量少的代码提供给扩展弹出框样式。目前支持样式如下：  

<img src="./Screenshot/standard_one.png" width="200">
<img src="./Screenshot/standard_two.png" width="200">
<img src="./Screenshot/standard_multi.png" width="200">
<img src="./Screenshot/body_image.png" width="200">
<img src="./Screenshot/header_image.png" width="200">
<img src="./Screenshot/major_action.png" width="200">


## Requirements

## Installation

CKAlertView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "CKAlertView"
```

## Author

kaich, chengkai1853@163.com

## License

CKAlertView is available under the MIT license. See the LICENSE file for more info.
