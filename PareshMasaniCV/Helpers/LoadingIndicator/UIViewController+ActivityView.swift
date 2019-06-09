//
//  UIViewController+LoadingIndicator.swift
//  PareshMasaniCV
//
//  Created by Paresh Masani on 09/06/2019.
//  Copyright © 2019 paresh. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

private struct AssociatedKeys {
    static var activityView = "ViewController_activityView"
}

extension UIViewController {
    
    private var activityViewController: LoadingViewController? {
        get {
            let value = objc_getAssociatedObject(self, &AssociatedKeys.activityView) as? LoadingViewController
            return value
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.activityView, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    func showActivityView() {
        let activityVC = activityViewController ?? LoadingViewController()
        activityViewController = activityVC
        
        addChild(activityVC)
        view.addSubview(activityVC.view)
        activityVC.view.frame = view.bounds
        activityVC.didMove(toParent: self)
    }
    
    func hideActivityView() {
        guard let activityVC = activityViewController else { return }
        activityVC.willMove(toParent: nil)
        activityVC.removeFromParent()
        activityVC.view.removeFromSuperview()
    }
}

extension Reactive where Base: UIViewController {
    
    var showsActivityView: Binder<Bool> {
        return Binder(base, binding: { (vc, active) in
            if active {
                vc.showActivityView()
            } else {
                vc.hideActivityView()
            }
        })
    }
    
}
