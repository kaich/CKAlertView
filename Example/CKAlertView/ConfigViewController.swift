//
//  ConfigViewController.swift
//  CKAlertView
//
//  Created by mac on 2017/4/6.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit
import CKAlertView

class ConfigItem {
    var title :String?
    var value :String?
    var isOn :Bool = false
    var isHidden = true
    var valueChanged :((_ str :String) -> Void)?
    var isOnChanged :((_ isOn :Bool) -> Void)?
    
    init(title :String? , value :String? ,valueChanged :((_ str :String) -> Void)?, isOn :Bool = false, isHidden :Bool = true,isOnChanged :((_ isOn :Bool) -> Void)? = nil) {
        self.title = title
        self.value = value
        self.isOn = isOn
        self.isHidden = isHidden
        self.valueChanged = valueChanged
        self.isOnChanged = isOnChanged
    }
}

class ConfigViewController: UIViewController, UITableViewDataSource {
    var datasource = [ConfigItem]()
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        datasource.append(ConfigItem(title: "宽度", value: "\(CKAlertView.Config.contentWidth)", valueChanged: {(str :String) in CKAlertView.Config.contentWidth = CGFloat((str as NSString).floatValue)}, isOn: CKAlertView.Config.isFixedContentWidth, isHidden: false, isOnChanged:{ isOn in CKAlertView.Config.isFixedContentWidth = isOn }))
        datasource.append(ConfigItem(title: "标题字体", value: "\(CKAlertView.Config.titleFont.pointSize)", valueChanged: {(str :String) in CKAlertView.Config.titleFont = UIFont.boldSystemFont(ofSize: CGFloat((str as NSString).intValue))}))
        datasource.append(ConfigItem(title: "主体字体", value: "\(CKAlertView.Config.messageFont.pointSize)", valueChanged: {(str :String) in CKAlertView.Config.messageFont = UIFont.systemFont(ofSize: CGFloat((str as NSString).intValue))}))
        datasource.append(ConfigItem(title: "取消按钮文字颜色", value: "\(CKAlertView.Config.cancelTitleColor.toHexString())",valueChanged: {(str :String) in CKAlertView.Config.cancelTitleColor = HexColor(str.toHex(),1)}))
        datasource.append(ConfigItem(title: "其他按钮文字颜色", value: "\(CKAlertView.Config.otherTitleColor.toHexString())",valueChanged: {(str :String) in CKAlertView.Config.otherTitleColor = HexColor(str.toHex(),1)}))
        datasource.append(ConfigItem(title: "分割线颜色", value: "\(CKAlertView.Config.splitLineColor.toHexString())",valueChanged: {(str :String) in CKAlertView.Config.splitLineColor = HexColor(str.toHex(),1)}))
        datasource.append(ConfigItem(title: "分割线宽度", value: "\(CKAlertView.Config.splitLineWidth)",valueChanged: {(str :String) in CKAlertView.Config.splitLineWidth = CGFloat((str as NSString).floatValue)}))
        datasource.append(ConfigItem(title: "按钮高度", value: "\(CKAlertView.Config.buttonDefaultHeight)",valueChanged: {(str :String) in CKAlertView.Config.buttonDefaultHeight = CGFloat((str as NSString).floatValue)}))
        datasource.append(ConfigItem(title: "按钮背景色", value: "\(CKAlertView.Config.buttonDefaultBackgroundColor.toHexString())",valueChanged: {(str :String) in CKAlertView.Config.buttonDefaultBackgroundColor = HexColor(str.toHex(),1)}))
        datasource.append(ConfigItem(title: "多行按钮高度", value: "\(CKAlertView.Config.multiButtonHeight)",valueChanged: {(str :String) in CKAlertView.Config.multiButtonHeight = CGFloat((str as NSString).floatValue)}))
        datasource.append(ConfigItem(title: "多行按钮背景色", value: "\(CKAlertView.Config.multiButtonBackgroundColor.toHexString())",valueChanged: {(str :String) in CKAlertView.Config.multiButtonBackgroundColor = HexColor(str.toHex(),1)}))
        datasource.append(ConfigItem(title: "行间距", value: "\(CKAlertView.Config.lineSpacing)",valueChanged: {(str :String) in CKAlertView.Config.lineSpacing = CGFloat((str as NSString).floatValue)}))
        datasource.append(ConfigItem(title: "段落间隔", value: "\(CKAlertView.Config.paragraphSpacing)",valueChanged: {(str :String) in CKAlertView.Config.paragraphSpacing = CGFloat((str as NSString).floatValue)}))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func pressOK(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConfigTableViewCell", for: indexPath) as! ConfigTableViewCell
        let model = datasource[indexPath.row]
        cell.lblTitle.text = model.title
        cell.tfValue.text = model.value
        cell.swValue.isOn = model.isOn
        cell.swValue.isHidden = model.isHidden
        cell.valueChanged = { value in
            model.value = value
            if let valueChanged = model.valueChanged , let value = value {
                valueChanged(value)
            }
        }
        cell.isOnChanged = { isOn in
            model.isOn = isOn
            if let isOnChanged = model.isOnChanged {
                isOnChanged(isOn)
            }
        }
       
        return cell
    }

}

extension String {
    func toHex() -> Int {
        var finalStr = ""
        if self.hasPrefix("#")   {
            finalStr = self.replacingOccurrences(of: "#", with: "")
        }
        
        if self.hasPrefix("0x") {
            finalStr = self.replacingOccurrences(of: "0x", with: "")
        }
        
        if let result = Int(finalStr, radix: 16) {
            return result
        }
        
        return 0
    }
    
}


extension UIColor {
    
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return NSString(format:"0x%06x", rgb) as String
    }
}
