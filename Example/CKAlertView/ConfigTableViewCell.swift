//
//  ConfigTableViewCell.swift
//  CKAlertView
//
//  Created by mac on 2017/4/6.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit

class ConfigTableViewCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tfValue: UITextField!
    @IBOutlet weak var swValue: UISwitch!
    var valueChanged :((_ str :String?) -> Void)?
    var isOnChanged :((_ isOn :Bool) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func valueChanged(_ sender: Any) {
        if let valueChanged = valueChanged {
            valueChanged(tfValue.text)
        }
    }

    @IBAction func isOnChanged(_ sender: Any) {
        if let isOnChanged = isOnChanged {
            isOnChanged(swValue.isOn)
        }
    }
}
