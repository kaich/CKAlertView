//
//  CKAlertView+Custom.swift
//  Pods
//
//  Created by mac on 16/11/2.
//
//

import UIKit

extension CKAlertView {
    
    
    /// 显示自定义的alert,将自定义的视图添加到headerView, bodyView, footerView上即可。可以只添加到任意一个视图上
    ///
    /// - parameter buildViewBlock: headerView 头部 ，bodyView 主体 ，footerView 尾部
    public convenience init(buildViewBlock:((_ headerView :UIView, _ bodyView :UIView, _ footerView :UIView) -> Void)) {
        self.init(nibName: nil, bundle: nil)
        
        let componentMaker = CKAlertViewComponentCustomMaker()
        installComponentMaker(maker: componentMaker)
        
        buildViewBlock(self.headerView, self.bodyView, self.footerView)
        
        show()
    }

}


class CKAlertViewComponentCustomMaker :CKAlertViewComponentBaseMaker {
    
    override func makeHeader() -> CKAlertViewComponent? {
        let headerView = CKAlertViewEmptyComponent()
        return headerView
    }
    
    override func makeBody() -> CKAlertViewComponent? {
        let bodyView = CKAlertViewEmptyComponent()
        return bodyView
    }
    
    override func makeFooter() -> CKAlertViewComponent? {
        let footerView = CKAlertViewEmptyComponent()
        footerView.delegate = delegate
        return footerView
    }
    
}

class CKAlertViewEmptyComponent : CKAlertViewComponent {
    
    override func setup() {
    }
    
    override func makeLayout() {
    }
    
}
