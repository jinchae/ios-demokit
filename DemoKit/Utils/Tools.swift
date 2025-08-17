//
//  Tools.swift
//  DemoKit
//
//  Created by 정진채 on 8/17/25.
//

import UIKit
import Foundation
import WebKit
import SystemConfiguration
import MobileCoreServices

class Tools:UIViewController{
    
    static let shared = Tools()
    
    enum fontType:String{
        case regular = "regular"
        case bold = "bold"
        case medium = "medium"
        case black = "black"
        case thin = "thin"
        case light = "light"
    }
    
    func getFont(_ font:fontType = .regular,_ size:CGFloat = 14) -> UIFont{
        switch font {
        case .regular:
            return UIFont(name: "NotoSansKR-Regular", size: size)!
        case .medium:
            return UIFont(name: "NotoSansKR-Medium", size: size)!
        case .bold:
            return UIFont(name: "NotoSansKR-Bold", size: size)!
        case .thin:
            return UIFont(name: "NotoSansKR-Thin", size: size)!
        case .light:
            return UIFont(name: "NotoSansKR-Light", size: size)!
        case .black:
            return UIFont(name: "NotoSansKR-Black", size: size)!
        default:
            return UIFont(name: "NotoSansKR-Regular", size: size)!
        }
    }
    
    func getBaselineOffset(_ type:fontType = .regular,_ size:CGFloat = 14) -> CGFloat{
        let font = self.getFont(type,size)
        let dividend = font.lineHeight - font.pointSize
        return dividend / 2 - font.descender / 2
    }
    
    
    func getColor(_ code:String,_ alpha:CGFloat = 1.0) -> UIColor{
        return UIColor(hexString: code, alpha: alpha)!
    }
    
    //인터넷 연결 여부
    func isInternetAvailable() -> Bool{
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()

        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }

        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)

        return (isReachable && !needsConnection)
    }
    
    func hasJailbreak() -> Bool {
            
        guard let cydiaUrlScheme = NSURL(string: "cydia://package/com.example.package") else { return false }
        
        if UIApplication.shared.canOpenURL(cydiaUrlScheme as URL) { return true }
        
        #if arch(i386) || arch(x86_64)
        return false
        #endif
            
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: "/Applications/Cydia.app") ||
            fileManager.fileExists(atPath: "/Library/MobileSubstrate/MobileSubstrate.dylib") ||
            fileManager.fileExists(atPath: "/bin/bash") ||
            fileManager.fileExists(atPath: "/usr/sbin/sshd") ||
            fileManager.fileExists(atPath: "/etc/apt") ||
            fileManager.fileExists(atPath: "/usr/bin/ssh") ||
            fileManager.fileExists(atPath: "/private/var/lib/apt") {
            return true
        }
        if canOpen(path: "/Applications/Cydia.app") ||
            canOpen(path: "/Library/MobileSubstrate/MobileSubstrate.dylib") ||
            canOpen(path: "/bin/bash") ||
            canOpen(path: "/usr/sbin/sshd") ||
            canOpen(path: "/etc/apt") ||
            canOpen(path: "/usr/bin/ssh") {
            return true
        }
        let path = "/private/" + NSUUID().uuidString
        do {
            try "anyString".write(toFile: path, atomically: true, encoding: String.Encoding.utf8)
            try fileManager.removeItem(atPath: path)
            return true
        } catch {
            return false
        }
    }
    
    func canOpen(path: String) -> Bool {
        let file = fopen(path, "r")
        guard file != nil else { return false }
        fclose(file)
        return true
    }
    
    func printLog(_ log:Any){
        let msg = """
        =========================================
        \(log)
        =========================================
        """
        #if DEBUG
        print(msg)
        #else
        NSLog("%@", msg)
        #endif
    }
    
    func openExternalBrowser(_ url:URL,_ completionHandler:((Bool) -> Void)? = nil){
        UIApplication.shared.open(url, options: [:], completionHandler: completionHandler)
    }
}



