//
//  AppDelegate+Extension.swift
//  DemoKit
//
//  Created by 정진채 on 8/17/25.
//


import UIKit

extension AppDelegate{
    
    func getTopViewController() -> UIViewController {
        if var topController = UIApplication.shared.windows.first(where: {$0.isKeyWindow})?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        return UIViewController()
    }
    
    func dismissPresentViewController() {
        if (self.window?.rootViewController?.presentedViewController != nil) {
            self.window?.rootViewController?.dismiss(animated: false, completion: nil)
        }
    }
    
    func createMainViewController() {
        self.dismissPresentViewController()
        let mainVC = MainViewController.instantiate(storyboard: "Main")
        mainVC.modalPresentationStyle = .fullScreen
        let nav = UINavigationController(rootViewController: mainVC)
        self.window?.rootViewController = nav
        nav.isNavigationBarHidden = true
        
        let transition = CATransition()
        transition.duration = 0.8
        transition.type = CATransitionType.fade
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        self.window!.layer.add(transition, forKey: kCATransition)
        
        self.window?.makeKeyAndVisible()
    }
}

