//
//  GeneralHelper.swift
//
//  Created by AbleCnC on 2021/04/01.
//

import UIKit
import WebKit
import AdSupport
import AppTrackingTransparency

class GeneralHelper{
    
    static let shared = GeneralHelper()
    
    let DeviceList = [
        /* iPod 5 */          "iPod5,1": "iPod Touch 5",
        /* iPod 6 */          "iPod7,1": "iPod Touch 6",
        /* iPhone 4 */        "iPhone3,1": "iPhone 4", "iPhone3,2": "iPhone 4", "iPhone3,3": "iPhone 4",
        /* iPhone 4S */       "iPhone4,1": "iPhone 4S",
        /* iPhone 5 */        "iPhone5,1": "iPhone 5", "iPhone5,2": "iPhone 5",
        /* iPhone 5C */       "iPhone5,3": "iPhone 5C", "iPhone5,4": "iPhone 5C",
        /* iPhone 5S */       "iPhone6,1": "iPhone 5S", "iPhone6,2": "iPhone 5S",
        /* iPhone 6 */        "iPhone7,2": "iPhone 6",
        /* iPhone 6 Plus */   "iPhone7,1": "iPhone 6 Plus",
        /* iPhone 6S */       "iPhone8,1": "iPhone 6S",
        /* iPhone 6S Plus */  "iPhone8,2": "iPhone 6S Plus",
        /* iPhone 7 */        "iPhone9,1": "iPhone 7", "iPhone9,3": "iPhone 7",
        /* iPhone 7 Plus */   "iPhone9,2": "iPhone 7 Plus", "iPhone9,4": "iPhone 7 Plus",
        /* iPhone SE */       "iPhone8,4": "iPhone SE",
        /* iPhone 8 */        "iPhone10,1": "iPhone 8", "iPhone10,4": "iPhone 8",
        /* iPhone 8 Plus */   "iPhone10,2": "iPhone 8 Plus", "iPhone10,5": "iPhone 8 Plus",
        /* iPhone X */        "iPhone10,3": "iPhone X", "iPhone10,6": "iPhone X",

        /* iPad 2 */          "iPad2,1": "iPad 2", "iPad2,2": "iPad 2", "iPad2,3": "iPad 2", "iPad2,4": "iPad 2",
        /* iPad 3 */          "iPad3,1": "iPad 3", "iPad3,2": "iPad 3", "iPad3,3": "iPad 3",
        /* iPad 4 */          "iPad3,4": "iPad 4", "iPad3,5": "iPad 4", "iPad3,6": "iPad 4",
        /* iPad Air */        "iPad4,1": "iPad Air", "iPad4,2": "iPad Air", "iPad4,3": "iPad Air",
        /* iPad Air 2 */      "iPad5,3": "iPad Air 2", "iPad5,4": "iPad Air 2",
        /* iPad Mini */       "iPad2,5": "iPad Mini", "iPad2,6": "iPad Mini", "iPad2,7": "iPad Mini",
        /* iPad Mini 2 */     "iPad4,4": "iPad Mini 2", "iPad4,5": "iPad Mini 2", "iPad4,6": "iPad Mini 2",
        /* iPad Mini 3 */     "iPad4,7": "iPad Mini 3", "iPad4,8": "iPad Mini 3", "iPad4,9": "iPad Mini 3",
        /* iPad Mini 4 */     "iPad5,1": "iPad Mini 4", "iPad5,2": "iPad Mini 4",
        /* iPad Pro */        "iPad6,7": "iPad Pro", "iPad6,8": "iPad Pro",
        /* AppleTV */         "AppleTV5,3": "AppleTV",
        /* Simulator */       "x86_64": "Simulator", "i386": "Simulator"
    ]

    
    let commonProcessPool = WKProcessPool()
    
    var notificationInfo:[AnyHashable: Any]?
    
    var appDelegate: AppDelegate {
      return UIApplication.shared.delegate as! AppDelegate
    }
    
    var screenRatio: CGFloat {
        return UIScreen.main.bounds.width / UIScreen.main.bounds.height
    }
    let bundleName = (Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String) ?? ""
    
    
    var idForVendor:String{
        return UIDevice.current.identifierForVendor?.uuidString ?? ""
    }
    
    var deviceName:String{
        return UIDevice.current.name
    }
    
    var deviceLanguage:String{
        return Bundle.main.preferredLocalizations[0]
    }
    
    var deviceModelReadable:String{
        return DeviceList[deviceModel] ?? deviceModel
    }
    
    var deviceModel:String{
        var systemInfo = utsname()
        uname(&systemInfo)

        let machine = systemInfo.machine
        var identifier = ""
        let mirror = Mirror(reflecting: machine)

        for child in mirror.children {
            let value = child.value

            if let value = value as? Int8, value != 0 {
                identifier.append(String(UnicodeScalar(UInt8(value))))
            }
        }

        return identifier
    }
    
    var appDisplayName: String? {
        if let bundleDisplayName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String {
            return bundleDisplayName
        } else if let bundleName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String {
            return bundleName
        }

        return nil
    }
    
    var appVersion: String {
        return (Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String) ?? ""
    }
    var buildVersion: String {
        return (Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String) ?? ""
    }
    
    var appBundleID: String? {
        return Bundle.main.bundleIdentifier
    }
    
    var appVersionAndBuild: String? {
        if appVersion == buildVersion {
            return "v\(appVersion)"
        } else {
            return "v\(appVersion)(\(buildVersion))"
        }
    }
    
    var systemName:String{
        return UIDevice.current.systemName
    }
    
    var systemVersion:String{
        return UIDevice.current.systemVersion
    }
    
    var systemFloatVersion:Float{
        return (systemVersion as NSString).floatValue
    }
    
    
    /// Return device version ""
    var deviceVersion: String {
        var size: Int = 0
        sysctlbyname("hw.machine", nil, &size, nil, 0)
        var machine = [CChar](repeating: 0, count: Int(size))
        sysctlbyname("hw.machine", &machine, &size, nil, 0)
        return String(cString: machine)
    }

    /// Returns true if DEBUG mode is active //TODO: Add to readme
    var isDebug: Bool {
    #if DEBUG
        return true
    #else
        return false
    #endif
    }

    /// Returns true if RELEASE mode is active //TODO: Add to readme
    var isRelease: Bool {
    #if DEBUG
        return false
    #else
        return true
    #endif
    }

    /// Returns true if its simulator and not a device //TODO: Add to readme
    var isSimulator: Bool {
    #if (arch(i386) || arch(x86_64)) && os(iOS)
        return true
    #else
        return false
    #endif
    }

    /// Returns true if its on a device and not a simulator //TODO: Add to readme
    var isDevice: Bool {
    #if (arch(i386) || arch(x86_64)) && os(iOS)
        return false
    #else
        return true
    #endif
    }
    
    var isInTestFlight: Bool {
        return Bundle.main.appStoreReceiptURL?.path.contains("sandboxReceipt") == true
    }

    var screenOrientation: UIInterfaceOrientation {
        return UIApplication.shared.statusBarOrientation
    }

    /// Returns screen width
    var screenWidth: CGFloat {

        if screenOrientation.isPortrait {
            return UIScreen.main.bounds.size.width
        } else {
            return UIScreen.main.bounds.size.height
        }
    }

    /// Returns screen height
    var screenHeight: CGFloat {
        if screenOrientation.isPortrait {
            return UIScreen.main.bounds.size.height
        } else {
            return UIScreen.main.bounds.size.width
        }
    }
    var screenStatusBarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.height
    }
    
    var screenHeightWithoutStatusBar: CGFloat {
        if screenOrientation.isPortrait {
            return UIScreen.main.bounds.size.height - screenStatusBarHeight
        } else {
            return UIScreen.main.bounds.size.width - screenStatusBarHeight
        }
    }

    var languageCode: String {
        return NSLocale.preferredLanguages.first?.components(separatedBy: "-").first ?? "xx"
    }
    var countryCode: String {
        return (Locale.current as NSLocale).object(forKey: .countryCode) as? String ?? ""
    }
    
    var idfa: String {
        return ASIdentifierManager.shared().advertisingIdentifier.uuidString
    }
    
}
