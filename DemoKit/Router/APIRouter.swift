//
//  APIRouter.swift
//  DemoKit
//
//  Created by 정진채 on 8/17/25.
//

//BRIDGE
enum Bridge: String {
    case showBrowser = "showBrowser"
}

typealias JSONDict = [String: AnyObject]
typealias APIParams = [String: AnyObject]?

enum APIURL: String {
    case sample = "sample"
}

class APIRouter {
    // Singleton
    static let shared = APIRouter()
    
    /// Simple API
    /// - Parameters:
    ///   - path: API URL
    ///   - method: HTTP Method
    ///   - parameters: parameter
    ///   - success: 성공
    ///   - fail: 실패
//    func api(path: APIURL, method: HTTPMethod = .post, parameters: [String: Any]? = [:], isIndicator:Bool? = true, encoding:ParameterEncoding = URLEncoding.default, success: @escaping(_ data: [String: Any])-> Void, fail: @escaping (_ error: Error?)-> Void) {
//        if isIndicator!{ SVProgressHUD.show() }
//        if path == .sample{
//            SVProgressHUD.dismiss()
//            var result:[String:Any] = [:]
//            result.updateValue("200", forKey: "return_code")
//            success(result)
//        }else{
//            AF.request(
//                GeneralHelper.getApiUrl() + path.rawValue,
//                method: method,
//                parameters: parameters,
//                encoding: encoding,
//                interceptor: AuthInterceptor.init())
//            .responseData{ (response) -> Void in
//                SVProgressHUD.dismiss()
//                switch response.result{
//                case .success(let data):
//                    do {
//                        let asJson = try JSONSerialization.jsonObject(with: data)
//                        success(asJson as! [String : Any])
//                    } catch {
//                        print("Error while decoding response: \(response.error?.errorDescription) from: \(String(data: data, encoding: .utf8))")
//                    }
//                    break
//                case .failure(let error):
//                    fail(error)
//                    break
//                }
//            }
//        }
//    }
//    
//    
//    /// Simple API
//    /// - Parameters:
//    ///   - path: API URL
//    ///   - method: HTTP Method
//    ///   - parameters: parameter
//    ///   - success: 성공
//    ///   - fail: 실패
//        
//    /// MultiPart API
//    /// - Parameters:
//    ///   - path: API URL
//    ///   - method: HTTP Method
//    ///   - parameters: parameter
//    ///   - success: 성공
//    ///   - fail: 실패
//        func api(path: APIURL, method: HTTPMethod = .post, parameters: [String: Any]?, isIndicator:Bool? = true, success: @escaping(_ data: [String: Any])-> Void, fail: @escaping (_ error: Error?)-> Void) {
//            
//            if isIndicator!{ SVProgressHUD.show() }
//            if path == .sample{
//                print("jinchae sample")
//                SVProgressHUD.dismiss()
//                var dic:[String:Any] = [:]
//                dic.updateValue("200", forKey: "return_code")
//                success(dic)
//            }else{
//                AF.upload(multipartFormData: { (multipartFormData) in
//                    for (key, value) in parameters!{
//                        if let value = value as? String{
//                            multipartFormData.append(value.data(using: .utf8)!, withName: key)
//                        }else if let value = value as? Data{
//                            multipartFormData.append(value, withName: key, fileName: "\(key).png", mimeType: "image/*")
//                        }else if let value = value as? Int{
//                            multipartFormData.append(String(value).data(using: .utf8)!, withName: key)
//                        }
//                    }
//                }, to: GeneralHelper.getApiUrl() + path.rawValue, method: method, interceptor: AuthInterceptor.init()
//                )
//                .responseData{ (response) -> Void in
//                SVProgressHUD.dismiss()
//                switch response.result{
//                case .success(let data):
//                    do {
//                        let asJson = try JSONSerialization.jsonObject(with: data)
//                        success(asJson as! [String : Any])
//                    } catch {
//                        print("Error while decoding response: \(response.error?.errorDescription) from: \(String(data: data, encoding: .utf8))")
//                    }
//                    break
//                case .failure(let error):
//                    fail(error)
//                    break
//                }
//            }
//           
//        }
//    }
}



