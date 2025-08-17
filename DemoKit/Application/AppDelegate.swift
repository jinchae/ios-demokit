//
//  AppDelegate+Extension.swift
//  DemoKit
//
//  Created by 정진채 on 8/17/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    public var isFirst:Bool = true
    
    public var mainViewController: MainViewController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        HTTPCookieStorage.shared.cookieAcceptPolicy = HTTPCookie.AcceptPolicy.always
        
        return true
    }
    

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
         // If you are receiving a notification message while your app is in the background,
         // this callback will not be fired till the user taps on the notification launching the application.
         // TODO: Handle data of notification
         // With swizzling disabled you must let Messaging know about the message, for Analytics
         // Messaging.messaging().appDidReceiveMessage(userInfo)
         // Print message ID.
        completionHandler(UIBackgroundFetchResult.newData)
    }
}

