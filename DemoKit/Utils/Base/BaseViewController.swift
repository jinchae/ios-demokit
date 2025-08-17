//
//  BaseViewController.swift
//  tovao
//
//  Created by AbleCnC on 2021/04/01.
//

import UIKit

class BaseViewController: UIViewController {
    var row_count = 15
    var isLoadingList = true
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        self.view.layoutIfNeeded()
        self.view.setNeedsLayout()
    }
    
    func initView(){
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
    
    /// 화면 닫기
    func closeViewController() {
        self.view.endEditing(true)
        if let navigation = self.navigationController {
            if navigation.viewControllers.count == 1 {
                self.dismiss(animated: true, completion: nil)
            } else {
                navigation.popViewController(animated: true)
            }
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}

extension BaseViewController: UIGestureRecognizerDelegate {
    
}

