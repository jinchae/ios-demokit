//
//  SplashViewController.swift
//  DemoKit
//
//  Created by 정진채 on 8/17/25.
//

import UIKit

class SplashViewController:BaseViewController{
    //--------------------------------------------------------
    // MARK : IBOulet
    // * Storyboard 와 Controller 와 Component 연결
    //--------------------------------------------------------
    
    //--------------------------------------------------------
    // MARK : Local variables
    // * 변수 선언
    //--------------------------------------------------------
    
    //--------------------------------------------------------
    // MARK : initView
    //--------------------------------------------------------
    
    //--------------------------------------------------------
    // MARK : Override
    // * LifeCycle View 초기화
    //--------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Tools.shared.hasJailbreak(){
            //탈옥
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                let alert =  UIAlertController(title: "알림", message: "위변조 된 앱과 탈옥 된 폰으로\n 본 서비스를 이용할 수 없습니다.", preferredStyle: .alert)
                let cancel = UIAlertAction(title: "확인", style: .cancel, handler: {_ in
                    UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
                })
                alert.addAction(cancel)
                self.present(alert, animated: true, completion: nil)
            })
            return
        }
        
        if !Tools.shared.isInternetAvailable(){
            //인터넷 연결 여부
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                let alert =  UIAlertController(title: "알림", message: "인터넷 연결을\n확인해주세요.", preferredStyle: .alert)
                let cancel = UIAlertAction(title: "확인", style: .cancel, handler: {_ in
                    UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
                })
                alert.addAction(cancel)
                self.present(alert, animated: true, completion: nil)
            })
            return
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            GeneralHelper.shared.appDelegate.createMainViewController()
        })
    }
    
    //--------------------------------------------------------
    // MARK : Local Functions
    //--------------------------------------------------------
    
    //--------------------------------------------------------
    // MARK : API Request
    //--------------------------------------------------------
    
    
    //--------------------------------------------------------
    // MARK : Gesture Action
    //--------------------------------------------------------
    
}

//--------------------------------------------------------
// MARK : Extension TableView
//--------------------------------------------------------

//--------------------------------------------------------
// MARK : Extension CollectionView
//--------------------------------------------------------

//--------------------------------------------------------
// MARK : Extension Cell
//--------------------------------------------------------

//--------------------------------------------------------
// MARK : Extension Alert
//--------------------------------------------------------

//--------------------------------------------------------
// MARK : Extension Other
//--------------------------------------------------------



