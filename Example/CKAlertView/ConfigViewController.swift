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
        
        datasource.append(ConfigItem(title: "宽度", value: "\(CKAlertViewConfiguration.shared.contentWidth)", valueChanged: {(str :String) in CKAlertViewConfiguration.shared.contentWidth = CGFloat((str as NSString).floatValue)}, isOn: CKAlertViewConfiguration.shared.isFixedContentWidth, isHidden: false, isOnChanged:{ isOn in CKAlertViewConfiguration.shared.isFixedContentWidth = isOn }))
        datasource.append(ConfigItem(title: "标题字体", value: "\(CKAlertViewConfiguration.shared.titleFont.pointSize)", valueChanged: {(str :String) in CKAlertViewConfiguration.shared.titleFont = UIFont.boldSystemFont(ofSize: CGFloat((str as NSString).intValue))}))
        datasource.append(ConfigItem(title: "主体字体", value: "\(CKAlertViewConfiguration.shared.messageFont.pointSize)", valueChanged: {(str :String) in CKAlertViewConfiguration.shared.messageFont = UIFont.systemFont(ofSize: CGFloat((str as NSString).intValue))}))
        datasource.append(ConfigItem(title: "取消按钮文字颜色", value: "\(CKAlertViewConfiguration.shared.cancelTitleColor.toHexString())",valueChanged: {(str :String) in CKAlertViewConfiguration.shared.cancelTitleColor = HexColor(str.toHex(),1)}))
        datasource.append(ConfigItem(title: "取消按钮背景颜色", value: "\(CKAlertViewConfiguration.shared.cancelBackgroundColor.toHexString())",valueChanged: {(str :String) in CKAlertViewConfiguration.shared.cancelBackgroundColor = HexColor(str.toHex(),1)}))
        datasource.append(ConfigItem(title: "其他按钮文字颜色", value: "\(CKAlertViewConfiguration.shared.otherTitleColor.toHexString())",valueChanged: {(str :String) in CKAlertViewConfiguration.shared.otherTitleColor = HexColor(str.toHex(),1)}))
        datasource.append(ConfigItem(title: "其他按钮背景颜色", value: "\(CKAlertViewConfiguration.shared.otherBackgroundColorColor.toHexString())",valueChanged: {(str :String) in CKAlertViewConfiguration.shared.otherBackgroundColorColor = HexColor(str.toHex(),1)}))
        datasource.append(ConfigItem(title: "分割线颜色", value: "\(CKAlertViewConfiguration.shared.splitLineColor.toHexString())",valueChanged: {(str :String) in CKAlertViewConfiguration.shared.splitLineColor = HexColor(str.toHex(),1)}))
        datasource.append(ConfigItem(title: "分割线宽度", value: "\(CKAlertViewConfiguration.shared.splitLineWidth)",valueChanged: {(str :String) in CKAlertViewConfiguration.shared.splitLineWidth = CGFloat((str as NSString).floatValue)}))
        datasource.append(ConfigItem(title: "按钮高度", value: "\(CKAlertViewConfiguration.shared.buttonDefaultHeight)",valueChanged: {(str :String) in CKAlertViewConfiguration.shared.buttonDefaultHeight = CGFloat((str as NSString).floatValue)}))
        datasource.append(ConfigItem(title: "按钮背景色", value: "\(CKAlertViewConfiguration.shared.buttonDefaultBackgroundColor.toHexString())",valueChanged: {(str :String) in CKAlertViewConfiguration.shared.buttonDefaultBackgroundColor = HexColor(str.toHex(),1)}))
        datasource.append(ConfigItem(title: "多行按钮高度", value: "\(CKAlertViewConfiguration.shared.multiButtonHeight)",valueChanged: {(str :String) in CKAlertViewConfiguration.shared.multiButtonHeight = CGFloat((str as NSString).floatValue)}))
        datasource.append(ConfigItem(title: "多行按钮背景色", value: "\(CKAlertViewConfiguration.shared.multiButtonBackgroundColor.toHexString())",valueChanged: {(str :String) in CKAlertViewConfiguration.shared.multiButtonBackgroundColor = HexColor(str.toHex(),1)}))
        datasource.append(ConfigItem(title: "行间距", value: "\(CKAlertViewConfiguration.shared.lineSpacing)",valueChanged: {(str :String) in CKAlertViewConfiguration.shared.lineSpacing = CGFloat((str as NSString).floatValue)}))
        datasource.append(ConfigItem(title: "段落间隔", value: "\(CKAlertViewConfiguration.shared.paragraphSpacing)",valueChanged: {(str :String) in CKAlertViewConfiguration.shared.paragraphSpacing = CGFloat((str as NSString).floatValue)}))
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
