//
//  UIApplication+Extension.swift
//  tovao
//
//  Created by AbleCnC on 2021/04/01.
//

import UIKit
import SDWebImage
import Foundation

//-------------------------------------------------------------------------------------------
// MARK: - UIApplication
//-------------------------------------------------------------------------------------------

extension UIApplication {
    /// Run a block in background after app resigns activity
    public func runInBackground(_ closure: @escaping () -> Void, expirationHandler: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let taskID: UIBackgroundTaskIdentifier
            if let expirationHandler = expirationHandler {
                taskID = self.beginBackgroundTask(expirationHandler: expirationHandler)
            } else {
                taskID = self.beginBackgroundTask(expirationHandler: { })
            }
            closure()
            self.endBackgroundTask(taskID)
        }
    }
}

//-------------------------------------------------------------------------------------------
// MARK: - NSObject
//-------------------------------------------------------------------------------------------

extension NSObject {
    public var className: String {
        return type(of: self).className
    }

    public static var className: String {
        return String(describing: self)
    }
}

//-------------------------------------------------------------------------------------------
// MARK: - StoryBoardHelper
//-------------------------------------------------------------------------------------------
protocol StoryBoardHelper {}
extension UIViewController: StoryBoardHelper {}
extension StoryBoardHelper where Self: UIViewController {
  static func instantiate() -> Self {
    let storyboard = UIStoryboard(name: self.className, bundle: nil)
    return storyboard.instantiateViewController(withIdentifier: self.className) as! Self
  }
  
  static func instantiate(storyboard: String) -> Self {
    let storyboard = UIStoryboard(name: storyboard, bundle: nil)
    return storyboard.instantiateViewController(withIdentifier: self.className) as! Self
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - UIView
//-------------------------------------------------------------------------------------------
extension UIView{
    public func setCornerRadius(radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    /// getter and setter for the X coordinate of the center of a view.
    public var centerX: CGFloat {
        get {
            return self.center.x
        } set(value) {
            self.center.x = value
        }
    }
    
    /// getter and setter for the x coordinate of the frame's origin for the view.
    public var x: CGFloat {
        get {
            return self.frame.origin.x
        } set(value) {
            self.frame = CGRect(x: value, y: self.y, width: self.w, height: self.h)
        }
    }

    /// getter and setter for the y coordinate of the frame's origin for the view.
    public var y: CGFloat {
        get {
            return self.frame.origin.y
        } set(value) {
            self.frame = CGRect(x: self.x, y: value, width: self.w, height: self.h)
        }
    }

    /// variable to get the width of the view.
    public var w: CGFloat {
        get {
            return self.frame.size.width
        } set(value) {
            self.frame = CGRect(x: self.x, y: self.y, width: value, height: self.h)
        }
    }

    /// variable to get the height of the view.
    public var h: CGFloat {
        get {
            return self.frame.size.height
        } set(value) {
            self.frame = CGRect(x: self.x, y: self.y, width: self.w, height: value)
        }
    }
}

//-------------------------------------------------------------------------------------------
// MARK: - UILabel
//-------------------------------------------------------------------------------------------
extension UILabel{
    public func getEstimatedWidth() -> CGFloat {
        return sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: h)).width
    }
}

//-------------------------------------------------------------------------------------------
// MARK: - UICollectionView
//-------------------------------------------------------------------------------------------
extension UICollectionView {
    /// 컬렉션뷰에 Cell 을 등록
    ///
    /// - Parameter type: 타입
    public func registerCell<T: UICollectionViewCell>(type: T.Type) {
        let className = String(describing: type)
        let nib = UINib(nibName: className, bundle: nil)
        register(nib, forCellWithReuseIdentifier: className)
    }
  
    /// 컬렉션뷰에 Cell을 여러개 등록
    ///
    /// - Parameter types: 타입 배열
    public func registerCells<T: UICollectionViewCell>(types: [T.Type]) {
        types.forEach {
            registerCell(type: $0)
        }
    }
  
    /// 컬렉션뷰에 ReusableView 를 등록
    ///
    /// - Parameters:
    ///   - type: 타입
    ///   - kind: 기본 UICollectionView.elementKindSectionHeader
    public func registerReusableView<T: UICollectionReusableView>(type: T.Type, kind: String = UICollectionView.elementKindSectionHeader) {
        let className = String(describing: type)
        let nib = UINib(nibName: className, bundle: nil)
        register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: className)
    }
  
    /// 컬렉션뷰에 ReusableView 를 여러개 등록
    ///
    /// - Parameters:
    ///   - types: 타입 배열
    ///   - kind: 기본 UICollectionView.elementKindSectionHeader
    public func registerReusableViews<T: UICollectionReusableView>(types: [T.Type], kind: String = UICollectionView.elementKindSectionHeader) {
        types.forEach {
            registerReusableView(type: $0, kind: kind)
        }
    }
    
    
    func reloadData(completion:@escaping ()->()) {
        self.invalidateIntrinsicContentSize()
        UIView.animate(withDuration: 0, animations: reloadData)
            { _ in completion() }
    }
}

extension UICollectionReusableView {
    static var identifier: String { String(describing: Self.self) }
}

extension UIColor{
    /// init method with hex string and alpha(default: 1)
    public convenience init?(hexString: String, alpha: CGFloat = 1.0) {
        var formatted = hexString.replacingOccurrences(of: "0x", with: "")
        formatted = formatted.replacingOccurrences(of: "#", with: "")
        if let hex = Int(formatted, radix: 16) {
          let red = CGFloat(CGFloat((hex & 0xFF0000) >> 16)/255.0)
          let green = CGFloat(CGFloat((hex & 0x00FF00) >> 8)/255.0)
          let blue = CGFloat(CGFloat((hex & 0x0000FF) >> 0)/255.0)
          self.init(red: red, green: green, blue: blue, alpha: alpha)        } else {
            return nil
        }
    }
}

extension UIImageView{
    /**
     options
     .SDWebImageLowPriority : 스크롤 느림
     .SDWebImageContinueInBackground : 이미지 다운로드 (백그라운드 작업)
     .SDWebImageAllowInvalidSSLCertificates : SSL 미적용도 허용
     .SDWebImageHighPriority : 빠른로드
     .SDWebImageDelayPlaceholder : 로드 되기 전까지 placeHolder 노출
     */

    public func setImage(_ url:String,_ placeHolder:String = "",_ option:SDWebImageOptions = .progressiveLoad,_ centerCrop:Bool = true){
        guard let url = URL(string: url) else { return }
        if placeHolder.count > 0 {
            self.sd_setImage(with: url, placeholderImage: UIImage(named: placeHolder), options:.delayPlaceholder, completed: { (image, error, cacheType, imageURL) in
                if centerCrop{
                    self.image = image?.centerCrop()
                }
            })
        }else{
            self.sd_setImage(with: url, completed: { (image, error, cacheType, imageURL) in
                self.image = image?.centerCrop()
            })
        }
    }
}

extension UIImage{
    func centerCrop() -> UIImage{
        let sideLength = min(
          self.size.width,
          self.size.height
        )
            
        let sourceSize = self.size
        
         let xOffset = (sourceSize.width - sideLength) / 2.0
         let yOffset = (sourceSize.height - sideLength) / 2.0
         let cropRect = CGRect(
             x: xOffset,
             y: yOffset,
             width: sideLength,
             height: sideLength
         ).integral
         let sourceCGImage = self.cgImage!
         let croppedCGImage = sourceCGImage.cropping(to: cropRect)!
        return UIImage(cgImage: croppedCGImage)
    }
}

extension String{
    var url: URL? { URL(string: self) }
    
    func strikeThrough() -> NSAttributedString {
        let attributeString = NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0,attributeString.length))
        return attributeString
    }
}

extension Int {
    var decimalString: String {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        return f.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
