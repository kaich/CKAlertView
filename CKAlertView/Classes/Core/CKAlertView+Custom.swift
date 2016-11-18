//
//  CKAlertView+Custom.swift
//  Pods
//
//  Created by mac on 16/11/2.
//
//

import UIKit

extension CKAlertView {
    
    
    /// 显示自定义的alert,将自定义的视图添加到headerView, bodyView上即可, footerView为默认的button列表，如果你想自定义按钮，请直接加在bodyView上。可以只添加到任意一个视图上
    ///
    /// - parameter buildViewBlock: headerView 头部 ，bodyView 主体 ，footerView 尾部
    public convenience init(title alertTitle: CKAlertViewStringable? = nil, cancelButtonTitle :CKAlertViewStringable? = nil, otherButtonTitles :[CKAlertViewStringable]? = nil, buildViewBlock:((_ bodyView :UIView) -> Void), completeBlock :(((Int) -> Void))? = nil) {
        self.init(nibName: nil, bundle: nil)
        
        let componentMaker = CKAlertViewComponentCustomMaker()
        
        componentMaker.alertTitle = alertTitle
        componentMaker.cancelButtonTitle = cancelButtonTitle
        componentMaker.otherButtonTitles = otherButtonTitles
        
        installComponentMaker(maker: componentMaker)
        
        buildViewBlock(self.bodyView)
    }

}


class CKAlertViewComponentCustomMaker :CKAlertViewComponentBaseMaker {
    
    override func makeHeader() -> CKAlertViewComponent? {
        let headerView = CKAlertViewHeaderView()
        headerView.alertTitle = alertTitle
        
        return headerView
    }
    
    override func makeBody() -> CKAlertViewComponent? {
        let bodyView = CKAlertViewEmptyComponent()
        return bodyView
    }
    
    override func makeFooter() -> CKAlertViewComponent? {
        let footerView = CKAlertViewFooterView()
        
        footerView.cancelButtonTitle = cancelButtonTitle
        footerView.otherButtonTitles = otherButtonTitles
        
        return footerView
    }
    
}

class CKAlertViewEmptyComponent : CKAlertViewComponent {
    
    override func setup() {
    }
    
    override func makeLayout() {
    }
    
}
